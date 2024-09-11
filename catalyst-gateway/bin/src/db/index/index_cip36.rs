//! Index CIP-36 Registrations.

use std::sync::Arc;

use cardano_chain_follower::{Metadata, MultiEraBlock};
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use super::{
    queries::{FallibleQueryTasks, PreparedQueries, PreparedQuery, SizedBatch},
    session::CassandraSession,
};
use crate::settings::CassandraEnvVars;

/// Insert TXI Query and Parameters
#[derive(SerializeRow)]
pub(crate) struct Cip36RegistrationInsertQuery {
    /// Stake key hash
    stake_address: MaybeUnset<Vec<u8>>,
    /// Stake key hash
    vote_key: Vec<u8>,
    /// Slot Number the cert is in.
    slot_no: num_bigint::BigInt,
    /// Transaction Index.
    txn: i16,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    payment_address: MaybeUnset<Vec<u8>>,
    /// Is the stake address a script or not.
    is_payable: MaybeUnset<bool>,
    /// Raw nonce value.
    raw_nonce: MaybeUnset<num_bigint::BigInt>,
    /// Nonce value after normalization.
    nonce: MaybeUnset<num_bigint::BigInt>,
    /// Is the Certificate Deregistered?
    purpose: MaybeUnset<num_bigint::BigInt>,
    /// Signature validates.
    signed: MaybeUnset<bool>,
    /// Strict Catalyst validated.
    strict_catalyst: MaybeUnset<bool>,
    /// List of serialization errors.
    error_report: MaybeUnset<Vec<String>>,
}

/// Index Registration by Stake Address
const INSERT_CIP36_REGISTRATION_QUERY: &str =
    include_str!("./queries/insert_cip36_registration.cql");

impl Cip36RegistrationInsertQuery {
    /// Create a new Insert Query.
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        stake_address: Option<Vec<u8>>, vote_key: Vec<u8>, slot_no: u64, txn: i16,
        payment_address: Option<Vec<u8>>, is_payable: Option<bool>, raw_nonce: Option<u64>,
        nonce: Option<u64>, purpose: Option<u64>, signed: Option<bool>,
        strict_catalyst: Option<bool>, error_report: Option<Vec<String>>,
    ) -> Self {
        Cip36RegistrationInsertQuery {
            stake_address: match stake_address {
                Some(stake_address) if !stake_address.is_empty() => MaybeUnset::Set(stake_address),
                _ => MaybeUnset::Unset,
            },
            vote_key,
            slot_no: slot_no.into(),
            txn,
            payment_address: match payment_address {
                Some(payment_address) if !payment_address.is_empty() => {
                    MaybeUnset::Set(payment_address)
                },
                _ => MaybeUnset::Unset,
            },
            is_payable: match is_payable {
                Some(is_payable) if is_payable => MaybeUnset::Set(is_payable),
                _ => MaybeUnset::Unset,
            },
            raw_nonce: match raw_nonce {
                Some(raw_nonce) => MaybeUnset::Set(raw_nonce.into()),
                _ => MaybeUnset::Unset,
            },
            nonce: match nonce {
                Some(nonce) => MaybeUnset::Set(nonce.into()),
                _ => MaybeUnset::Unset,
            },
            purpose: match purpose {
                Some(purpose) => MaybeUnset::Set(purpose.into()),
                _ => MaybeUnset::Unset,
            },
            signed: match signed {
                Some(signed) if signed => MaybeUnset::Set(signed),
                _ => MaybeUnset::Unset,
            },
            strict_catalyst: match strict_catalyst {
                Some(strict_catalyst) if strict_catalyst => MaybeUnset::Set(strict_catalyst),
                _ => MaybeUnset::Unset,
            },
            error_report: match error_report {
                Some(error_report) if !error_report.is_empty() => MaybeUnset::Set(error_report),
                _ => MaybeUnset::Unset,
            },
        }
    }

    /// Prepare Batch of Insert TXI Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CIP36_REGISTRATION_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = insert_queries {
            error!(error=%error,"Failed to prepare Insert Stake Registration Query.");
        };

        insert_queries
    }
}

/// Insert Cert Queries
pub(crate) struct Cip36InsertQuery {
    /// Stake Registration Data captured during indexing.
    cip36_reg_data: Vec<Cip36RegistrationInsertQuery>,
}

impl Cip36InsertQuery {
    /// Create new data set for Cert Insert Query Batch.
    #[allow(dead_code)]
    pub(crate) fn new() -> Self {
        Cip36InsertQuery {
            cip36_reg_data: Vec::new(),
        }
    }

    /// Prepare Batch of Insert TXI Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        // Note: for now we have one query, but there are many certs, and later we may have more
        // to add here.
        Cip36RegistrationInsertQuery::prepare_batch(session, cfg).await
    }

    /// Index the certificates in a transaction.
    #[allow(dead_code)]
    pub(crate) fn index(
        &mut self, txn: usize, txn_index: i16, slot_no: u64, block: &MultiEraBlock,
    ) {
        if let Some(decoded_metadata) = block.txn_metadata(txn, Metadata::cip36::LABEL) {
            let _raw_size = match block.txn_raw_metadata(txn, Metadata::cip36::LABEL) {
                Some(raw) => raw.len(),
                None => 0,
            };
            #[allow(irrefutable_let_patterns)]
            if let Metadata::DecodedMetadataValues::Cip36(cip36) = &decoded_metadata.value {
                for vote_key in &cip36.voting_keys {
                    let vote_key = vote_key.voting_pk.to_bytes().to_vec();
                    let stake_address = cip36.stake_pk.map(|s| s.to_bytes().to_vec());
                    let payment_address = Some(cip36.payment_addr.clone());
                    let is_payable = Some(cip36.payable);
                    let raw_nonce = Some(cip36.raw_nonce);
                    let nonce = Some(cip36.nonce);
                    let purpose = Some(cip36.purpose);
                    let signed = Some(cip36.signed);
                    let strict_catalyst = cip36.cip36;
                    let error_report = Some(decoded_metadata.report.clone());
                    self.cip36_reg_data.push(Cip36RegistrationInsertQuery::new(
                        stake_address,
                        vote_key,
                        slot_no,
                        txn_index,
                        payment_address,
                        is_payable,
                        raw_nonce,
                        nonce,
                        purpose,
                        signed,
                        strict_catalyst,
                        error_report,
                    ));
                }
            }
        }
    }

    /// Execute the Certificate Indexing Queries.
    ///
    /// Consumes the `self` and returns a vector of futures.
    #[allow(dead_code)]
    pub(crate) fn execute(self, session: &Arc<CassandraSession>) -> FallibleQueryTasks {
        let mut query_handles: FallibleQueryTasks = Vec::new();

        let inner_session = session.clone();

        query_handles.push(tokio::spawn(async move {
            inner_session
                .execute_batch(
                    PreparedQuery::Cip36RegistrationInsertQuery,
                    self.cip36_reg_data,
                )
                .await
        }));
        query_handles
    }
}
