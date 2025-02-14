//! Insert CIP36 Registration Query

use std::sync::Arc;

use cardano_blockchain_types::{Cip36, Slot, TxnIndex, VotingPubKey};
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbTxnIndex},
    },
    settings::cassandra_db,
};

/// Index Registration by Vote Key
const INSERT_CIP36_REGISTRATION_FOR_VOTE_KEY_QUERY: &str =
    include_str!("./cql/insert_cip36_for_vote_key.cql");

/// Insert CIP-36 Registration Invalid Query Parameters
#[derive(SerializeRow, Debug)]
pub(crate) struct Params {
    /// Voting Public Key
    vote_key: Vec<u8>,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    stake_public_key: Vec<u8>,
    /// Slot Number the cert is in.
    slot_no: DbSlot,
    /// Transaction Index.
    txn_index: DbTxnIndex,
    /// Is the registration Valid or not.
    valid: bool,
}

impl Params {
    /// Create a new Insert Query.
    pub fn new(
        vote_key: &VotingPubKey, slot_no: Slot, txn_index: TxnIndex, cip36: &Cip36, valid: bool,
    ) -> Self {
        Params {
            vote_key: vote_key
                .voting_pk()
                .map(|k| k.to_bytes().to_vec())
                .unwrap_or_default(),
            stake_public_key: cip36
                .stake_pk()
                .map(|s| s.to_bytes().to_vec())
                .unwrap_or_default(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            valid,
        }
    }

    /// Prepare Batch of Insert CIP-36 Registration Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CIP36_REGISTRATION_FOR_VOTE_KEY_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error,"Failed to prepare Insert CIP-36 Registration Query."),
        )
        .map_err(|error| {
            anyhow::anyhow!("{error}\n--\n{INSERT_CIP36_REGISTRATION_FOR_VOTE_KEY_QUERY}")
        })
    }
}
