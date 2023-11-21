//! Defines API schemas of fragment status types.

use poem_openapi::{types::Example, Object, Union};

use crate::service::common::objects::{block::BlockDate, hash::Hash};

#[derive(Object)]
#[oai(example = false)]
/// DEPRECATED: Fragment is pending.
pub(crate) struct StatusPending;

#[derive(Object)]
#[oai(example = true)]
/// DEPRECATED: Fragment was rejected.
pub(crate) struct StatusRejected {
    /// Reason the fragment was rejected.
    pub reason: String,
}

impl Example for StatusRejected {
    fn example() -> Self {
        Self {
            reason: "Transaction malformed".to_string(),
        }
    }
}

#[derive(Object)]
#[oai(example = true)]
/// DEPRECATED: Fragment is included in a block.
pub(crate) struct StatusInABlock {
    /// Block date at which the fragment was included in a block.
    pub date: BlockDate,
    /// Hash of the block the fragment was included in.
    pub block: Hash,
}

impl Example for StatusInABlock {
    fn example() -> Self {
        Self {
            date: BlockDate::example(),
            block: Hash::example(),
        }
    }
}

#[derive(Union)]
#[oai(one_of = true)]
/// DEPRECATED: Possible fragment statuses.
pub(crate) enum FragmentStatus {
    /// Fragment is pending inclusion in a block.
    Pending(StatusPending),
    /// Fragment was rejected.
    Rejected(StatusRejected),
    /// Fragment was included in a block.
    InABlock(StatusInABlock),
}
