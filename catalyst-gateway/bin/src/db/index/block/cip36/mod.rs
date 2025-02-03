//! Index CIP-36 Registrations.

pub(crate) mod insert_cip36;
pub(crate) mod insert_cip36_for_vote_key;
pub(crate) mod insert_cip36_invalid;

use std::sync::Arc;

use cardano_chain_follower::{Metadata, MultiEraBlock};
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
    pub(crate) fn index(
        &mut self, txn: usize, txn_index: i16, slot_no: u64, block: &MultiEraBlock,
    ) {
        if let Some(decoded_metadata) = block.txn_metadata(txn, Metadata::cip36::LABEL) {
            #[allow(irrefutable_let_patterns)]
            if let Metadata::DecodedMetadataValues::Cip36(cip36) = &decoded_metadata.value {
                // Check if we are indexing a valid or invalid registration.
                // Note, we ONLY care about catalyst, we should only have 1 voting key, if not, call
                // it an error.
                if decoded_metadata.report.is_empty() && cip36.voting_keys.len() == 1 {
                    // Always true, because we already checked if the array has only one entry.
                    if let Some(vote_key) = cip36.voting_keys.first() {
                        self.registrations.push(insert_cip36::Params::new(
                            vote_key, slot_no, txn_index, cip36,
                        ));
                        self.for_vote_key
                            .push(insert_cip36_for_vote_key::Params::new(
                                vote_key, slot_no, txn_index, cip36, true,
                            ));
                    }
                } else if cip36.stake_pk.is_some() {
                    // We can't index an error, if there is no stake public key.
                    if cip36.voting_keys.is_empty() {
                        self.invalid.push(insert_cip36_invalid::Params::new(
                            None,
                            slot_no,
                            txn_index,
                            cip36,
                            decoded_metadata.report.clone(),
                        ));
                    }
                    for vote_key in &cip36.voting_keys {
                        self.invalid.push(insert_cip36_invalid::Params::new(
                            Some(vote_key),
                            slot_no,
                            txn_index,
                            cip36,
                            decoded_metadata.report.clone(),
                        ));
                        self.for_vote_key
                            .push(insert_cip36_for_vote_key::Params::new(
                                vote_key, slot_no, txn_index, cip36, false,
                            ));
                    }
                }
            }
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
