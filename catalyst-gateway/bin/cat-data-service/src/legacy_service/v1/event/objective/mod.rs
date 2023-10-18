use crate::{
    legacy_service::{handle_result, types::SerdeType, v1::LimitOffset},
    service::Error,
    state::State,
};
use axum::{
    extract::{Path, Query},
    routing::get,
    Router,
};
use event_db::types::{event::EventId, objective::Objective, voting_status::VotingStatus};
use std::sync::Arc;

mod ballots;
mod proposal;
mod review_type;

pub fn objective(state: Arc<State>) -> Router {
    let proposal = proposal::proposal(state.clone());
    let review_type = review_type::review_type(state.clone());
    let ballots = ballots::ballots(state.clone());

    Router::new()
        .nest(
            "/objective/:objective",
            proposal.merge(review_type).merge(ballots),
        )
        .route("/objectives", {
            let state = state.clone();
            get(move |path, query| async {
                handle_result(objectives_exec(path, query, state).await)
            })
        })
        .route(
            "/objectives/voting_status",
            get(move |path, query| async {
                handle_result(objectives_voting_statuses_exec(path, query, state).await)
            }),
        )
}

async fn objectives_exec(
    Path(SerdeType(event)): Path<SerdeType<EventId>>,
    lim_ofs: Query<LimitOffset>,
    state: Arc<State>,
) -> Result<Vec<SerdeType<Objective>>, Error> {
    tracing::debug!("objectives_query, event: {0}", event.0);

    let objectives = state
        .event_db
        .get_objectives(event, lim_ofs.limit, lim_ofs.offset)
        .await?
        .into_iter()
        .map(SerdeType)
        .collect();
    Ok(objectives)
}

// TODO:
// mocked data, will be replaced when we will add this into event-db
fn mocked_voting_status_data() -> (bool, Option<String>) {
    use chrono::Local;
    use chrono::Timelike;

    let settings = serde_json::json!(
        {
            "purpose": 0,
            "ver": 0,
            "fees":
                {
                    "constant": 10,
                    "coefficient": 2,
                    "certificate": 100
                },
            "discrimination": "production",
            "block0_initial_hash":
                {
                    "hash": "baf6b54817cf2a3e865f432c3922d28ac5be641e66662c66d445f141e409183e"
                },
            "block0_date": 1586637936,
            "slot_duration": 20,
            "time_era":
                {
                    "epoch_start": 0,
                    "slot_start": 0,
                    "slots_per_epoch": 180
                },
            "transaction_max_expiry_epochs":1
        }
    );

    // Result based on the local time and it changes every 10 minutes
    if Local::now().minute() / 10 % 2 == 0 {
        (true, Some(settings.to_string()))
    } else {
        (false, None)
    }
}

async fn objectives_voting_statuses_exec(
    Path(SerdeType(event)): Path<SerdeType<EventId>>,
    lim_ofs: Query<LimitOffset>,
    state: Arc<State>,
) -> Result<Vec<SerdeType<VotingStatus>>, Error> {
    tracing::debug!("objectives_voting_statuses_query, event: {0}", event.0);

    let objectives = state
        .event_db
        .get_objectives(event, lim_ofs.limit, lim_ofs.offset)
        .await?;

    let data = mocked_voting_status_data();

    let voting_statuses: Vec<_> = objectives
        .into_iter()
        .map(|objective| {
            VotingStatus {
                objective_id: objective.summary.id,
                open: data.0,
                settings: data.1.clone(),
            }
            .into()
        })
        .collect();
    Ok(voting_statuses)
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
    async fn objectives_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri(format!("/api/v1/event/{0}/objectives", 1))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                [
                    {
                        "id": 1,
                        "type": {
                            "id": "catalyst-simple",
                            "description": "A Simple choice"
                        },
                        "title": "title 1",
                        "description": "description 1",
                        "deleted": false,
                        "groups": [
                            {
                                "group": "direct",
                                "voting_token": "voting token 1"
                            },
                            {
                                "group": "rep",
                                "voting_token": "voting token 2"
                            }
                        ],
                        "reward": {
                            "currency": "ADA",
                            "value": 100
                        },
                        "supplemental": {
                            "url":"objective 1 url",
                            "sponsor": "objective 1 sponsor",
                            "video": "objective 1 video"
                        }
                    },
                    {
                        "id": 2,
                        "type": {
                            "id": "catalyst-native",
                            "description": "??"
                        },
                        "title": "title 2",
                        "description": "description 2",
                        "deleted": false,
                        "groups": [],
                    }
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!("/api/v1/event/{0}/objectives?limit={1}", 1, 1))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                [
                    {
                        "id": 1,
                        "type": {
                            "id": "catalyst-simple",
                            "description": "A Simple choice"
                        },
                        "title": "title 1",
                        "description": "description 1",
                        "deleted": false,
                        "groups": [
                            {
                                "group": "direct",
                                "voting_token": "voting token 1"
                            },
                            {
                                "group": "rep",
                                "voting_token": "voting token 2"
                            }
                        ],
                        "reward": {
                            "currency": "ADA",
                            "value": 100
                        },
                        "supplemental": {
                            "url":"objective 1 url",
                            "sponsor": "objective 1 sponsor",
                            "video": "objective 1 video"
                        }
                    },
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!("/api/v1/event/{0}/objectives?offset={1}", 1, 1))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                [
                    {
                        "id": 2,
                        "type": {
                            "id": "catalyst-native",
                            "description": "??"
                        },
                        "title": "title 2",
                        "description": "description 2",
                        "deleted": false,
                        "groups": [],
                    }
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objectives?limit={1}&offset={2}",
                1, 1, 2
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([])
        );
    }

    #[tokio::test]
    async fn objectives_voting_status_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let data = mocked_voting_status_data();
        let request = Request::builder()
            .uri(format!("/api/v1/event/{0}/objectives/voting_status", 1))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            if let Some(settings) = data.1.clone() {
                serde_json::json!(
                    [
                        {
                            "objective_id": 1,
                            "open": data.0,
                            "settings": settings,
                        },
                        {
                            "objective_id": 2,
                            "open": data.0,
                            "settings": settings,
                        }
                    ]
                )
            } else {
                serde_json::json!(
                    [
                        {
                            "objective_id": 1,
                            "open": data.0,
                        },
                        {
                            "objective_id": 2,
                            "open": data.0,
                        }
                    ]
                )
            },
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objectives/voting_status?limit={1}",
                1, 1
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            if let Some(settings) = data.1.clone() {
                serde_json::json!(
                    [
                        {
                            "objective_id": 1,
                            "open": data.0,
                            "settings": settings,
                        }
                    ]
                )
            } else {
                serde_json::json!(
                    [
                        {
                            "objective_id": 1,
                            "open": data.0,
                        }
                    ]
                )
            },
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objectives/voting_status?offset={1}",
                1, 1
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            if let Some(settings) = data.1.clone() {
                serde_json::json!(
                    [
                        {
                            "objective_id": 2,
                            "open": data.0,
                            "settings": settings,
                        }
                    ]
                )
            } else {
                serde_json::json!(
                    [
                        {
                            "objective_id": 2,
                            "open": data.0,
                        }
                    ]
                )
            },
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objectives/voting_status?limit={1}&offset={2}",
                1, 1, 2
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([])
        );
    }
}
