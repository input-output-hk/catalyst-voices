//! CIP36 Registration Endpoints

use poem_openapi::{param::Query, OpenApi};

use self::cardano::slot_no::SlotNo;
use crate::service::common::{
    self,
    auth::api_key::InternalApiKeyAuthorization,
    tags::ApiTags,
    types::cardano::{self},
};

pub(crate) mod endpoint;

pub(crate) mod filter;

pub(crate) mod response;

/// Cardano Staking API Endpoints
pub(crate) struct Api;

#[OpenApi(tag = "ApiTags::Cardano")]
impl Api {
    /// CIP36 registrations.
    ///
    /// This endpoint gets the latest registration given either the voting key, stake
    /// address, stake public key or the auth token.
    ///
    /// Registration can be the latest to date, or at a particular date-time or slot
    /// number.
    // Required To be able to look up for:
    // 1. Voting Public Key
    // 2. Cip-19 stake address
    // 3. All - Hidden option and would need a hidden api key header (used to create a snapshot
    //    replacement.)
    // 4. Stake addresses associated with current Role0 registration (if none of the above
    //    provided).
    // If none of the above provided, return not found.
    #[oai(
        path = "/v1/cardano/registration/cip36",
        method = "get",
        operation_id = "cardanoRegistrationCip36",
        hidden = true
    )]
    async fn get_registration(
        &self, lookup: Query<Option<cardano::query::stake_or_voter::StakeOrVoter>>,
        asat: Query<Option<cardano::query::AsAt>>,
        page: Query<Option<common::types::generic::query::pagination::Page>>,
        limit: Query<Option<common::types::generic::query::pagination::Limit>>,
        _auth: InternalApiKeyAuthorization,
    ) -> response::AllRegistration {
        endpoint::cip36_registrations(
            lookup.0,
            SlotNo::into_option(asat.0),
            page.0.unwrap_or_default(),
            limit.0.unwrap_or_default(),
        )
        .await
    }
}
