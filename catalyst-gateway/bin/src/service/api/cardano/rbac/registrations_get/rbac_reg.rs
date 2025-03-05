//! Bad Rbac registration response object.

use poem_openapi::{types::Example, Object};

use super::{cip509::Cip509, reg_chain::RegistrationChain};
use crate::service::common::types::cardano::catalyst_id::CatalystId;

/// RBAC Registrations, contains a latest valid and invalid registration data.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistrations {
    /// User's catalyst id
    pub(crate) catalyst_id: CatalystId,
    /// Latest valid RBAC registration
    #[oai(skip_serializing_if_is_none)]
    pub(crate) finalised: Option<RbacRegistration>,
    /// Latest invalid RBAC registration
    #[oai(skip_serializing_if_is_none)]
    pub(crate) volatile: Option<RbacRegistration>,
}

impl Example for RbacRegistrations {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            finalised: Some(RbacRegistration::example()),
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
    pub(crate) details: Vec<Cip509>,
}

impl Example for RbacRegistration {
    fn example() -> Self {
        Self {
            chain: Some(RegistrationChain::example()),
            details: vec![Cip509::example()],
        }
    }
}
