//! Bad Rbac registration response object.

use poem_openapi::{types::Example, Object};

use crate::service::common::types::cardano::catalyst_id::CatalystId;

/// Rbac Registrations, contains a latest valid and invalid registration data.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistrations {
    /// User's catalyst id
    catalyst_id: CatalystId,
}

impl Example for RbacRegistrations {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
        }
    }
}
