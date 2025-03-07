//! Chain of Cardano registration data API object

use poem_openapi::{
    types::{Example, ToJSON},
    NewType, Object,
};

use crate::service::common::types::{
    array_types::impl_array_types, cardano::transaction_id::TxnId, generic::uuidv4::UUIDv4,
};

/// RBAC registrations chain.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct RegistrationChain {
    /// The current transaction ID
    current_tx_id_hash: TxnId,
    /// List of purpose for this registration chain
    #[oai(skip_serializing_if_is_empty)]
    purpose: PurposeList,
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an `Object`.
#[derive(NewType, Debug, Clone)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// RBAC registrations chain.
pub(crate) struct RegChain(pub(crate) RegistrationChain);

impl_array_types!(
    PurposeList,
    UUIDv4,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        min_items: Some(1),
        max_items: Some(10000),
        items: Some(Box::new(UUIDv4::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for RegistrationChain {
    fn example() -> Self {
        Self {
            current_tx_id_hash: TxnId::example(),
            purpose: PurposeList::example(),
        }
    }
}

impl Example for RegChain {
    fn example() -> Self {
        Self(RegistrationChain::example())
    }
}

impl Example for PurposeList {
    fn example() -> Self {
        Self(vec![UUIDv4::example()])
    }
}

impl From<rbac_registration::registration::cardano::RegistrationChain> for RegChain {
    fn from(value: rbac_registration::registration::cardano::RegistrationChain) -> Self {
        Self(RegistrationChain {
            current_tx_id_hash: value.current_tx_id_hash().into(),
            purpose: value
                .purpose()
                .iter()
                .copied()
                .map(Into::into)
                .collect::<Vec<_>>()
                .into(),
        })
    }
}
