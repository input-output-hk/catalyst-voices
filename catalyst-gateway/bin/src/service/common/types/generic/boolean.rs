//! Implement type wrapper for boolean type
use derive_more::{From, Into};
use poem_openapi::{types::Example, NewType};

/// Boolean flag
#[derive(NewType, Debug, Clone, From, Into)]
#[oai(example = true)]
pub(crate) struct BooleanFlag(bool);

impl Example for BooleanFlag {
    fn example() -> Self {
        Self(true)
    }
}
