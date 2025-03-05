//! Bad Rbac registration response object.

use poem_openapi::{types::Example, NewType, Object};

use super::{cip509::Cip509List, reg_chain::RegChain};
use crate::service::common::types::cardano::catalyst_id::CatalystId;

/// RBAC Registrations, contains a latest valid and invalid registration data.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct RbacRegistrations {
    /// User's catalyst id
    pub(crate) catalyst_id: CatalystId,
    /// Finalized RBAC registration
    #[oai(skip_serializing_if_is_none)]
    pub(crate) finalized: Option<RbacReg>,
    /// No-Finalized RBAC registration
    #[oai(skip_serializing_if_is_none)]
    pub(crate) volatile: Option<RbacReg>,
}

impl Example for RbacRegistrations {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            finalized: Some(RbacReg::example()),
            volatile: Some(RbacReg::example()),
        }
    }
}

/// Single RBAC Registrations.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct RbacRegistration {
    /// Registration chain, contains only valid
    #[oai(skip_serializing_if_is_none)]
    pub(crate) chain: Option<RegChain>,
    /// All Cip509 registrations which formed a current registration chain
    #[oai(skip_serializing_if_is_empty)]
    pub(crate) details: Cip509List,
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an `Object`.
#[derive(NewType, Debug, Clone)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Single RBAC Registrations.
pub(crate) struct RbacReg(pub(crate) RbacRegistration);

impl Example for RbacRegistration {
    fn example() -> Self {
        Self {
            chain: Some(RegChain::example()),
            details: Cip509List::example(),
        }
    }
}

impl Example for RbacReg {
    fn example() -> Self {
        Self(RbacRegistration::example())
    }
}

impl From<RbacRegistration> for RbacReg {
    fn from(value: RbacRegistration) -> Self {
        Self(value)
    }
}
