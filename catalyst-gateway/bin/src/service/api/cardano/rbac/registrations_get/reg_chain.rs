//! Chain of Cardano registration data API object

use poem_openapi::{types::Example, Object};

use crate::service::common::types::{cardano::transaction_id::TxnId, generic::uuidv4::UUIDv4};

/// RBAC registrations chain.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct RegistrationChain {
    /// The current transaction ID
    current_tx_id_hash: TxnId,
    /// List of purpose for this registration chain
    #[oai(skip_serializing_if_is_empty)]
    purpose: Vec<UUIDv4>,
}

impl RegistrationChain {
    /// Try to build a `RegistrationChain` from the provided registration list
    pub(crate) fn new(regs: Vec<rbac_registration::cardano::cip509::Cip509>) -> Option<Self> {
        let mut regs_iter = regs.into_iter();
        while let Some(try_first) = regs_iter.next() {
            if let Ok(mut chain) =
                rbac_registration::registration::cardano::RegistrationChain::new(try_first)
            {
                for reg in regs_iter {
                    let Ok(updated_chain) = chain.update(reg) else {
                        continue;
                    };
                    chain = updated_chain;
                }
                return Some(chain.into());
            }
            continue;
        }
        None
    }
}

impl Example for RegistrationChain {
    fn example() -> Self {
        Self {
            current_tx_id_hash: TxnId::example(),
            purpose: vec![UUIDv4::example()],
        }
    }
}

impl From<rbac_registration::registration::cardano::RegistrationChain> for RegistrationChain {
    fn from(value: rbac_registration::registration::cardano::RegistrationChain) -> Self {
        Self {
            current_tx_id_hash: value.current_tx_id_hash().into(),
            purpose: value.purpose().iter().copied().map(Into::into).collect(),
        }
    }
}
