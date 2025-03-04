//! Cardano Improvement Proposal 509 (CIP-509) API object.
//! Doc Reference: <https://github.com/input-output-hk/catalyst-CIPs/tree/x509-envelope-metadata/CIP-XXXX>
//! CDDL Reference: <https://github.com/input-output-hk/catalyst-CIPs/blob/x509-envelope-metadata/CIP-XXXX/x509-envelope.cddl>

use poem_openapi::{types::Example, Object};

use crate::service::common::types::{cardano::transaction_id::TxnId, generic::uuidv4::UUIDv4};

/// CIP 509 registration transaction data.
#[derive(Object)]
#[oai(example = true)]
#[allow(dead_code)]
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
}

impl Example for Cip509 {
    fn example() -> Self {
        Self {
            purpose: Some(UUIDv4::example()),
            prv_tx_id: None,
            txn_hash: TxnId::example(),
        }
    }
}

impl From<rbac_registration::cardano::cip509::Cip509> for Cip509 {
    fn from(value: rbac_registration::cardano::cip509::Cip509) -> Self {
        Self {
            purpose: value.purpose().map(Into::into),
            prv_tx_id: value.previous_transaction().map(Into::into),
            txn_hash: value.txn_hash().into(),
        }
    }
}
