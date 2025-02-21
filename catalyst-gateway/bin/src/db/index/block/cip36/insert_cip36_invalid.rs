//! Insert CIP36 Registration Query (Invalid Records)

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::{Cip36, Slot, TxnIndex, VotingPubKey};
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
pub(crate) struct Params {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    stake_public_key: Vec<u8>,
    /// Slot Number the cert is in.
    slot_no: DbSlot,
    /// Transaction Index.
    txn_index: DbTxnIndex,
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
    problem_report: String,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let cip36 = match self.cip36 {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(v) => &format!("{v:?}"),
        };
        f.debug_struct("Params")
            .field("stake_public_key", &self.stake_public_key)
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("vote_key", &self.vote_key)
            .field("payment_address", &self.payment_address)
            .field("is_payable", &self.is_payable)
            .field("raw_nonce", &self.raw_nonce)
            .field("nonce", &self.nonce)
            .field("cip36", &cip36)
            .field("signed", &self.signed)
            .field("problem_report", &self.problem_report)
            .finish()
    }
}

impl Params {
    /// Create a new Insert Query.
    pub fn new(
        vote_key: Option<&VotingPubKey>, slot_no: Slot, txn_index: TxnIndex, cip36: &Cip36,
    ) -> Self {
        let stake_public_key = cip36
            .stake_pk()
            .map_or_else(Vec::new, |s| s.to_bytes().to_vec());
        let vote_key = vote_key
            .and_then(|k| k.voting_pk().map(|k| k.as_bytes().to_vec()))
            .unwrap_or_default();
        let is_cip36 = cip36.is_cip36().map_or(MaybeUnset::Unset, MaybeUnset::Set);
        let payment_address = cip36
            .payment_address()
            .map_or(Vec::new(), ShelleyAddress::to_vec);
        let problem_report = serde_json::to_string(cip36.err_report()).unwrap_or_else(|e| {
            error!(
                "Failed to serialize problem report: {e:?}. Report = {:?}",
                cip36.err_report()
            );
            String::new()
        });

        Params {
            stake_public_key,
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            vote_key,
            payment_address,
            is_payable: cip36.is_payable().unwrap_or_default(),
            raw_nonce: cip36.raw_nonce().unwrap_or_default().into(),
            nonce: cip36.nonce().unwrap_or_default().into(),
            cip36: is_cip36,
            signed: cip36.is_valid_signature(),
            problem_report,
        }
    }

    /// Prepare Batch of Insert CIP-36 Registration Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CIP36_REGISTRATION_INVALID_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(|error| error!(error=%error,"Failed to prepare Insert CIP-36 Registration Invalid Query."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_CIP36_REGISTRATION_INVALID_QUERY}"))
    }
}
