//! Defines API schemas of fragment status types.

use poem_openapi::{types::Example, Object};

use crate::service::common::objects::legacy::{block::BlockDate, hash::Hash};

#[derive(Object)]
#[oai(example = false)]
/// DEPRECATED: Fragment is pending.
pub(crate) struct StatusPending;

#[derive(Object)]
#[oai(example = true)]
/// DEPRECATED: Fragment was rejected.
pub(crate) struct StatusRejected {
    /// Reason the fragment was rejected.
    // Should start with capital letter.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(max_length = "250", pattern = r"^[A-Z].*$"))]
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
