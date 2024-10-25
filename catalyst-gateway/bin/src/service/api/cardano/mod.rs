//! Cardano API endpoints
use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};
use types::{DateTime, SlotNumber};

use crate::service::{
    common::{
        objects::cardano::{network::Network, stake_address::StakeAddress},
        tags::ApiTags,
    },
    utilities::middleware::schema_validation::schema_version_validation,
};

mod cip36;
mod date_time_to_slot_number_get;
mod registration_get;
mod staked_ada_get;
mod sync_state_get;
pub(crate) mod types;

/// Cardano Follower API Endpoints
pub(crate) struct CardanoApi;

#[OpenApi(tag = "ApiTags::Cardano")]
impl CardanoApi {
    /// Get staked ada amount.
    ///
    /// This endpoint returns the total Cardano's staked ada amount to the corresponded
    /// user's stake address.
    #[oai(
        path = "/draft/cardano/staked_ada/:stake_address",
        method = "get",
        operation_id = "stakedAdaAmountGet",
        transform = "schema_version_validation"
    )]
    async fn staked_ada_get(
        &self,
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
        staked_ada_get::endpoint(stake_address.0, network.0, slot_number.0).await
    }

    /// Get registration info.
    ///
    /// This endpoint returns the registration info followed by the [CIP-36](https://cips.cardano.org/cip/CIP-36/) to the
    /// corresponded user's stake address.
    #[oai(
        path = "/draft/cardano/registration/:stake_address",
        method = "get",
        operation_id = "registrationGet",
        transform = "schema_version_validation"
    )]
    async fn registration_get(
        &self,
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
        registration_get::endpoint(stake_address.0, network.0, slot_number.0).await
    }

    /// Get Cardano follower's sync state.
    ///
    /// This endpoint returns the current cardano follower's sync state info.
    #[oai(
        path = "/draft/cardano/sync_state",
        method = "get",
        operation_id = "syncStateGet",
        transform = "schema_version_validation"
    )]
    async fn sync_state_get(
        &self,
        /// Cardano network type.
        /// If omitted `mainnet` network type is defined.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
    ) -> sync_state_get::AllResponses {
        sync_state_get::endpoint(network.0).await
    }

    /// Get Cardano slot info to the provided date-time.
    ///
    /// This endpoint returns the closest cardano slot info to the provided
    /// date-time.
    #[oai(
        path = "/draft/cardano/date_time_to_slot_number",
        method = "get",
        operation_id = "dateTimeToSlotNumberGet",
        transform = "schema_version_validation"
    )]
    async fn date_time_to_slot_number_get(
        &self,
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
        date_time_to_slot_number_get::endpoint(date_time.0, network.0).await
    }

    /// Cip36 registrations
    ///
    /// This endpoint gets the latest registration given a stake addr
    #[oai(
        path = "/draft/cardano/cip36/latest_registration/stake_addr",
        method = "get",
        operation_id = "latestRegistrationGivenStakeAddr"
    )]
    async fn latest_registration_cip36_given_stake_addr(
        &self,
        /// Stake Address to find the latest registration for.
        #[oai(validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]"))]
        stake_addr: Query<String>,
    ) -> cip36::SingleRegistrationResponse {
        cip36::get_latest_registration_from_stake_addr(stake_addr.0, true).await
    }

    /// Cip36 registrations
    ///
    /// This endpoint gets the latest registration given a stake key hash
    #[oai(
        path = "/draft/cardano/cip36/latest_registration/stake_key_hash",
        method = "get",
        operation_id = "latestRegistrationGivenStakeHash"
    )]
    async fn latest_registration_cip36_given_stake_key_hash(
        &self,
        #[oai(validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]"))]
        stake_key_hash: Query<String>,
    ) -> cip36::SingleRegistrationResponse {
        cip36::get_latest_registration_from_stake_key_hash(stake_key_hash.0, true).await
    }

    /// Cip36 registrations
    ///
    /// This endpoint returns the list of stake address registrations currently associated
    /// with a given voting key.
    #[oai(
        path = "/draft/cardano/cip36/latest_registration/vote_key",
        method = "get",
        operation_id = "latestRegistrationGivenVoteKey"
    )]
    async fn latest_registration_cip36_given_vote_key(
        &self,
        #[oai(validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]"))] vote_key: Query<
            String,
        >,
    ) -> cip36::MultipleRegistrationResponse {
        cip36::get_associated_vote_key_registrations(vote_key.0, true).await
    }
}
