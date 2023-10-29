//! Define information about fragments that were processed.

use poem_openapi::{types::Example, Object};

#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct FragmentsProcessingSummary {
    accepted: Vec<String>,
    rejected: Vec<String>,
}

impl Example for FragmentsProcessingSummary {
    fn example() -> Self {
        Self {
            accepted: Vec::new(),
            rejected: Vec::new(),
        }
    }
}
