//! Registration Endpoints
use poem_openapi::{
    param::{Path, Query},
    payload::Json,
    types::Example,
    ApiResponse, OpenApi,
};

use crate::service::{
    common::{
        objects::legacy::{
            event_id::EventId, voter_registration::VoterRegistration,
            voting_public_key::VotingPublicKey,
        },
        responses::WithErrorResponses,
        tags::ApiTags,
    },
    utilities::middleware::schema_validation::schema_version_validation,
};

/// Registration API Endpoints
pub(crate) struct RegistrationApi;

/// Endpoint responses
#[derive(ApiResponse)]
enum Responses {
    /// Voter's registration info
    #[oai(status = 200)]
    Ok(Json<VoterRegistration>),
}

/// All responses
type AllResponses = WithErrorResponses<Responses>;

#[OpenApi(prefix_path = "/registration", tag = "ApiTags::Registration")]
impl RegistrationApi {
    #[oai(
        path = "/voter/:voting_key",
        method = "get",
        operation_id = "getVoterInfo",
        transform = "schema_version_validation",
        deprecated = true
    )]
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
    async fn get_voter_info(
        &self,
        /// A Voters Public ED25519 Key (as registered in their most recent valid
        /// [CIP-15](https://cips.cardano.org/cips/cip15) or [CIP-36](https://cips.cardano.org/cips/cip36) registration).
        #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
        voting_key: Path<VotingPublicKey>,
        /// The Event ID to return results for.
        /// See [GET Events](Link to events endpoint) for details on retrieving all valid
        /// event IDs.
        // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
        #[oai(validator(minimum(value = "0"), maximum(value = "2147483647")))]
        event_id: Query<Option<EventId>>,
        /// If this optional flag is set, the response will include the delegator's list
        /// in the response. Otherwise, it will be omitted.
        #[oai(default)]
        with_delegators: Query<bool>,
    ) -> AllResponses {
        Responses::Ok(Json(VoterRegistration::example())).into()
    }
}
