//! Block's slot and transaction index API object.

use poem_openapi::{types::Example, NewType, Object};
use rbac_registration::cardano::cip509::PointTxnIdx;

use super::{slot_no::SlotNo, txn_index::TxnIndex};

/// Block's slot number and transaction index.
#[derive(Debug, Clone, Object)]
pub(crate) struct SlotTransactionIndex {
    /// Slot number
    slot: SlotNo,
    /// A transaction index inside the block.
    txn_index: TxnIndex,
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
/// Block's slot number and transaction index.
pub(crate) struct SlotTxnIdx(pub(crate) SlotTransactionIndex);

impl Example for SlotTransactionIndex {
    fn example() -> Self {
        Self {
            slot: SlotNo::example(),
            txn_index: TxnIndex::example(),
        }
    }
}

impl Example for SlotTxnIdx {
    fn example() -> Self {
        Self(SlotTransactionIndex::example())
    }
}

impl From<PointTxnIdx> for SlotTxnIdx {
    fn from(value: PointTxnIdx) -> Self {
        Self(SlotTransactionIndex {
            slot: value.point().slot_or_default().into(),
            txn_index: value.txn_index().into(),
        })
    }
}
