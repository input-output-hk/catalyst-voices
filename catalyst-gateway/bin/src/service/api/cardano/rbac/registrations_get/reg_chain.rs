//! Chain of Cardano registration data API object

use poem_openapi::{types::Example, Object};

use crate::service::common::types::{cardano::transaction_id::TxnId, generic::uuidv4::UUIDv4};

/// RBAC registrations chain.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RegistrationChain {
    /// The current transaction ID
    current_tx_id_hash: TxnId,
    /// List of purpose for this registration chain
    #[oai(
        skip_serializing_if_is_empty,
        validator(max_items = "1000", min_items = "1")
    )]
    purpose: Vec<UUIDv4>,
}

impl Example for RegistrationChain {
    fn example() -> Self {
        Self {
            current_tx_id_hash: TxnId::example(),
            purpose: vec![UUIDv4::example()],
        }
    }
}

impl From<rbac_registration::registration::cardano::RegistrationChain> for RegistrationChain {
    fn from(value: rbac_registration::registration::cardano::RegistrationChain) -> Self {
        Self {
            current_tx_id_hash: value.current_tx_id_hash().into(),
            purpose: value.purpose().iter().copied().map(Into::into).collect(),
        }
    }
}
