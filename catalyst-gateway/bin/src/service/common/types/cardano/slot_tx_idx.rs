//! Block's slot and transaction index API object.

use poem_openapi::{types::Example, Object};
use rbac_registration::cardano::cip509::PointTxnIdx;

use super::{slot_no::SlotNo, txn_index::TxnIndex};

/// Block's slot number and transaction index.
#[derive(Object)]
#[oai(example = true)]
pub struct SlotTxnIdx {
    /// Slot number
    slot: SlotNo,
    /// A transaction index inside the block.
    txn_index: TxnIndex,
}

impl Example for SlotTxnIdx {
    fn example() -> Self {
        Self {
            slot: SlotNo::example(),
            txn_index: TxnIndex::example(),
        }
    }
}

impl From<PointTxnIdx> for SlotTxnIdx {
    fn from(value: PointTxnIdx) -> Self {
        Self {
            slot: value.point().slot_or_default().into(),
            // TODO: fix that after updating `cardano_blockchain_types::TxnIndex`
            // txn_index: value.txn_index().into(),
            txn_index: 0.into(),
        }
    }
}
