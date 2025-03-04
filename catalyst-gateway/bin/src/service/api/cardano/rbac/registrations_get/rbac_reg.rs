//! Bad Rbac registration response object.

use poem_openapi::{types::Example, Object};

use super::{cip509::Cip509, reg_chain::RegistrationChain};
use crate::service::common::types::cardano::catalyst_id::CatalystId;

/// RBAC Registrations, contains a latest valid and invalid registration data.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RbacRegistrations {
    /// User's catalyst id
    catalyst_id: CatalystId,
    /// Latest valid RBAC registration
    #[oai(skip_serializing_if_is_none)]
    finalised: Option<RbacRegistration>,
    /// Latest invalid RBAC registration
    #[oai(skip_serializing_if_is_none)]
    volatile: Option<RbacRegistration>,
}

impl RbacRegistrations {
    /// Build a reponse `RbacRegistrations` from the provided CIP 509 registrations lists
    #[allow(dead_code)]
    pub(crate) fn new(
        catalyst_id: CatalystId, finalised_regs: Vec<rbac_registration::cardano::cip509::Cip509>,
        volatile_regs: Vec<rbac_registration::cardano::cip509::Cip509>, detailed: bool,
    ) -> anyhow::Result<Self> {
        let finalised = RbacRegistration::new(finalised_regs, detailed)?;
        let volatile = RbacRegistration::new(volatile_regs, detailed)?;
        Ok(Self {
            catalyst_id,
            finalised,
            volatile,
        })
    }
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
struct RbacRegistration {
    /// Registration chain
    chain: RegistrationChain,
    /// All Cip509 registrations which formed a current registration chain
    #[oai(skip_serializing_if_is_empty)]
    details: Vec<Cip509>,
}

impl RbacRegistration {
    /// Build a reponse `RbacRegistration` from the provided CIP 509 registrations lists
    pub(crate) fn new(
        regs: Vec<rbac_registration::cardano::cip509::Cip509>, detailed: bool,
    ) -> anyhow::Result<Option<Self>> {
        let details = if detailed {
            regs.iter().map(Into::into).collect()
        } else {
            Vec::new()
        };
        let mut regs_iter = regs.into_iter();
        let Some(first) = regs_iter.next() else {
            return Ok(None);
        };
        let mut chain = rbac_registration::registration::cardano::RegistrationChain::new(first)?;
        for reg in regs_iter {
            chain = chain.update(reg)?;
        }

        Ok(Some(Self {
            chain: chain.into(),
            details,
        }))
    }
}

impl Example for RbacRegistration {
    fn example() -> Self {
        Self {
            chain: RegistrationChain::example(),
            details: vec![Cip509::example()],
        }
    }
}
