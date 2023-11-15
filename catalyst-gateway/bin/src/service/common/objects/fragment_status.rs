use poem_openapi::{types::Example, Object, Union};

use crate::service::common::objects::{block::BlockDate, hash::Hash};

#[derive(Object)]
#[oai(example = false)]
/// Fragment is pending.
pub(crate) struct StatusPending;

#[derive(Object)]
#[oai(example = true)]
/// Fragment was rejected.
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
/// Fragment is included in a block.
pub(crate) struct StatusInABlock {
    pub date: BlockDate,
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
/// Possible fragment statuses.
pub(crate) enum FragmentStatus {
    Pending(StatusPending),
    Rejected(StatusRejected),
    InABlock(StatusInABlock),
}
