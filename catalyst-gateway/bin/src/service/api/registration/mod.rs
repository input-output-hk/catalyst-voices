//! Registration Endpoints
use std::sync::Arc;

use poem::web::Data;
use poem_extensions::{
    response,
    UniResponse::{T200, T404, T500},
};
use poem_openapi::{
    param::{Path, Query},
    payload::Json,
    OpenApi,
};

use crate::{
    service::common::{
        objects::{
            event_id::EventId, voter_registration::VoterRegistration,
            voting_public_key::VotingPublicKey,
        },
        responses::{
            resp_2xx::OK,
            resp_4xx::NotFound,
            resp_5xx::{server_error, ServerError},
        },
        tags::ApiTags,
    },
    state::State,
};

/// Registration API Endpoints
pub(crate) struct RegistrationApi;

#[OpenApi(prefix_path = "/registration", tag = "ApiTags::Registration")]
impl RegistrationApi {
    #[oai(
        path = "/voter/:voting_key",
        method = "get",
        operation_id = "getVoterInfo"
    )]
    /// Voter's info
    ///
    /// Get the voter's registration and voting power by their Public Voting Key.
    /// The Public Voting Key must match the voter's most recent valid
    /// [CIP-15](https://cips.cardano.org/cips/cip15) or [CIP-36](https://cips.cardano.org/cips/cip36) registration on-chain.
    /// If the `event_id` query parameter is omitted, then the latest voting power is
    /// retrieved. If the `with_delegators` query parameter is omitted, then
    /// `delegator_addresses` field of `VoterInfo` type does not provided.
    async fn get_voter_info(
        &self, pool: Data<&Arc<State>>,
        /// A Voters Public ED25519 Key (as registered in their most recent valid
        /// [CIP-15](https://cips.cardano.org/cips/cip15) or [CIP-36](https://cips.cardano.org/cips/cip36) registration).
        #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
        voting_key: Path<VotingPublicKey>,
        /// The Event ID to return results for.
        /// See [GET Events](Link to events endpoint) for details on retrieving all valid
        /// event IDs.
        #[oai(validator(minimum(value = "0")))]
        event_id: Query<Option<EventId>>,
        /// If this optional flag is set, the response will include the delegator's list
        /// in the response. Otherwise, it will be omitted.
        #[oai(default)]
        with_delegators: Query<bool>,
    ) -> response! {
           200: OK<Json<VoterRegistration>>,
           404: NotFound,
           500: ServerError,
       } {
        let voter = pool
            .event_db
            .get_voter(
                &event_id.0.map(Into::into),
                voting_key.0 .0,
                *with_delegators,
            )
            .await;
        match voter {
            Ok(voter) => {
                match voter.try_into() {
                    Ok(voter) => T200(OK(Json(voter))),
                    Err(err) => T500(server_error!("{}", err.to_string())),
                }
            },
            Err(crate::event_db::error::Error::NotFound(_)) => T404(NotFound),
            Err(err) => T500(server_error!("{}", err.to_string())),
        }
    }
}
