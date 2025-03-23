//! RBAC registration chain.

use std::collections::HashMap;

use cardano_blockchain_types::TransactionId;
use poem_openapi::{types::Example, Object};
use rbac_registration::{
    cardano::cip509::{PointData, RoleData, RoleNumber},
    registration::cardano::RegistrationChain,
};

use crate::service::{
    api::cardano::rbac::registrations_get::{purpose_list::PurposeList, role_data::RbacRoleData},
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
pub(crate) struct RbacRegistrationChain {
    /// A Catalyst ID.
    catalyst_id: CatalystId,
    /// An ID of the last persistent transaction.
    #[oai(skip_serializing_if_is_none)]
    last_persistent_txn_id: Option<TxnId>,
    /// An ID of the last volatile transaction.
    #[oai(skip_serializing_if_is_none)]
    last_volatile_txn_id: Option<TxnId>,
    /// A list of registration purposes.
    #[oai(skip_serializing_if_is_empty)]
    purpose: PurposeList,
    /// A map of role number to role data.
    // This map is never empty, so there is no need to add the `skip_serializing_if_is_none`
    // attribute.
    roles: HashMap<u8, RbacRoleData>,
}

impl Example for RbacRegistrationChain {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            purpose: PurposeList::example(),
            last_persistent_txn_id: Some(TxnId::example()),
            last_volatile_txn_id: Some(TxnId::example()),
            roles: [(0, RbacRoleData::example())].into_iter().collect(),
        }
    }
}

impl RbacRegistrationChain {
    /// Creates a new registration chain instance.
    pub(crate) fn new(
        chain: RegistrationChain, persistent_id: Option<TransactionId>,
        volatile_id: Option<TransactionId>,
    ) -> Self {
        let catalyst_id = chain.catalyst_id().clone().into();
        let last_persistent_txn_id = persistent_id.map(Into::into);
        let last_volatile_txn_id = volatile_id.map(Into::into);
        let purpose = chain
            .purpose()
            .iter()
            .copied()
            .map(UUIDv4::from)
            .collect::<Vec<_>>()
            .into();
        // TODO: FIXME: Update catalyst libs.
        let roles = role_data(chain.all_role_data());

        Self {
            catalyst_id,
            last_persistent_txn_id,
            last_volatile_txn_id,
            purpose,
            roles,
        }
    }
}

fn role_data(
    role_data: &HashMap<RoleNumber, Vec<PointData<RoleData>>>,
) -> HashMap<u8, RbacRoleData> {
    role_data
        .iter()
        .map(|(&number, data)| {
            let data = RbacRoleData::new(data);
            (number.into(), data)
        })
        .collect()
}
