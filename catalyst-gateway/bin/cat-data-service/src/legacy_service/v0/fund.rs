use crate::{
    legacy_service::{handle_result, types::SerdeType},
    service::Error,
    state::State,
};
use axum::{routing::get, Router};
use event_db::types::vit_ss::fund::FundWithNext;
use std::sync::Arc;

pub fn fund(state: Arc<State>) -> Router {
    Router::new().route(
        "/fund",
        get(|| async { handle_result(fund_exec(state).await) }),
    )
}

async fn fund_exec(state: Arc<State>) -> Result<SerdeType<FundWithNext>, Error> {
    tracing::debug!("fund_query",);

    let fund = state.event_db.get_fund().await?.into();
    Ok(fund)
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
    async fn fund_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri("/api/v0/fund".to_string())
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "id": 4,
                    "fund_name": "Test Fund 4",
                    "fund_goal": "Test Fund 4 description",
                    "voting_power_threshold": 1,
                    "fund_start_time": "2022-05-01T12:00:00+00:00",
                    "fund_end_time": "2024-06-01T12:00:00+00:00",
                    "next_fund_start_time": "1970-01-01T00:00:00+00:00",
                    "registration_snapshot_time": "2022-03-31T12:00:00+00:00",
                    "next_registration_snapshot_time": "1970-01-01T00:00:00+00:00",
                    "chain_vote_plans": [
                        {
                            "id": 5,
                            "chain_voteplan_id": "1",
                            "chain_vote_start_time": "2022-05-01T12:00:00+00:00",
                            "chain_vote_end_time": "2024-06-01T12:00:00+00:00",
                            "chain_committee_end_time": "2024-07-01T12:00:00+00:00",
                            "chain_voteplan_payload": "public",
                            "chain_vote_encryption_key": "",
                            "fund_id": 4,
                            "token_identifier": "voting token 3",
                        },
                        {
                            "id": 6,
                            "chain_voteplan_id": "2",
                            "chain_vote_start_time": "2022-05-01T12:00:00+00:00",
                            "chain_vote_end_time": "2024-06-01T12:00:00+00:00",
                            "chain_committee_end_time": "2024-07-01T12:00:00+00:00",
                            "chain_voteplan_payload": "public",
                            "chain_vote_encryption_key": "",
                            "fund_id": 4,
                            "token_identifier": "",
                        }
                    ],
                    "challenges": [
                        {
                            "internal_id": 3,
                            "id": 3,
                            "challenge_type": "catalyst-simple",
                            "title": "title 3",
                            "description": "description 3",
                            "rewards_total": 100,
                            "proposers_rewards": 100,
                            "challenge_url": "objective 3 url",
                            "fund_id": 4,
                            "highlights": {
                                "sponsor": "objective 3 sponsor"
                            },
                        },
                        {
                            "internal_id": 4,
                            "id": 4,
                            "challenge_type": "catalyst-native",
                            "title": "title 4",
                            "description": "description 4",
                            "rewards_total": 0,
                            "proposers_rewards": 0,
                            "challenge_url": "",
                            "fund_id": 4,
                            "highlights": null,
                        }
                    ],
                    "insight_sharing_start": "2022-03-01T12:00:00+00:00",
                    "proposal_submission_start": "2022-03-01T12:00:00+00:00",
                    "refine_proposals_start": "2022-03-01T12:00:00+00:00",
                    "finalize_proposals_start": "2022-03-01T12:00:00+00:00",
                    "proposal_assessment_start": "2022-03-01T12:00:00+00:00",
                    "assessment_qa_start": "2022-03-01T12:00:00+00:00",
                    "snapshot_start": "2022-03-31T12:00:00+00:00",
                    "voting_start": "2022-05-01T12:00:00+00:00",
                    "voting_end": "2024-06-01T12:00:00+00:00",
                    "tallying_end": "2024-07-01T12:00:00+00:00",
                    "goals": [
                        {
                            "id": 13,
                            "goal_name": "goal 13",
                            "fund_id": 4
                        },
                        {
                            "id": 14,
                            "goal_name": "goal 14",
                            "fund_id": 4
                        },
                        {
                            "id": 15,
                            "goal_name": "goal 15",
                            "fund_id": 4
                        },
                        {
                            "id": 16,
                            "goal_name": "goal 16",
                            "fund_id": 4
                        }
                    ],
                    "groups": [
                        {
                            "group_id": "direct",
                            "token_identifier": "voting token 3",
                            "fund_id": 4,
                        }
                    ],
                    "survey_url": "",
                    "results_url": "",
                    "next": {
                        "id": 5,
                        "fund_name": "Test Fund 5",
                        "insight_sharing_start":  "1970-01-01T00:00:00+00:00",
                        "proposal_submission_start": "1970-01-01T00:00:00+00:00",
                        "refine_proposals_start": "1970-01-01T00:00:00+00:00",
                        "finalize_proposals_start": "1970-01-01T00:00:00+00:00",
                        "proposal_assessment_start": "1970-01-01T00:00:00+00:00",
                        "assessment_qa_start": "1970-01-01T00:00:00+00:00",
                        "snapshot_start": "1970-01-01T00:00:00+00:00",
                        "voting_start": "1970-01-01T00:00:00+00:00",
                        "voting_end": "1970-01-01T00:00:00+00:00",
                        "tallying_end": "1970-01-01T00:00:00+00:00",
                    }
                }
            ),
        );
    }
}
