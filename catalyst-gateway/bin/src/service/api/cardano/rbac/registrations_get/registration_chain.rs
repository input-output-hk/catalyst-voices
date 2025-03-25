//! RBAC registration chain.

use std::collections::HashMap;

use poem_openapi::{types::Example, Object};

use crate::service::{
    api::cardano::rbac::registrations_get::{
        chain_info::ChainInfo, purpose_list::PurposeList, role_data::RbacRoleData,
    },
    common::types::{
        cardano::{catalyst_id::CatalystId, transaction_id::TxnId},
        generic::uuidv4::UUIDv4,
    },
};

/// A chain of valid RBAC registrations.
///
/// A unified data of multiple RBAC registrations.
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub struct RbacRegistrationChain {
    /// A Catalyst ID.
    catalyst_id: CatalystId,
    /// An ID of the last persistent transaction.
    #[oai(skip_serializing_if_is_none)]
    last_persistent_txn: Option<TxnId>,
    /// An ID of the last volatile transaction.
    #[oai(skip_serializing_if_is_none)]
    last_volatile_txn: Option<TxnId>,
    /// A list of registration purposes.
    #[oai(skip_serializing_if_is_empty)]
    purpose: PurposeList,
    /// A map of role number to role data.
    // This map is never empty, so there is no need to add the `skip_serializing_if_is_empty`
    // attribute.
    roles: HashMap<u8, RbacRoleData>,
}

impl Example for RbacRegistrationChain {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            purpose: PurposeList::example(),
            last_persistent_txn: Some(TxnId::example()),
            last_volatile_txn: Some(TxnId::example()),
            roles: [(0, RbacRoleData::example())].into_iter().collect(),
        }
    }
}

impl RbacRegistrationChain {
    /// Creates a new registration chain instance.
    pub fn new(info: &ChainInfo) -> anyhow::Result<Self> {
        let catalyst_id = info.chain.catalyst_id().clone().into();
        let last_persistent_txn = info.last_persistent_txn.map(Into::into);
        let last_volatile_txn = info.last_volatile_txn.map(Into::into);
        let purpose = info
            .chain
            .purpose()
            .iter()
            .copied()
            .map(UUIDv4::from)
            .collect::<Vec<_>>()
            .into();
        let roles = role_data(info)?;

        Ok(Self {
            catalyst_id,
            last_persistent_txn,
            last_volatile_txn,
            purpose,
            roles,
        })
    }
}

/// Gets and converts a role data from the given chain info.
fn role_data(info: &ChainInfo) -> anyhow::Result<HashMap<u8, RbacRoleData>> {
    info.chain
        .all_role_data()
        .iter()
        .map(|(&number, data)| {
            RbacRoleData::new(data, info.last_persistent_slot, &info.chain)
                .map(|r| (number.into(), r))
        })
        .collect()
}
