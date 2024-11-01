//! Cardano API endpoints
use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};
use types::{DateTime, SlotNumber};

use crate::service::{
    common::{
        auth::none_or_rbac::NoneOrRBAC, objects::cardano::network::Network, tags::ApiTags,
        types::cardano::address::Cip19StakeAddress,
    },
    utilities::middleware::schema_validation::schema_version_validation,
};

mod cip36;
mod date_time_to_slot_number_get;
mod rbac;
mod registration_get;
mod staked_ada_get;
mod sync_state_get;
pub(crate) mod types;

/// Cardano Follower API Endpoints
pub(crate) struct CardanoApi;

#[OpenApi(tag = "ApiTags::Cardano")]
impl CardanoApi {
    /// Get staked ADA amount.
    ///
    /// This endpoint returns the total Cardano's staked ADA amount to the corresponded
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
        /// Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
        stake_address: Path<Cip19StakeAddress>,
        /// Cardano network type.
        /// If omitted network type is identified from the stake address.
        /// If specified it must be correspondent to the network type encoded in the stake
        /// address.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
        /// Slot number at which the staked ADA amount should be calculated.
        /// If omitted latest slot number is used.
        // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
        #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
        slot_number: Query<Option<SlotNumber>>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
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
        /// Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
        stake_address: Path<Cip19StakeAddress>,
        /// Cardano network type.
        /// If omitted network type is identified from the stake address.
        /// If specified it must be correspondent to the network type encoded in the stake
        /// address.
        /// As `preprod` and `preview` network types in the stake address encoded as a
        /// `testnet`, to specify `preprod` or `preview` network type use this
        /// query parameter.
        network: Query<Option<Network>>,
        /// Slot number at which the staked ADA amount should be calculated.
        /// If omitted latest slot number is used.
        // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
        #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
        slot_number: Query<Option<SlotNumber>>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
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
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
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
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> date_time_to_slot_number_get::AllResponses {
        date_time_to_slot_number_get::endpoint(date_time.0, network.0).await
    }

    /// Get latest CIP36 registrations from stake address.
    ///
    /// This endpoint gets the latest registration given a stake address.
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
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> cip36::SingleRegistrationResponse {
        cip36::get_latest_registration_from_stake_addr(stake_addr.0, true).await
    }

    /// Get latest CIP36 registrations from a stake key hash.
    ///
    /// This endpoint gets the latest registration given a stake key hash.
    #[oai(
        path = "/draft/cardano/cip36/latest_registration/stake_key_hash",
        method = "get",
        operation_id = "latestRegistrationGivenStakeHash"
    )]
    async fn latest_registration_cip36_given_stake_key_hash(
        &self,
        /// Stake Key Hash to find the latest registration for.
        #[oai(validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]"))]
        stake_key_hash: Query<String>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> cip36::SingleRegistrationResponse {
        cip36::get_latest_registration_from_stake_key_hash(stake_key_hash.0, true).await
    }

    /// Get latest CIP36 registrations from voting key.
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
        /// Voting Key to find CIP36 registrations for.
        #[oai(validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]"))]
        vote_key: Query<String>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> cip36::MultipleRegistrationResponse {
        cip36::get_associated_vote_key_registrations(vote_key.0, true).await
    }

    #[oai(
        path = "/draft/rbac/chain_root/:stake_address",
        method = "get",
        operation_id = "rbacChainRootGet"
    )]
    /// Get RBAC chain root
    ///
    /// This endpoint returns the RBAC certificate chain root for a given stake address.
    async fn rbac_chain_root_get(
        &self,
        /// Stake address to get the chain root for.
        Path(stake_address): Path<Cip19StakeAddress>,
    ) -> rbac::chain_root_get::AllResponses {
        rbac::chain_root_get::endpoint(stake_address).await
    }

    #[oai(
        path = "/draft/rbac/registrations/:chain_root",
        method = "get",
        operation_id = "rbacRegistrations"
    )]
    /// Get registrations by RBAC chain root
    ///
    /// This endpoint returns the registrations for a given chain root.
    async fn rbac_registrations_get(
        &self,
        /// Chain root to get the registrations for.
        #[oai(validator(max_length = 66, min_length = 64, pattern = "0x[0-9a-f]{64}"))]
        Path(chain_root): Path<String>,
    ) -> rbac::registrations_get::AllResponses {
        rbac::registrations_get::endpoint(chain_root).await
    }

    #[oai(
        path = "/draft/rbac/role0_chain_root/:role0_key",
        method = "get",
        operation_id = "rbacRole0KeyChainRoot"
    )]
    /// Get RBAC chain root for a given role0 key.
    ///
    /// This endpoint returns the RBAC certificate chain root for a given role 0 key.
    async fn rbac_role0_key_chain_root(
        &self,
        /// Role0 key to get the chain root for.
        #[oai(validator(min_length = 34, max_length = 34, pattern = "0x[0-9a-f]{32}"))]
        Path(role0_key): Path<String>,
    ) -> rbac::role0_chain_root_get::AllResponses {
        rbac::role0_chain_root_get::endpoint(role0_key).await
    }
}
