//! RBAC registration V2 chain.

use poem_openapi::{Object, types::Example};

use crate::{
    rbac::ChainInfo,
    service::{
        api::cardano::rbac::registrations_get::{
            invalid_registration_list::InvalidRegistrationList,
            purpose_list::PurposeList,
            v2::{
                role_data::RbacRoleData, role_list::RbacRoleList,
                stake_address_info_list::StakeAddressInfoList,
            },
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
pub struct RbacRegistrationChainV2 {
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
    /// A list of role data.
    #[oai(skip_serializing_if_is_empty)]
    roles: RbacRoleList,
    /// A list of invalid registrations.
    #[oai(skip_serializing_if_is_none)]
    invalid: Option<InvalidRegistrationList>,
    /// A list of stake addresses of the chain.
    #[oai(skip_serializing_if_is_empty)]
    stake_addresses: StakeAddressInfoList,
}

impl Example for RbacRegistrationChainV2 {
    fn example() -> Self {
        Self {
            catalyst_id: CatalystId::example(),
            purpose: PurposeList::example(),
            last_persistent_txn: Some(TxnId::example()),
            last_volatile_txn: Some(TxnId::example()),
            roles: RbacRoleList::example(),
            invalid: Some(InvalidRegistrationList::example()),
            stake_addresses: StakeAddressInfoList::example(),
        }
    }
}

impl RbacRegistrationChainV2 {
    /// Creates a new registration chain instance.
    pub(crate) fn new(
        catalyst_id: CatalystId,
        info: Option<&ChainInfo>,
        invalid: InvalidRegistrationList,
    ) -> anyhow::Result<Option<Self>> {
        if info.is_none() && invalid.is_empty() {
            return Ok(None);
        }

        let invalid = (!invalid.is_empty()).then_some(invalid);
        let mut last_persistent_txn = None;
        let mut last_volatile_txn = None;
        let mut purpose = Vec::new().into();
        let mut roles = Vec::new().into();
        // TODO: This list needs to be updated as a part of the
        // https://github.com/input-output-hk/catalyst-voices/issues/3464 task.
        let stake_addresses = Vec::new().into();
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
            stake_addresses,
        }))
    }
}

/// Gets and converts a role data from the given chain info.
fn role_data(info: &ChainInfo) -> anyhow::Result<Vec<RbacRoleData>> {
    info.chain
        .role_data_history()
        .iter()
        .map(|(&role, data)| RbacRoleData::new(role, data, info.last_persistent_slot, &info.chain))
        .collect()
}
