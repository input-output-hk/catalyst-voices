//! Registration Endpoints
use poem_openapi::{
    param::{Path, Query},
    payload::Json,
    types::Example,
    ApiResponse, OpenApi,
};

use crate::service::{
    common::{
        auth::none::NoAuthorization,
        objects::legacy::{
            event_id::EventId, voter_registration::VoterRegistration,
            voting_public_key::VotingPublicKey,
        },
        responses::WithErrorResponses,
        tags::ApiTags,
    },
    utilities::middleware::event_db_schema_validation::event_db_schema_version_validation,
};

/// Registration API Endpoints
pub(crate) struct RegistrationApi;

/// Endpoint responses
#[derive(ApiResponse)]
enum Responses {
    /// Voter's registration info.
    #[oai(status = 200)]
    Ok(Json<VoterRegistration>),
}

/// All responses
type AllResponses = WithErrorResponses<Responses>;

#[OpenApi(tag = "ApiTags::Legacy")]
impl RegistrationApi {
    /// Voter's info
    ///
    /// Get the voter's registration and voting power by their Public Voting Key.
    /// The Public Voting Key must match the voter's most recent valid
    /// [CIP-15](https://cips.cardano.org/cips/cip15) or [CIP-36](https://cips.cardano.org/cips/cip36) registration on-chain.
    /// If the `event_id` query parameter is omitted, then the latest voting power is
    /// retrieved. If the `with_delegators` query parameter is omitted, then
    /// `delegator_addresses` field of `VoterInfo` type does not provided.
    #[allow(clippy::unused_async)]
    #[allow(unused_variables)]
    #[oai(
        path = "/v1/registration/voter/:voting_key",
        method = "get",
        operation_id = "getVoterInfo",
        transform = "event_db_schema_version_validation",
        deprecated = true
    )]
    async fn get_voter_info(
        &self,
        /// A Voters Public ED25519 Key (as registered in their most recent valid
        /// [CIP-15](https://cips.cardano.org/cips/cip15) or [CIP-36](https://cips.cardano.org/cips/cip36) registration).
        #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
        voting_key: Path<VotingPublicKey>,
        /// The Event Index to return results for.
        /// See [GET Events](Link to events endpoint) for details on retrieving all valid
        /// event IDs.
        #[oai(validator(minimum(value = "0"), maximum(value = "2147483647")))]
        event_index: Query<Option<EventId>>,
        /// If this optional flag is set, the response will include the delegator's list
        /// in the response. Otherwise, it will be omitted.
        #[oai(default)]
        with_delegators: Query<bool>,
        /// No Auth Required
        _auth: NoAuthorization,
    ) -> AllResponses {
        Responses::Ok(Json(VoterRegistration::example())).into()
    }
}
