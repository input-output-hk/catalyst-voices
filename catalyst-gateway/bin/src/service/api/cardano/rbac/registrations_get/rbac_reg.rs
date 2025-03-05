//! Bad Rbac registration response object.

use poem_openapi::{types::Example, Object};

use super::{cip509::Cip509List, reg_chain::RegistrationChain};
use crate::service::common::types::cardano::catalyst_id::CatalystId;

/// RBAC Registrations, contains a latest valid and invalid registration data.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistrations {
    /// User's catalyst id
    pub(crate) catalyst_id: CatalystId,
    /// Finalized RBAC registration
    #[oai(skip_serializing_if_is_none)]
    pub(crate) finalized: Option<RbacRegistration>,
    /// No-Finalized RBAC registration
    #[oai(skip_serializing_if_is_none)]
    pub(crate) volatile: Option<RbacRegistration>,
}

impl Example for RbacRegistrations {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            finalized: Some(RbacRegistration::example()),
            volatile: Some(RbacRegistration::example()),
        }
    }
}

/// Single RBAC Registrations.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistration {
    /// Registration chain, contains only valid
    #[oai(skip_serializing_if_is_none)]
    pub(crate) chain: Option<RegistrationChain>,
    /// All Cip509 registrations which formed a current registration chain
    #[oai(skip_serializing_if_is_empty)]
    pub(crate) details: Cip509List,
}

impl Example for RbacRegistration {
    fn example() -> Self {
        Self {
            chain: Some(RegistrationChain::example()),
            details: Cip509List::example(),
        }
    }
}
