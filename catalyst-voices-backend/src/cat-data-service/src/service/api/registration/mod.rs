use crate::service::common::objects::{
    event_id::EventId, voter_registration::VoterRegistration, voting_public_key::VotingPublicKey,
};
use crate::service::common::responses::resp_2xx::OK;
use crate::service::common::responses::resp_4xx::NotFound;
use crate::service::common::responses::resp_5xx::{server_error, ServerError};
use crate::{service::common::tags::ApiTags, state::State};
use poem::web::Data;
use poem_extensions::response;
use poem_extensions::UniResponse::{T200, T404, T500};
use poem_openapi::{
    param::{Path, Query},
    payload::Json,
    OpenApi,
};
use std::sync::Arc;

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
    /// If the `event_id` query parameter is omitted, then the latest voting power is retrieved.
    /// If the `with_delegators` query parameter is ommitted, then `delegator_addresses` field of `VoterInfo` type does not provided.
    ///
    async fn get_voter_info(
        &self,
        pool: Data<&Arc<State>>,

        /// A Voters Public ED25519 Key (as registered in their most recent valid
        /// [CIP-15](https://cips.cardano.org/cips/cip15) or [CIP-36](https://cips.cardano.org/cips/cip36) registration).
        #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
        voting_key: Path<VotingPublicKey>,

        /// The Event ID to return results for.
        /// See [GET Events](Link to events endpoint) for details on retrieving all valid event IDs.
        #[oai(validator(minimum(value = "0")))]
        event_id: Query<Option<EventId>>,

        /// If this optional flag is set, the response will include the delegator's list in the response.
        /// Otherwise, it will be omitted.
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
            Ok(voter) => match voter.try_into() {
                Ok(voter) => T200(OK(Json(voter))),
                Err(err) => T500(server_error!("{}", err.to_string())),
            },
            Err(event_db::error::Error::NotFound(_)) => T404(NotFound),
            Err(err) => T500(server_error!("{}", err.to_string())),
        }
    }
}

/// Need to setup and run a test event db instance
/// To do it you can use the following commands:
/// Prepare docker images
/// ```
/// earthly ./containers/event-db-migrations+docker --data=test
/// ```
/// Run event-db container
/// ```
/// docker-compose -f src/event-db/docker-compose.yml up migrations
/// ```
/// Also need establish `EVENT_DB_URL` env variable with the following value
/// ```
/// EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
/// ```
/// https://github.com/input-output-hk/catalyst-core/tree/main/src/event-db/Readme.md
#[cfg(test)]
mod tests {
    use crate::{service::poem_service::tests::mk_test_app, state::State};
    use poem::http::StatusCode;
    use std::sync::Arc;

    #[tokio::test]
    async fn voter_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = mk_test_app(state);

        let resp = app
            .get(format!("/api/v1/registration/voter/{0}", "voting_key_1"))
            .send()
            .await;
        resp.assert_status(StatusCode::OK);
        resp.assert_json(serde_json::json!(
            {
                "voter_info": {
                    "voting_power": 250,
                    "voting_group": "rep",
                    "delegations_power": 250,
                    "delegations_count": 2,
                    "voting_power_saturation": 0.625,
                },
                "as_at": "2022-03-31T12:00:00+00:00",
                "last_updated": "2022-03-31T12:00:00+00:00",
                "final": true
            }
        ))
        .await;

        let resp = app
            .get(format!(
                "/api/v1/registration/voter/{0}?with_delegators=true",
                "voting_key_1"
            ))
            .send()
            .await;
        resp.assert_status(StatusCode::OK);
        resp.assert_json(serde_json::json!(
            {
                "voter_info": {
                    "voting_power": 250,
                    "voting_group": "rep",
                    "delegations_power": 250,
                    "delegations_count": 2,
                    "voting_power_saturation": 0.625,
                    "delegator_addresses": ["stake_public_key_1", "stake_public_key_2"]
                },
                "as_at": "2022-03-31T12:00:00+00:00",
                "last_updated": "2022-03-31T12:00:00+00:00",
                "final": true
            }
        ))
        .await;

        let resp = app
            .get(format!(
                "/api/v1/registration/voter/{0}?event_id={1}",
                "voting_key_1", 1
            ))
            .send()
            .await;
        resp.assert_status(StatusCode::OK);
        resp.assert_json(serde_json::json!(
            {
                "voter_info": {
                    "voting_power": 250,
                    "voting_group": "rep",
                    "delegations_power": 250,
                    "delegations_count": 2,
                    "voting_power_saturation": 0.625,
                },
                "as_at": "2020-03-31T12:00:00+00:00",
                "last_updated": "2020-03-31T12:00:00+00:00",
                "final": true
            }
        ))
        .await;

        let resp = app
            .get(format!(
                "/api/v1/registration/voter/{0}?event_id={1}&with_delegators=true",
                "voting_key_1", 1
            ))
            .send()
            .await;
        resp.assert_status(StatusCode::OK);
        resp.assert_json(serde_json::json!(
            {
                "voter_info": {
                    "voting_power": 250,
                    "voting_group": "rep",
                    "delegations_power": 250,
                    "delegations_count": 2,
                    "voting_power_saturation": 0.625,
                    "delegator_addresses": ["stake_public_key_1", "stake_public_key_2"]
                },
                "as_at": "2020-03-31T12:00:00+00:00",
                "last_updated": "2020-03-31T12:00:00+00:00",
                "final": true
            }
        ))
        .await;

        let resp = app
            .get(format!("/api/v1/registration/voter/{0}", "voting_key"))
            .send()
            .await;
        resp.assert_status(StatusCode::NOT_FOUND);

        let resp = app
            .get(format!("/api/v1/registration/voter/{0}", "voting_key"))
            .send()
            .await;
        resp.assert_status(StatusCode::NOT_FOUND);
    }
}
