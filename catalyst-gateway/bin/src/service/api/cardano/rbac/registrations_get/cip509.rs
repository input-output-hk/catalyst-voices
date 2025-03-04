//! Cardano Improvement Proposal 509 (CIP-509) API object.
//! Doc Reference: <https://github.com/input-output-hk/catalyst-CIPs/tree/x509-envelope-metadata/CIP-XXXX>
//! CDDL Reference: <https://github.com/input-output-hk/catalyst-CIPs/blob/x509-envelope-metadata/CIP-XXXX/x509-envelope.cddl>

use poem_openapi::{types::Example, Object};

use crate::service::common::{
    objects::generic::json_object::JSONObject,
    types::{
        cardano::{slot_tx_idx::SlotTxnIdx, transaction_id::TxnId},
        generic::uuidv4::UUIDv4,
    },
};

/// CIP 509 registration transaction data.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct Cip509 {
    /// A registration purpose (`UUIDv4`).
    ///
    /// The purpose is defined by the consuming dApp.
    #[oai(skip_serializing_if_is_none)]
    purpose: Option<UUIDv4>,
    /// An optional hash of the previous transaction.
    ///
    /// The hash must always be present except for the first registration transaction.
    #[oai(skip_serializing_if_is_none)]
    prv_tx_id: Option<TxnId>,
    /// A hash of the transaction from which this registration is extracted.
    txn_hash: TxnId,
    /// A point (slot) and a transaction index identifying the block and the transaction
    /// that this `Cip509` was extracted from.
    origin: SlotTxnIdx,

    /// A report potentially containing all the issues occurred during `Cip509` decoding
    /// and validation.
    report: JSONObject,
}

impl Example for Cip509 {
    fn example() -> Self {
        Self {
            purpose: Some(UUIDv4::example()),
            prv_tx_id: None,
            txn_hash: TxnId::example(),
            origin: SlotTxnIdx::example(),
            report: serde_json::json!({}).into(),
        }
    }
}

impl TryFrom<&rbac_registration::cardano::cip509::Cip509> for Cip509 {
    type Error = anyhow::Error;

    fn try_from(value: &rbac_registration::cardano::cip509::Cip509) -> Result<Self, Self::Error> {
        let report = serde_json::to_value(value.report())?;
        Ok(Self {
            purpose: value.purpose().map(Into::into),
            prv_tx_id: value.previous_transaction().map(Into::into),
            txn_hash: value.txn_hash().into(),
            origin: value.origin().clone().into(),
            report: report.into(),
        })
    }
}
