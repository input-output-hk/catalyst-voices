//! Insert CIP36 Registration Query (Invalid Records)

use std::sync::Arc;

use cardano_chain_follower::Metadata::cip36::{Cip36, VotingPubKey};
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::queries::{PreparedQueries, SizedBatch},
    settings::CassandraEnvVars,
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
    slot_no: num_bigint::BigInt,
    /// Transaction Index.
    txn: i16,
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

impl Params {
    /// Create a new Insert Query.
    pub fn new(
        vote_key: Option<&VotingPubKey>, slot_no: u64, txn: i16, cip36: &Cip36,
        error_report: Vec<String>,
    ) -> Self {
        let vote_key = if let Some(vote_key) = vote_key {
            vote_key.voting_pk.to_bytes().to_vec()
        } else {
            Vec::new()
        };
        Params {
            stake_address: cip36
                .stake_pk
                .map(|s| s.to_bytes().to_vec())
                .unwrap_or_default(),
            slot_no: slot_no.into(),
            txn,
            vote_key,
            payment_address: cip36.payment_addr.clone(),
            is_payable: cip36.payable,
            raw_nonce: cip36.raw_nonce.into(),
            nonce: cip36.nonce.into(),
            cip36: if let Some(cip36) = cip36.cip36 {
                MaybeUnset::Set(cip36)
            } else {
                MaybeUnset::Unset
            },
            signed: cip36.signed,
            error_report,
        }
    }

    /// Prepare Batch of Insert CIP-36 Registration Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
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
