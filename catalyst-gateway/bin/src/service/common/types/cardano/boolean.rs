//! Implement type wrappers for boolean types

use derive_more::{From, Into};
use poem_openapi::{types::Example, NewType};

/// Payable indicator
#[derive(NewType, Clone, From, Into)]
#[oai(example = true)]
pub(crate) struct IsPayable(bool);

impl Default for IsPayable {
    /// Explicit default implementation of `IsPayable`.
    fn default() -> Self {
        Self(true)
    }
}

impl Example for IsPayable {
    fn example() -> Self {
        Self::default()
    }
}

/// CIP-15 Indicator
#[derive(NewType, Clone, From, Into)]
#[oai(example = true)]
pub(crate) struct IsCip15(bool);

impl Default for IsCip15 {
    /// Explicit default implementation of `IsCip15`.
    fn default() -> Self {
        Self(false)
    }
}

impl Example for IsCip15 {
    fn example() -> Self {
        Self::default()
    }
}
