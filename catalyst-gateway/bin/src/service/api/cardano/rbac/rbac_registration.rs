//! Bad Rbac registration response object.

use poem_openapi::{types::Example, Object};

use crate::service::common::types::{
    cardano::{catalyst_id::CatalystId, slot_no::SlotNo, transaction_id::TxnId},
    generic::uuidv4::UUIDv4,
};

/// RBAC Registrations, contains a latest valid and invalid registration data.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistrations {
    /// Latest valid RBAC registration
    #[oai(skip_serializing_if_is_none)]
    valid: Option<RbacRegistration>,
    /// Latest invalid RBAC registration
    #[oai(skip_serializing_if_is_none)]
    invalid: Option<RbacRegistration>,
}

impl Example for RbacRegistrations {
    fn example() -> Self {
        Self {
            valid: Some(RbacRegistration::example()),
            invalid: Some(RbacRegistration::example()),
        }
    }
}

/// Single RBAC Registrations.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistration {
    /// User's catalyst id
    catalyst_id: CatalystId,
    /// Transaction ID, which contains this registration
    txn_id: TxnId,
    /// Block's slot number, which contains this registration
    slot: SlotNo,
    /// Registration purpose
    purpose: UUIDv4,
}

impl Example for RbacRegistration {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            txn_id: TxnId::example(),
            slot: SlotNo::example(),
            purpose: UUIDv4::example(),
        }
    }
}
