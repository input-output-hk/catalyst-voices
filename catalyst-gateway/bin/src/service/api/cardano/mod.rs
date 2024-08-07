//! Cardano API endpoints

use std::sync::Arc;

use poem::web::Data;
use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};

use crate::{
    event_db::cardano::chain_state::{DateTime, SlotNumber},
    service::{
        common::{
            objects::cardano::{network::Network, stake_address::StakeAddress},
            tags::ApiTags,
        },
        utilities::middleware::schema_validation::schema_version_validation,
    },
    state::State,
};

mod date_time_to_slot_number_get;
mod registration_get;
mod staked_ada_get;
mod sync_state_get;

/// Cardano Follower API Endpoints
pub(crate) struct CardanoApi;

#[OpenApi(prefix_path = "/cardano", tag = "ApiTags::Cardano")]
impl CardanoApi {
    #[oai(
        path = "/staked_ada/:stake_address",
        method = "get",
        operation_id = "stakedAdaAmountGet",
        transform = "schema_version_validation"
    )]
    /// Get staked ada amount.
    ///
    /// This endpoint returns the total Cardano's staked ada amount to the corresponded
    /// user's stake address.
    async fn staked_ada_get(
        &self, data: Data<&Arc<State>>,
        /// The stake address of the user.
        /// Should a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
        stake_address: Path<StakeAddress>,
        /// Cardano network type.
        /// If omitted network type is identified from the stake address.
        /// If specified it must be correspondent to the network type encoded in the stake
        /// address.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
        /// Slot number at which the staked ada amount should be calculated.
        /// If omitted latest slot number is used.
        // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
        #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
        slot_number: Query<Option<SlotNumber>>,
    ) -> staked_ada_get::AllResponses {
        staked_ada_get::endpoint(&data, stake_address.0, network.0, slot_number.0).await
    }

    #[oai(
        path = "/registration/:stake_address",
        method = "get",
        operation_id = "registrationGet",
        transform = "schema_version_validation"
    )]
    /// Get registration info.
    ///
    /// This endpoint returns the registration info followed by the [CIP-36](https://cips.cardano.org/cip/CIP-36/) to the
    /// corresponded user's stake address.
    async fn registration_get(
        &self, data: Data<&Arc<State>>,
        /// The stake address of the user.
        /// Should a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
        stake_address: Path<StakeAddress>,
        /// Cardano network type.
        /// If omitted network type is identified from the stake address.
        /// If specified it must be correspondent to the network type encoded in the stake
        /// address.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
        /// Slot number at which the staked ada amount should be calculated.
        /// If omitted latest slot number is used.
        // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
        #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
        slot_number: Query<Option<SlotNumber>>,
    ) -> registration_get::AllResponses {
        registration_get::endpoint(&data, stake_address.0, network.0, slot_number.0).await
    }

    #[oai(
        path = "/sync_state",
        method = "get",
        operation_id = "syncStateGet",
        transform = "schema_version_validation"
    )]
    /// Get Cardano follower's sync state.
    ///
    /// This endpoint returns the current cardano follower's sync state info.
    async fn sync_state_get(
        &self, data: Data<&Arc<State>>,
        /// Cardano network type.
        /// If omitted `mainnet` network type is defined.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
    ) -> sync_state_get::AllResponses {
        sync_state_get::endpoint(&data, network.0).await
    }

    #[oai(
        path = "/date_time_to_slot_number",
        method = "get",
        operation_id = "dateTimeToSlotNumberGet",
        transform = "schema_version_validation"
    )]
    /// Get Cardano slot info to the provided date-time.
    ///
    /// This endpoint returns the closest cardano slot info to the provided
    /// date-time.
    async fn date_time_to_slot_number_get(
        &self, data: Data<&Arc<State>>,
        /// The date-time for which the slot number should be calculated.
        /// If omitted current date time is used.
        date_time: Query<Option<DateTime>>,
        /// Cardano network type.
        /// If omitted `mainnet` network type is defined.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
    ) -> date_time_to_slot_number_get::AllResponses {
        date_time_to_slot_number_get::endpoint(&data, date_time.0, network.0).await
    }
}
