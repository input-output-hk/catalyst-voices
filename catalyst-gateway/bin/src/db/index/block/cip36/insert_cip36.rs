//! Insert CIP36 Registration Query

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::{Cip36, Slot, TxnIndex, VotingPubKey};
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbTxnIndex},
    },
    settings::cassandra_db,
};

/// Index Registration by Stake Address
const INSERT_CIP36_REGISTRATION_QUERY: &str = include_str!("./cql/insert_cip36.cql");

/// Insert CIP-36 Registration Query Parameters
#[derive(SerializeRow, Clone)]
pub(crate) struct Params {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    stake_address: Vec<u8>,
    /// Nonce value after normalization.
    nonce: num_bigint::BigInt,
    /// Slot Number the cert is in.
    slot_no: DbSlot,
    /// Transaction Index.
    txn_index: DbTxnIndex,
    /// Voting Public Key
    vote_key: Vec<u8>,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    payment_address: MaybeUnset<Vec<u8>>,
    /// Is the stake address a script or not.
    is_payable: bool,
    /// Raw nonce value.
    raw_nonce: num_bigint::BigInt,
    /// Is the Registration CIP36 format, or CIP15
    cip36: bool,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let payment_address = match self.payment_address {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(ref v) => &hex::encode(v),
        };
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address)
            .field("nonce", &self.nonce)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("vote_key", &self.vote_key)
            .field("payment_address", &payment_address)
            .field("is_payable", &self.is_payable)
            .field("raw_nonce", &self.raw_nonce)
            .field("cip36", &self.cip36)
            .finish()
    }
}

impl Params {
    /// Create a new Insert Query.
    pub fn new(vote_key: &VotingPubKey, slot_no: Slot, txn_index: TxnIndex, cip36: &Cip36) -> Self {
        let stake_address = cip36
            .stake_pk()
            .map_or_else(Vec::new, |s| s.to_bytes().to_vec());
        let vote_key = vote_key
            .voting_pk()
            .map_or_else(Vec::new, |v| v.to_bytes().to_vec());
        let payment_address = match cip36.payment_address() {
            Some(a) => MaybeUnset::Set(a.to_vec()),
            None => MaybeUnset::Unset,
        };
        let is_cip36 = cip36.is_cip36().unwrap_or_default();
        Params {
            stake_address,
            nonce: cip36.nonce().unwrap_or_default().into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            vote_key,
            payment_address,
            is_payable: cip36.is_payable().unwrap_or_default(),
            raw_nonce: cip36.raw_nonce().unwrap_or_default().into(),
            cip36: is_cip36,
        }
    }

    /// Prepare Batch of Insert CIP-36 Registration Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CIP36_REGISTRATION_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error,"Failed to prepare Insert CIP-36 Registration Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_CIP36_REGISTRATION_QUERY}"))
    }
}
