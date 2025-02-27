//! Bad Rbac registration response object.

use poem_openapi::{types::Example, Object};

use crate::service::common::types::{
    cardano::{catalyst_id::CatalystId, transaction_id::TxnId},
    generic::uuidv4::UUIDv4,
};

/// RBAC Registrations, contains a latest valid and invalid registration data.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistrations {
    /// User's catalyst id
    catalyst_id: CatalystId,
    /// Latest valid RBAC registration
    #[oai(skip_serializing_if_is_none)]
    finalised: Option<RbacRegistration>,
    /// Latest invalid RBAC registration
    #[oai(skip_serializing_if_is_none)]
    volatile: Option<RbacRegistration>,
}

impl Example for RbacRegistrations {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            finalised: Some(RbacRegistration::example()),
            volatile: Some(RbacRegistration::example()),
        }
    }
}

/// Single RBAC Registrations.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistration {
    /// Transaction ID of the latest published registration
    txn_id: TxnId,
    /// Registration purposes
    purpose: Vec<UUIDv4>,

    /// All Cip509 registrations
    #[oai(skip_serializing_if_is_empty)]
    details: Vec<String>,
}

impl Example for RbacRegistration {
    fn example() -> Self {
        Self {
            txn_id: TxnId::example(),
            purpose: vec![UUIDv4::example()],
        }
    }
}
