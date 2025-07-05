//! Index CIP-36 Registrations.

pub(crate) mod insert_cip36;
pub(crate) mod insert_cip36_for_vote_key;
pub(crate) mod insert_cip36_invalid;

use std::sync::Arc;

use cardano_blockchain_types::{Cip36, MultiEraBlock, Slot, StakeAddress, TxnIndex};
use catalyst_types::hashes::Blake2b224Hash;
use scylla::Session;

use super::certs;
use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    settings::cassandra_db,
};

/// Insert CIP-36 Registration Queries
pub(crate) struct Cip36InsertQuery {
    /// Stake Registration Data captured during indexing.
    registrations: Vec<insert_cip36::Cip36Insert>,
    /// Stake Registration Data captured during indexing.
    invalid: Vec<insert_cip36_invalid::Cip36InvalidInsert>,
    /// Stake Registration Data captured during indexing.
    for_vote_key: Vec<insert_cip36_for_vote_key::Cip36ForVoteKeyInsert>,
    /// Stake Registration Data captured during indexing.
    stake_regs: Vec<certs::StakeRegistrationInsertQuery>,
}

impl Cip36InsertQuery {
    /// Create new data set for CIP-36 Registrations Insert Query Batch.
    pub(crate) fn new() -> Self {
        Cip36InsertQuery {
            registrations: Vec::new(),
            invalid: Vec::new(),
            for_vote_key: Vec::new(),
            stake_regs: Vec::new(),
        }
    }

    /// Prepare Batch of Insert Cip36 Registration Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<(SizedBatch, SizedBatch, SizedBatch)> {
        let insert_cip36_batch = insert_cip36::Cip36Insert::prepare_batch(session, cfg).await;
        let insert_cip36_invalid_batch =
            insert_cip36_invalid::Cip36InvalidInsert::prepare_batch(session, cfg).await;
        let insert_cip36_for_vote_key_addr_batch =
            insert_cip36_for_vote_key::Cip36ForVoteKeyInsert::prepare_batch(session, cfg).await;
        // Its a hack of inserting `stake_regs` during the indexing CIP 36 registrations.
        // Its done because some of the CIP 36 registrations contains some stake addresses which
        // are not actually some how registered using cardano certs.
        // Preparation of the `stake_regs` batch done under the `certs.rs`
        Ok((
            insert_cip36_batch?,
            insert_cip36_invalid_batch?,
            insert_cip36_for_vote_key_addr_batch?,
        ))
    }

    /// Index the CIP-36 registrations in a transaction.
    pub(crate) fn index(
        &mut self, index: TxnIndex, slot_no: Slot, block: &MultiEraBlock,
    ) -> anyhow::Result<()> {
        // Catalyst strict is set to true
        match Cip36::new(block, index, true) {
            // Check for CIP-36 validity and should be strict catalyst (only 1 voting key)
            // Note that in `validate_voting_keys` we already checked if the array has only one
            Ok(Some(cip36)) if cip36.is_valid() => {
                // This should always pass, because we already checked if the array has only one
                let voting_key = cip36.voting_pks().first().ok_or(anyhow::anyhow!(
                    "Valid CIP36 registration must have one voting key"
                ))?;

                let stake_pk = cip36.stake_pk().ok_or(anyhow::anyhow!(
                    "Valid CIP36 registration must have one stake public key"
                ))?;
                let stake_pk_hash = Blake2b224Hash::new(&stake_pk.to_bytes());
                let stake_address = StakeAddress::new(block.network(), false, stake_pk_hash);

                self.registrations.push(insert_cip36::Cip36Insert::new(
                    voting_key, slot_no, index, &cip36,
                ));
                self.for_vote_key
                    .push(insert_cip36_for_vote_key::Cip36ForVoteKeyInsert::new(
                        voting_key, slot_no, index, &cip36, true,
                    ));
                self.stake_regs
                    .push(certs::StakeRegistrationInsertQuery::new(
                        stake_address,
                        slot_no,
                        index,
                        *stake_pk,
                        false,
                        false,
                        false,
                        true,
                        None,
                    ));
            },
            // Invalid CIP-36 Registration
            Ok(Some(cip36)) => {
                // Cannot index an invalid CIP36, if there is no stake public key.
                if let Some(stake_pk) = cip36.stake_pk() {
                    if cip36.voting_pks().is_empty() {
                        self.invalid
                            .push(insert_cip36_invalid::Cip36InvalidInsert::new(
                                None, slot_no, index, &cip36,
                            ));
                    } else {
                        for voting_key in cip36.voting_pks() {
                            self.invalid
                                .push(insert_cip36_invalid::Cip36InvalidInsert::new(
                                    Some(voting_key),
                                    slot_no,
                                    index,
                                    &cip36,
                                ));
                            self.for_vote_key.push(
                                insert_cip36_for_vote_key::Cip36ForVoteKeyInsert::new(
                                    voting_key, slot_no, index, &cip36, false,
                                ),
                            );
                        }
                    }

                    let stake_pk_hash = Blake2b224Hash::new(&stake_pk.to_bytes());
                    let stake_address = StakeAddress::new(block.network(), false, stake_pk_hash);
                    self.stake_regs
                        .push(certs::StakeRegistrationInsertQuery::new(
                            stake_address,
                            slot_no,
                            index,
                            *stake_pk,
                            false,
                            false,
                            false,
                            true,
                            None,
                        ));
                }
            },
            _ => {},
        }
        Ok(())
    }

    /// Execute the CIP-36 Registration Indexing Queries.
    ///
    /// Consumes the `self` and returns a vector of futures.
    pub(crate) fn execute(self, session: &Arc<CassandraSession>) -> FallibleQueryTasks {
        let mut query_handles: FallibleQueryTasks = Vec::new();

        if !self.registrations.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::Cip36RegistrationInsertQuery,
                        self.registrations,
                    )
                    .await
            }));
        }

        if !self.invalid.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::Cip36RegistrationInsertErrorQuery,
                        self.invalid,
                    )
                    .await
            }));
        }

        if !self.for_vote_key.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::Cip36RegistrationForVoteKeyInsertQuery,
                        self.for_vote_key,
                    )
                    .await
            }));
        }

        if !self.stake_regs.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(PreparedQuery::StakeRegistrationInsertQuery, self.stake_regs)
                    .await
            }));
        }

        query_handles
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::db::index::tests::test_utils;

    #[test]
    fn index() {
        let block = test_utils::block_2();
        let mut query = Cip36InsertQuery::new();
        query.index(0.into(), 0.into(), &block).unwrap();
        assert_eq!(1, query.registrations.len());
        assert!(query.invalid.is_empty());
        assert_eq!(1, query.for_vote_key.len());
        assert_eq!(1, query.stake_regs.len());
    }
}
