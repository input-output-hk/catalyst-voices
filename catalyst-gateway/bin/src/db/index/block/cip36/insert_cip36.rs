//! Insert CIP36 Registration Query

use std::{fmt::Debug, sync::Arc};

use cardano_chain_follower::Metadata::cip36::{Cip36, VotingPubKey};
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::cassandra_db,
};

/// Index Registration by Stake Address
const INSERT_CIP36_REGISTRATION_QUERY: &str = include_str!("./cql/insert_cip36.cql");

/// Insert CIP-36 Registration Query Parameters
#[derive(SerializeRow, Clone)]
pub(super) struct Params {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    stake_address: Vec<u8>,
    /// Nonce value after normalization.
    nonce: num_bigint::BigInt,
    /// Slot Number the cert is in.
    slot_no: num_bigint::BigInt,
    /// Transaction Index.
    txn: i16,
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
            .field("txn", &self.txn)
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
    pub fn new(vote_key: &VotingPubKey, slot_no: u64, txn: i16, cip36: &Cip36) -> Self {
        Params {
            stake_address: cip36
                .stake_pk
                .map(|s| s.to_bytes().to_vec())
                .unwrap_or_default(),
            nonce: cip36.nonce.into(),
            slot_no: slot_no.into(),
            txn,
            vote_key: vote_key.voting_pk.to_bytes().to_vec(),
            payment_address: if cip36.payment_addr.is_empty() {
                MaybeUnset::Unset
            } else {
                MaybeUnset::Set(cip36.payment_addr.clone())
            },
            is_payable: cip36.payable,
            raw_nonce: cip36.raw_nonce.into(),
            cip36: cip36.cip36.unwrap_or_default(),
        }
    }

    /// Prepare Batch of Insert CIP-36 Registration Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CIP36_REGISTRATION_QUERY,
            cfg,
            scylla::statement::Consistency::LocalQuorum,
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
