//! Implement newtype for the frontend config environment

use poem_openapi::{types::Example, Enum};

/// Frontend config environment.
#[derive(Clone, Enum, Debug)]
pub(super) enum ConfigEnvironment {
    /// Development environment.
    #[oai(rename = "dev")]
    Dev,
    /// QA environment.
    #[oai(rename = "qa")]
    Qa,
    /// Production environment.
    #[oai(rename = "prod")]
    Prod,
}

impl Example for ConfigEnvironment {
    fn example() -> Self {
        Self::Dev
    }
}
