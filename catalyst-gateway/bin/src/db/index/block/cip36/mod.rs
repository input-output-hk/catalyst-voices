//! Index CIP-36 Registrations.

pub(crate) mod insert_cip36;
pub(crate) mod insert_cip36_for_vote_key;
pub(crate) mod insert_cip36_invalid;

use std::sync::Arc;

use cardano_blockchain_types::{Cip36, MultiEraBlock, Slot, StakeAddress, TxnIndex};
use catalyst_types::hashes::Blake2b224Hash;

use super::stake_reg;
use crate::db::index::{
    queries::{FallibleQueryTasks, PreparedQuery},
    session::CassandraSession,
};

/// Insert CIP-36 Registration Queries
pub(crate) struct Cip36InsertQuery {
    /// Stake Registration Data captured during indexing.
    valid_regs: Vec<insert_cip36::Params>,
    /// Stake Registration Data captured during indexing.
    invalid_regs: Vec<insert_cip36_invalid::Params>,
    /// Stake Registration Data captured during indexing.
    for_vote_key: Vec<insert_cip36_for_vote_key::Params>,
    /// Stake Registration Data captured during indexing.
    stake_regs: Vec<stake_reg::StakeRegistrationInsertQuery>,
}

impl Cip36InsertQuery {
    /// Create new data set for CIP-36 Registrations Insert Query Batch.
    pub(crate) fn new() -> Self {
        Cip36InsertQuery {
            valid_regs: Vec::new(),
            invalid_regs: Vec::new(),
            for_vote_key: Vec::new(),
            stake_regs: Vec::new(),
        }
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

                self.valid_regs.push(insert_cip36::Params::new(
                    voting_key, slot_no, index, &cip36,
                ));
                self.for_vote_key
                    .push(insert_cip36_for_vote_key::Params::new(
                        voting_key, slot_no, index, &cip36, true,
                    ));
                self.stake_regs
                    .push(stake_reg::StakeRegistrationInsertQuery::new(
                        stake_address,
                        slot_no,
                        index,
                        *stake_pk,
                        false,
                        None,
                        None,
                        Some(true),
                        None,
                    ));
            },
            // Invalid CIP-36 Registration
            Ok(Some(cip36)) => {
                // Cannot index an invalid CIP36, if there is no stake public key.
                if let Some(stake_pk) = cip36.stake_pk() {
                    if cip36.voting_pks().is_empty() {
                        self.invalid_regs.push(insert_cip36_invalid::Params::new(
                            None, slot_no, index, &cip36,
                        ));
                    } else {
                        for voting_key in cip36.voting_pks() {
                            self.invalid_regs.push(insert_cip36_invalid::Params::new(
                                Some(voting_key),
                                slot_no,
                                index,
                                &cip36,
                            ));
                            self.for_vote_key
                                .push(insert_cip36_for_vote_key::Params::new(
                                    voting_key, slot_no, index, &cip36, false,
                                ));
                        }
                    }
                    let stake_pk_hash = Blake2b224Hash::new(&stake_pk.to_bytes());
                    let stake_address = StakeAddress::new(block.network(), false, stake_pk_hash);
                    self.stake_regs
                        .push(stake_reg::StakeRegistrationInsertQuery::new(
                            stake_address,
                            slot_no,
                            index,
                            *stake_pk,
                            false,
                            None,
                            None,
                            Some(true),
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

        if !self.valid_regs.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(PreparedQuery::Cip36RegistrationInsertQuery, self.valid_regs)
                    .await
            }));
        }

        if !self.invalid_regs.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::Cip36RegistrationInsertErrorQuery,
                        self.invalid_regs,
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
        assert_eq!(1, query.valid_regs.len());
        assert!(query.invalid_regs.is_empty());
        assert_eq!(1, query.for_vote_key.len());
        assert_eq!(1, query.stake_regs.len());
    }
}
