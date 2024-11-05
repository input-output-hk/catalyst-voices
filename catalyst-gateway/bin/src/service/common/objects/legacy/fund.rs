//! Define the Fund

use poem_openapi::Object;

#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct Fund {
    id: String,
}
