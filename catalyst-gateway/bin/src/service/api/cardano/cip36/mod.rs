//! CIP36 Registration Endpoints

use ed25519_dalek::VerifyingKey;
use poem_openapi::{param::Query, OpenApi};

use self::cardano::slot_no::SlotNo;
use super::Ed25519HexEncodedPublicKey;
use crate::service::common::{
    self,
    auth::none_or_rbac::NoneOrRBAC,
    tags::ApiTags,
    types::cardano::{self},
};

pub(crate) mod endpoint;
pub(crate) mod old_endpoint;
pub(crate) mod response;

/// Cardano Staking API Endpoints
pub(crate) struct Api;

#[OpenApi(tag = "ApiTags::Cardano")]
impl Api {
    /// Get CIP36 registrations.
    ///
    /// This endpoint gets the latest registration given either the voting key, stake
    /// address, stake public key or the auth token.
    ///
    /// Registration can be the latest to date, or at a particular date-time or slot
    /// number.
    ///
    /// Required To be able to look up for:
    /// 1. Voting Public Key
    /// 2. Cip-19 stake address
    /// 3. Stake Public Key (Can be converted to stake address)
    /// 4. All - Hidden option and would need a hidden api key header (used to create a
    ///    snapshot replacement.)
    /// 4. Stake addresses associated with current Role0 registration (if none of the
    ///    above provided).
    /// If none of the above provided, return not found.
    #[oai(
        path = "/draft/cardano/registration/cip36",
        method = "get",
        operation_id = "cardanoRegistrationCip36"
    )]
    async fn get_registration(
        &self,
        /// Stake Public Key to find the latest registration for.
        stake_pub_key: Query<Ed25519HexEncodedPublicKey>, // Validation provided by type.
        /// Maximum Slot or Time to get the registration for.  
        /// If not defined, gets the absolute latest registration.
        asat: Query<Option<cardano::query::AsAt>>,
        page: Query<Option<common::types::generic::query::pagination::Page>>,
        limit: Query<Option<common::types::generic::query::pagination::Limit>>,
        /// No Authorization required, but Token permitted.
        auth: NoneOrRBAC,
    ) -> response::AllRegistration {
        endpoint::cip36_registrations(
            Some(stake_pub_key.0),
            SlotNo::into_option(asat.0),
            page.0.unwrap_or_default(),
            limit.0.unwrap_or_default(),
            auth,
        )
        .await
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
        /// Stake Public Key to find the latest registration for.
        stake_pub_key: Query<Ed25519HexEncodedPublicKey>, // Validation provided by type.
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> old_endpoint::SingleRegistrationResponse {
        let hex_key = stake_pub_key.0;
        let pub_key: VerifyingKey = hex_key.into();

        old_endpoint::get_latest_registration_from_stake_addr(&pub_key, true).await
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
    ) -> old_endpoint::SingleRegistrationResponse {
        old_endpoint::get_latest_registration_from_stake_key_hash(stake_key_hash.0, true).await
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
        #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]"))]
        vote_key: Query<String>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> old_endpoint::MultipleRegistrationResponse {
        old_endpoint::get_associated_vote_key_registrations(vote_key.0, true).await
    }
}
