//! Index CIP-36 Registrations.

pub(crate) mod insert_cip36;
pub(crate) mod insert_cip36_for_vote_key;
pub(crate) mod insert_cip36_invalid;

use std::sync::Arc;

use cardano_blockchain_types::{Cip36, MultiEraBlock, Slot, TxnIndex};
use scylla::Session;

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
    registrations: Vec<insert_cip36::Params>,
    /// Stake Registration Data captured during indexing.
    invalid: Vec<insert_cip36_invalid::Params>,
    /// Stake Registration Data captured during indexing.
    for_vote_key: Vec<insert_cip36_for_vote_key::Params>,
}

impl Cip36InsertQuery {
    /// Create new data set for CIP-36 Registrations Insert Query Batch.
    pub(crate) fn new() -> Self {
        Cip36InsertQuery {
            registrations: Vec::new(),
            invalid: Vec::new(),
            for_vote_key: Vec::new(),
        }
    }

    /// Prepare Batch of Insert Cip36 Registration Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<(SizedBatch, SizedBatch, SizedBatch)> {
        let insert_cip36_batch = insert_cip36::Params::prepare_batch(session, cfg).await;
        let insert_cip36_invalid_batch =
            insert_cip36_invalid::Params::prepare_batch(session, cfg).await;
        let insert_cip36_for_vote_key_addr_batch =
            insert_cip36_for_vote_key::Params::prepare_batch(session, cfg).await;

        Ok((
            insert_cip36_batch?,
            insert_cip36_invalid_batch?,
            insert_cip36_for_vote_key_addr_batch?,
        ))
    }

    /// Index the CIP-36 registrations in a transaction.
    pub(crate) fn index(&mut self, index: TxnIndex, slot_no: Slot, block: &MultiEraBlock) {
        // Catalyst strict is set to true
        match Cip36::new(block, index, true) {
            // Check for CIP-36 validity and should be strict catalyst (only 1 voting key)
            // Note that in `validate_voting_keys` we already checked if the array has only one
            Ok(Some(cip36)) if cip36.is_valid() && cip36.is_cip36().unwrap_or_default() => {
                // This should always pass, because we already checked if the array has only one
                if let Some(voting_key) = cip36.voting_pks().first() {
                    self.registrations.push(insert_cip36::Params::new(
                        voting_key, slot_no, index, &cip36,
                    ));

                    self.for_vote_key
                        .push(insert_cip36_for_vote_key::Params::new(
                            voting_key, slot_no, index, &cip36, true,
                        ));
                }
            },
            // Invalid CIP-36 Registration
            Ok(Some(cip36)) if cip36.is_cip36().unwrap_or_default() => {
                // Cannot index an invalid CIP36, if there is no stake public key.
                if cip36.stake_pk().is_some() {
                    if cip36.voting_pks().is_empty() {
                        self.invalid.push(insert_cip36_invalid::Params::new(
                            None, slot_no, index, &cip36,
                        ));
                    } else {
                        for voting_key in cip36.voting_pks() {
                            self.invalid.push(insert_cip36_invalid::Params::new(
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
                }
            },
            _ => {},
        }
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
                        PreparedQuery::Cip36RegistrationForStakeAddrInsertQuery,
                        self.for_vote_key,
                    )
                    .await
            }));
        }

        query_handles
    }
}
