//! Insert CIP36 Registration Query

use std::sync::Arc;

use cardano_blockchain_types::{Cip36, VotingPubKey};
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::cassandra_db,
};

/// Index Registration by Vote Key
const INSERT_CIP36_REGISTRATION_FOR_VOTE_KEY_QUERY: &str =
    include_str!("./cql/insert_cip36_for_vote_key.cql");

/// Insert CIP-36 Registration Invalid Query Parameters
#[derive(SerializeRow, Debug)]
pub(super) struct Params {
    /// Voting Public Key
    vote_key: Vec<u8>,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    stake_address: Vec<u8>,
    /// Slot Number the cert is in.
    slot_no: num_bigint::BigInt,
    /// Transaction Index.
    txn: i16,
    /// Is the registration Valid or not.
    valid: bool,
}

impl Params {
    /// Create a new Insert Query.
    pub fn new(
        vote_key: &VotingPubKey, slot_no: u64, txn: i16, cip36: &Cip36, valid: bool,
    ) -> Self {
        Params {
            vote_key: vote_key.voting_pk.to_bytes().to_vec(),
            stake_address: cip36
                .stake_pk
                .map(|s| s.to_bytes().to_vec())
                .unwrap_or_default(),
            slot_no: slot_no.into(),
            txn,
            valid,
        }
    }

    /// Prepare Batch of Insert CIP-36 Registration Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CIP36_REGISTRATION_FOR_VOTE_KEY_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = insert_queries {
            error!(error=%error,"Failed to prepare Insert CIP-36 Registration Query.");
        };

        insert_queries
    }
}
