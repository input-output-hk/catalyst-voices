//! Define the Vote history

use poem_openapi::Object;

/// An option item to specify proposal to query.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct VoteHistoryItem {
    #[oai(validator(max_length = 256, min_length = 0, pattern = "[A-Za-z0-9_-]"))]
    vote_plan_id: String,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    indexes: u32,
}
