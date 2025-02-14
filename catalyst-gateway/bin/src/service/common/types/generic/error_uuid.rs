//! Implement API endpoint interfacing `ErrorUuid`.

use derive_more::{From, FromStr, Into};
use poem_openapi::{types::Example, NewType};
use uuid::Uuid;

/// Error Unique ID
#[derive(Debug, Clone, NewType, From, FromStr, Into)]
#[oai(example)]
pub(crate) struct ErrorUuid(Uuid);

impl Example for ErrorUuid {
    fn example() -> Self {
        Self(Uuid::new_v4())
    }
}
