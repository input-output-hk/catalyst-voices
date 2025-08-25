//! An invalid RBAC registration.

use cardano_chain_follower::{hashes::TransactionId, Slot};
use catalyst_types::uuid::UuidV4;
use poem_openapi::{types::Example, Object};

use crate::{
    db::index::queries::rbac::get_rbac_invalid_registrations::Query,
    service::common::types::{
        cardano::{slot_no::SlotNo, transaction_id::TxnId, txn_index::TxnIndex},
        generic::{error_msg::ErrorMessage, uuidv4::UUIDv4},
    },
};

/// An invalid RBAC registration.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub struct InvalidRegistration {
    /// A transaction identifier (hash).
    txn_id: TxnId,
    /// A block slot number.
    slot: SlotNo,
    /// A transaction index.
    txn_index: TxnIndex,
    /// A previous  transaction ID.
    previous_txn: Option<TxnId>,
    /// A registration purpose.
    purpose: Option<UUIDv4>,
    /// A problem report.
    report: ErrorMessage,
}

impl Example for InvalidRegistration {
    fn example() -> Self {
        Self {
            txn_id: TxnId::example(),
            slot: SlotNo::example(),
            txn_index: TxnIndex::example(),
            previous_txn: Some(TxnId::example()),
            purpose: Some(UUIDv4::example()),
            report: ErrorMessage::example(),
        }
    }
}

impl From<Query> for InvalidRegistration {
    fn from(q: Query) -> Self {
        Self {
            txn_id: TransactionId::from(q.txn_id).into(),
            slot: Slot::from(q.slot_no).into(),
            txn_index: q.txn_index.into(),
            previous_txn: q.prv_txn_id.map(|t| TransactionId::from(t).into()),
            purpose: q.purpose.map(|p| UuidV4::from(p).into()),
            report: q.problem_report.into(),
        }
    }
}
