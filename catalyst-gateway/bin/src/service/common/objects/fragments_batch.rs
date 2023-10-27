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
