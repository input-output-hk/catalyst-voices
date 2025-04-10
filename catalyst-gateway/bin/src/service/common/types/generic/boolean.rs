//! Implement type wrapper for boolean type

use derive_more::{From, Into};
use poem_openapi::{types::Example, NewType};

/// Boolean flag
#[derive(NewType, Debug, Clone, From, Into)]
#[oai(example = true)]
pub(crate) struct BooleanFlag(bool);

impl Default for BooleanFlag {
    /// Explicit default implementation of `Flag`.
    fn default() -> Self {
        Self(true)
    }
}

impl Example for BooleanFlag {
    fn example() -> Self {
        Self::default()
    }
}
