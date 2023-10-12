use super::LimitOffset;
use crate::{
    legacy_service::{handle_result, types::SerdeType},
    service::Error,
    state::State,
};
use axum::{
    extract::{Path, Query},
    routing::get,
    Router,
};
use event_db::types::event::{Event, EventId, EventSummary};
use std::sync::Arc;

mod ballots;
mod objective;

pub fn event(state: Arc<State>) -> Router {
    let objective = objective::objective(state.clone());
    let ballots = ballots::ballots(state.clone());

    Router::new()
        .nest(
            "/event/:event",
            Router::new()
                .route(
                    "/",
                    get({
                        let state = state.clone();
                        move |path| async { handle_result(event_exec(path, state).await) }
                    }),
                )
                .merge(objective)
                .merge(ballots),
        )
        .route(
            "/events",
            get(move |query| async { handle_result(events_exec(query, state).await) }),
        )
}

async fn event_exec(
    Path(SerdeType(event)): Path<SerdeType<EventId>>,
    state: Arc<State>,
) -> Result<SerdeType<Event>, Error> {
    tracing::debug!("event_exec, event: {0}", event.0);

    let event = state.event_db.get_event(event).await?.into();
    Ok(event)
}

async fn events_exec(
    lim_ofs: Query<LimitOffset>,
    state: Arc<State>,
) -> Result<Vec<SerdeType<EventSummary>>, Error> {
    tracing::debug!(
        "events_query, limit: {0:?}, offset: {1:?}",
        lim_ofs.limit,
        lim_ofs.offset
    );

    let events = state
        .event_db
        .get_events(lim_ofs.limit, lim_ofs.offset)
        .await?
        .into_iter()
        .map(SerdeType)
        .collect::<Vec<_>>();
    Ok(events)
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
    async fn event_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri(format!("/api/v1/event/{0}", 1))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "id": 1,
                    "name": "Test Fund 1",
                    "starts": "2020-05-01T12:00:00+00:00",
                    "ends": "2020-06-01T12:00:00+00:00",
                    "reg_checked": "2020-03-31T12:00:00+00:00",
                    "final": true,
                    "voting_power": {
                        "alg": "threshold_staked_ADA",
                        "min_ada": 1,
                        "max_pct": 100.0
                    },
                    "registration": {
                        "deadline": "2020-03-31T12:00:00+00:00",
                        "taken": "2020-03-31T12:00:00+00:00",
                    },
                    "schedule": {
                        "insight_sharing": "2020-03-01T12:00:00+00:00",
                        "proposal_submission": "2020-03-01T12:00:00+00:00",
                        "refine_proposals": "2020-03-01T12:00:00+00:00",
                        "finalize_proposals": "2020-03-01T12:00:00+00:00",
                        "proposal_assessment": "2020-03-01T12:00:00+00:00",
                        "assessment_qa_start": "2020-03-01T12:00:00+00:00",
                        "voting": "2020-05-01T12:00:00+00:00",
                        "tallying": "2020-06-01T12:00:00+00:00",
                        "tallying_end": "2020-07-01T12:00:00+00:00",
                    },
                    "goals": [
                        {
                            "idx": 1,
                            "name": "goal 1"
                        },
                        {
                            "idx": 2,
                            "name": "goal 2"
                        },
                        {
                            "idx": 3,
                            "name": "goal 3"
                        },
                        {
                            "idx": 4,
                            "name": "goal 4"
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .uri(format!("/api/v1/event/{0}", 100))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::NOT_FOUND);
    }

    #[tokio::test]
    async fn events_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri("/api/v1/events".to_string())
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                [
                    {
                        "id": 0,
                        "name": "Test Fund",
                        "starts": "1970-01-01T00:00:00+00:00",
                        "ends": "1970-01-01T00:00:00+00:00",
                        "final": true
                    },
                    {
                        "id": 1,
                        "name": "Test Fund 1",
                        "starts": "2020-05-01T12:00:00+00:00",
                        "ends": "2020-06-01T12:00:00+00:00",
                        "reg_checked": "2020-03-31T12:00:00+00:00",
                        "final": true,
                    },
                    {
                        "id": 2,
                        "name": "Test Fund 2",
                        "starts": "2021-05-01T12:00:00+00:00",
                        "ends": "2021-06-01T12:00:00+00:00",
                        "reg_checked": "2021-03-31T12:00:00+00:00",
                        "final": true,
                    },
                    {
                        "id": 3,
                        "name": "Test Fund 3",
                        "starts": "2022-05-01T12:00:00+00:00",
                        "ends": "2022-06-01T12:00:00+00:00",
                        "reg_checked": "2022-03-31T12:00:00+00:00",
                        "final": true,
                    },
                    {
                        "id": 4,
                        "name": "Test Fund 4",
                        "starts": "2022-05-01T12:00:00+00:00",
                        "ends": "2024-06-01T12:00:00+00:00",
                        "final": false
                    },
                    {
                        "id": 5,
                        "name": "Test Fund 5",
                        "final": false
                    }
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!("/api/v1/events?offset={0}", 1))
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
                        "name": "Test Fund 1",
                        "starts": "2020-05-01T12:00:00+00:00",
                        "ends": "2020-06-01T12:00:00+00:00",
                        "reg_checked": "2020-03-31T12:00:00+00:00",
                        "final": true,
                    },
                    {
                        "id": 2,
                        "name": "Test Fund 2",
                        "starts": "2021-05-01T12:00:00+00:00",
                        "ends": "2021-06-01T12:00:00+00:00",
                        "reg_checked": "2021-03-31T12:00:00+00:00",
                        "final": true,
                    },
                    {
                        "id": 3,
                        "name": "Test Fund 3",
                        "starts": "2022-05-01T12:00:00+00:00",
                        "ends": "2022-06-01T12:00:00+00:00",
                        "reg_checked": "2022-03-31T12:00:00+00:00",
                        "final": true,
                    },
                    {
                        "id": 4,
                        "name": "Test Fund 4",
                        "starts": "2022-05-01T12:00:00+00:00",
                        "ends": "2024-06-01T12:00:00+00:00",
                        "final": false
                    },
                    {
                        "id": 5,
                        "name": "Test Fund 5",
                        "final": false
                    }
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!("/api/v1/events?limit={0}", 1))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                [
                    {
                        "id": 0,
                        "name": "Test Fund",
                        "starts": "1970-01-01T00:00:00+00:00",
                        "ends": "1970-01-01T00:00:00+00:00",
                        "final": true
                    }
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!("/api/v1/events?limit={0}&offset={1}", 1, 1))
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
                        "name": "Test Fund 1",
                        "starts": "2020-05-01T12:00:00+00:00",
                        "ends": "2020-06-01T12:00:00+00:00",
                        "reg_checked": "2020-03-31T12:00:00+00:00",
                        "final": true,
                    }
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!("/api/v1/events?offset={0}", 10))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([])
        );
    }
}
