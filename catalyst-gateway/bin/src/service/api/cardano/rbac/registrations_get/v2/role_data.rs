//! A role data.

use anyhow::Context;
use cardano_chain_follower::Slot;
use catalyst_types::catalyst_id::role_index::RoleId;
use poem_openapi::{Object, types::Example};
use rbac_registration::{
    cardano::cip509::{PointData, RoleData},
    registration::cardano::RegistrationChain,
};

use crate::{
    service::api::cardano::rbac::registrations_get::{
        role_id::CatalystRoleId,
        v2::{
            extended_data::ExtendedData, extended_data_list::ExtendedDataList, key_data::KeyData,
            key_data_list::KeyDataList, payment_data::PaymentData,
            payment_data_list::PaymentDataList,
        },
    },
    settings::Settings,
};

/// A RBAC registration role data.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub struct RbacRoleData {
    /// A Catalyst user role identifier.
    role_id: CatalystRoleId,
    /// A list of role signing keys.
    #[oai(skip_serializing_if_is_empty)]
    signing_keys: KeyDataList,
    /// A list of role encryption keys.
    #[oai(skip_serializing_if_is_empty)]
    encryption_keys: KeyDataList,
    /// A list of role payment addresses.
    #[oai(skip_serializing_if_is_empty)]
    payment_addresses: PaymentDataList,
    /// A map of the extended data.
    ///
    /// Unlike other fields, we don't track history for this data.
    #[oai(skip_serializing_if_is_empty)]
    extended_data: ExtendedDataList,
}

impl RbacRoleData {
    /// Creates a new `RbacRoleData` instance.
    pub fn new(
        role: RoleId,
        point_data: &[PointData<RoleData>],
        last_persistent_slot: Slot,
        chain: &RegistrationChain,
    ) -> anyhow::Result<Self> {
        let network = Settings::cardano_network();

        let mut signing_keys = Vec::new();
        let mut encryption_keys = Vec::new();
        let mut payment_addresses = Vec::new();
        let mut extended_data = Vec::new();

        for point in point_data {
            let slot = point.point().slot_or_default();
            let txn_index = point.txn_index();
            let is_persistent = slot <= last_persistent_slot;
            let time = network.slot_to_time(slot);
            let data = point.data();

            if let Some(signing_key) = data.signing_key() {
                signing_keys.push(
                    KeyData::new(
                        is_persistent,
                        time.into(),
                        slot.into(),
                        txn_index.into(),
                        signing_key,
                        point.point(),
                        chain,
                    )
                    .context("Invalid signing key")?,
                );
            }
            if let Some(encryption_key) = data.encryption_key() {
                encryption_keys.push(
                    KeyData::new(
                        is_persistent,
                        time.into(),
                        slot.into(),
                        txn_index.into(),
                        encryption_key,
                        point.point(),
                        chain,
                    )
                    .context("Invalid encryption key")?,
                );
            }
            payment_addresses.push(
                PaymentData::new(
                    is_persistent,
                    time.into(),
                    slot.into(),
                    txn_index.into(),
                    data.payment_key().cloned(),
                )
                .context("Invalid payment address")?,
            );
            extended_data.extend(
                data.extended_data()
                    .iter()
                    .map(|(key, value)| ExtendedData::new(*key, value.clone())),
            );
        }

        Ok(Self {
            role_id: role.into(),
            signing_keys: signing_keys.into(),
            encryption_keys: encryption_keys.into(),
            payment_addresses: payment_addresses.into(),
            extended_data: extended_data.into(),
        })
    }
}

impl Example for RbacRoleData {
    fn example() -> Self {
        Self {
            role_id: CatalystRoleId::example(),
            signing_keys: KeyDataList::example(),
            encryption_keys: KeyDataList::example(),
            payment_addresses: PaymentDataList::example(),
            extended_data: ExtendedDataList::example(),
        }
    }
}
