use crate::{
    legacy_service::{handle_result, types::SerdeType},
    service::Error,
    state::State,
};
use axum::{extract::Path, routing::get, Router};
use event_db::types::{ballot::ObjectiveBallots, event::EventId};
use std::sync::Arc;

pub fn ballots(state: Arc<State>) -> Router {
    Router::new().route(
        "/ballots",
        get(move |path| async { handle_result(ballots_exec(path, state).await) }),
    )
}

async fn ballots_exec(
    Path(SerdeType(event)): Path<SerdeType<EventId>>,
    state: Arc<State>,
) -> Result<Vec<SerdeType<ObjectiveBallots>>, Error> {
    tracing::debug!("ballots_query, event: {0}", event.0,);

    let ballot = state
        .event_db
        .get_event_ballots(event)
        .await?
        .into_iter()
        .map(SerdeType)
        .collect();
    Ok(ballot)
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
    use super::*;
    use crate::legacy_service::{app, tests::response_body_to_json};
    use axum::{
        body::Body,
        http::{Request, StatusCode},
    };
    use tower::ServiceExt;

    #[tokio::test]
    async fn ballots_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri(format!("/api/v1/event/{0}/ballots", 1))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "objective_id": 1,
                    "ballots": [
                        {
                            "proposal_id": 10,
                            "ballot": {
                                "choices": ["yes", "no"],
                                "voteplans": [
                                    {
                                        "chain_proposal_index": 10,
                                        "group": "direct",
                                        "ballot_type": "public",
                                        "chain_voteplan_id": "1",
                                    },
                                    {
                                        "chain_proposal_index": 12,
                                        "group": "rep",
                                        "ballot_type": "public",
                                        "chain_voteplan_id": "2",
                                    }
                                ]
                            }
                        },
                        {
                            "proposal_id": 20,
                            "ballot": {
                                "choices": ["yes", "no"],
                                "voteplans": [
                                    {
                                        "chain_proposal_index": 11,
                                        "group": "direct",
                                        "ballot_type": "public",
                                        "chain_voteplan_id": "1",
                                    },
                                    {
                                        "chain_proposal_index": 13,
                                        "group": "rep",
                                        "ballot_type": "public",
                                        "chain_voteplan_id": "2",
                                    }
                                ]
                            }
                        },
                        {
                            "proposal_id": 30,
                            "ballot": {
                                "choices": ["yes", "no"],
                                "voteplans": []
                            }
                        }
                    ]
                }
            ]),
        );
    }
}
