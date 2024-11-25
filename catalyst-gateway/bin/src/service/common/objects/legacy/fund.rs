//! Define the Fund

use poem_openapi::Object;

/// The fund object.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct Fund {
    /// The identifier of the fund in hex format.
    #[oai(validator(max_length = 256, min_length = 0, pattern = "[A-Za-z0-9_-]"))]
    id: String,
}
