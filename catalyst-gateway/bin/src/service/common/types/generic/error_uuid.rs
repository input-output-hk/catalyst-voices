//! Implement API endpoint interfacing `ErrorUuid`.

use derive_more::{From, Into};
use poem_openapi::{types::Example, NewType};
use uuid::Uuid;

/// Error Unique ID
#[derive(Debug, Clone, NewType, From, Into)]
#[oai(example)]
pub(crate) struct ErrorUuid(Uuid);

impl Example for ErrorUuid {
    fn example() -> Self {
        Self(Uuid::new_v4())
    }
}
