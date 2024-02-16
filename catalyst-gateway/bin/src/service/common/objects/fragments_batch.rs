//! Defines API schemas for fragment batch types.

use poem_openapi::{types::Example, NewType, Object};
use serde::Deserialize;

#[derive(NewType, Deserialize)]
/// Hex-encoded fragment's bytes.
pub(crate) struct FragmentDef(String);

#[derive(Object, Deserialize)]
#[oai(example = true)]
/// Batch of hex-encoded fragments.
pub(crate) struct FragmentsBatch {
    /// Fragments are processed sequentially. If this is true, processing is
    /// stopped after the first error occurs.
    pub fail_fast: bool,
    /// Array of hex-encoded fragments bytes.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(
        max_items = "100",
        max_length = 66,
        min_length = 66,
        pattern = "0x[0-9a-f]{64}"
    ))]
    pub fragments: Vec<FragmentDef>,
}

impl Example for FragmentsBatch {
    fn example() -> Self {
        Self {
            fail_fast: false,
            fragments: vec![],
        }
    }
}
