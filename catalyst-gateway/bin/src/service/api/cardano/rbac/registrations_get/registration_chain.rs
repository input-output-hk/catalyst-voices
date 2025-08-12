//! RBAC registration chain.

use std::collections::HashMap;

use catalyst_types::catalyst_id::role_index::RoleId;
use poem_openapi::{types::Example, Object};

use crate::{
    rbac::ChainInfo,
    service::{
        api::cardano::rbac::registrations_get::{
            invalid_registration_list::InvalidRegistrationList, purpose_list::PurposeList,
            role_data::RbacRoleData, role_map::RoleMap,
        },
        common::types::{
            cardano::{catalyst_id::CatalystId, transaction_id::TxnId},
            generic::uuidv4::UUIDv4,
        },
    },
};

/// A chain of valid RBAC registrations.
///
/// A unified data of multiple RBAC registrations.
#[derive(Object, Debug, Clone)]
#[oai(example)]
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
    ///
    /// The key of the map is a role identifier (`RoleId`) and the value is lists of
    /// signing keys, encryption keys and payment addresses along with extended data map
    /// (`RbacRoleData`).
    #[oai(skip_serializing_if_is_empty)]
    roles: RoleMap,
    /// A list of invalid registrations.
    #[oai(skip_serializing_if_is_empty)]
    invalid: InvalidRegistrationList,
}

impl Example for RbacRegistrationChain {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            purpose: PurposeList::example(),
            last_persistent_txn: Some(TxnId::example()),
            last_volatile_txn: Some(TxnId::example()),
            roles: RoleMap::example(),
            invalid: InvalidRegistrationList::example(),
        }
    }
}

impl RbacRegistrationChain {
    /// Creates a new registration chain instance.
    pub(crate) fn new(
        catalyst_id: CatalystId, info: Option<&ChainInfo>, invalid: InvalidRegistrationList,
    ) -> anyhow::Result<Option<Self>> {
        if info.is_none() && invalid.is_empty() {
            return Ok(None);
        }

        let mut last_persistent_txn = None;
        let mut last_volatile_txn = None;
        let mut purpose = Vec::new().into();
        let mut roles = HashMap::new().into();
        if let Some(info) = info {
            last_persistent_txn = info.last_persistent_txn.map(Into::into);
            last_volatile_txn = info.last_volatile_txn.map(Into::into);
            purpose = info
                .chain
                .purpose()
                .iter()
                .copied()
                .map(UUIDv4::from)
                .collect::<Vec<_>>()
                .into();
            roles = role_data(info)?.into();
        }

        Ok(Some(Self {
            catalyst_id,
            last_persistent_txn,
            last_volatile_txn,
            purpose,
            roles,
            invalid,
        }))
    }
}

/// Gets and converts a role data from the given chain info.
fn role_data(info: &ChainInfo) -> anyhow::Result<HashMap<RoleId, RbacRoleData>> {
    info.chain
        .role_data_history()
        .iter()
        .map(|(&role, data)| {
            RbacRoleData::new(data, info.last_persistent_slot, &info.chain).map(|rbac| (role, rbac))
        })
        .collect()
}
