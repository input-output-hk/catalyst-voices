//! Insert CIP36 Registration Query (Invalid Records)

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::{Cip36, VotingPubKey};
use pallas::ledger::addresses::ShelleyAddress;
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbSlot, DbTxnIndex},
    },
    settings::cassandra_db,
};

/// Index Registration by Stake Address (Invalid Registrations)
const INSERT_CIP36_REGISTRATION_INVALID_QUERY: &str =
    include_str!("./cql/insert_cip36_invalid.cql");

/// Insert CIP-36 Registration Invalid Query Parameters
#[derive(SerializeRow, Clone)]
pub(super) struct Params {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    stake_address: Vec<u8>,
    /// Slot Number the cert is in.
    slot_no: DbSlot,
    /// Transaction Index.
    txn: DbTxnIndex,
    /// Voting Public Key
    vote_key: Vec<u8>,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    payment_address: Vec<u8>,
    /// Is the stake address a script or not.
    is_payable: bool,
    /// Raw nonce value.
    raw_nonce: num_bigint::BigInt,
    /// Nonce value after normalization.
    nonce: num_bigint::BigInt,
    /// Strict Catalyst validated.
    cip36: MaybeUnset<bool>,
    /// Signature validates.
    signed: bool,
    /// List of serialization errors.
    error_report: Vec<String>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let cip36 = match self.cip36 {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(v) => &format!("{v:?}"),
        };
        f.debug_struct("Params")
            .field("stake_address", &self.stake_address)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("vote_key", &self.vote_key)
            .field("payment_address", &self.payment_address)
            .field("is_payable", &self.is_payable)
            .field("raw_nonce", &self.raw_nonce)
            .field("nonce", &self.nonce)
            .field("cip36", &cip36)
            .field("signed", &self.signed)
            .field("error_report", &self.error_report)
            .finish()
    }
}

impl Params {
    /// Create a new Insert Query.
    pub fn new(
        vote_key: Option<&VotingPubKey>, slot_no: DbSlot, txn: DbTxnIndex, cip36: &Cip36,
        error_report: Vec<String>,
    ) -> Self {
        let stake_address = cip36
            .stake_pk()
            .map_or_else(Vec::new, |s| s.to_bytes().to_vec());
        let vote_key = vote_key
            .and_then(|k| k.voting_pk().map(|k| k.as_bytes().to_vec()))
            .unwrap_or_default();
        let is_cip36 = cip36.is_cip36().map_or(MaybeUnset::Unset, MaybeUnset::Set);
        let payment_address = cip36
            .payment_address()
            .map_or(Vec::new(), ShelleyAddress::to_vec);

        Params {
            stake_address,
            slot_no,
            txn,
            vote_key,
            payment_address,
            is_payable: cip36.is_payable().unwrap_or_default(),
            raw_nonce: cip36.raw_nonce().unwrap_or_default().into(),
            nonce: cip36.nonce().unwrap_or_default().into(),
            cip36: is_cip36,
            signed: cip36.is_valid_signature(),
            error_report,
        }
    }

    /// Prepare Batch of Insert CIP-36 Registration Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CIP36_REGISTRATION_INVALID_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = insert_queries {
            error!(error=%error,"Failed to prepare Insert CIP-36 Registration Invalid Query.");
        };

        insert_queries
    }
}
