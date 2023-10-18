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
use event_db::types::{event::EventId, objective::ObjectiveId, review::ReviewType};
use std::sync::Arc;

pub fn review_type(state: Arc<State>) -> Router {
    Router::new().route(
        "/review_types",
        get(move |path, query| async {
            handle_result(review_types_exec(path, query, state).await)
        }),
    )
}

async fn review_types_exec(
    Path((SerdeType(event), SerdeType(objective))): Path<(
        SerdeType<EventId>,
        SerdeType<ObjectiveId>,
    )>,
    lim_ofs: Query<LimitOffset>,
    state: Arc<State>,
) -> Result<Vec<SerdeType<ReviewType>>, Error> {
    tracing::debug!(
        "review_types_query, event:{0} objective: {1}",
        event.0,
        objective.0,
    );

    let reviews = state
        .event_db
        .get_review_types(event, objective, lim_ofs.limit, lim_ofs.offset)
        .await?
        .into_iter()
        .map(SerdeType)
        .collect();
    Ok(reviews)
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
    async fn review_types_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/review_types",
                1, 1
            ))
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
                        "name": "impact",
                        "description": "Impact Rating",
                        "min": 0,
                        "max": 5,
                        "map": [],
                        "group": "review_group 1",
                    },
                    {
                        "id": 2,
                        "name": "feasibility",
                        "description": "Feasibility Rating",
                        "min": 0,
                        "max": 5,
                        "map": [],
                        "note": true,
                        "group": "review_group 2"
                    },
                    {
                        "id": 5,
                        "name": "vpa_ranking",
                        "description": "VPA Ranking of the review",
                        "min": 0,
                        "max": 3,
                        "map": [
                            {"name": "Excellent", "desc": "Excellent Review"},
                            {"name": "Good", "desc": "Could be improved."},
                            {"name": "FilteredOut", "desc": "Exclude this review"},
                            {"name": "NA", "desc": "Not Applicable"}
                        ],
                        "note": false,
                    }
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/review_types?limit={2}",
                1, 1, 2
            ))
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
                        "name": "impact",
                        "description": "Impact Rating",
                        "min": 0,
                        "max": 5,
                        "map": [],
                        "group": "review_group 1",
                    },
                    {
                        "id": 2,
                        "name": "feasibility",
                        "description": "Feasibility Rating",
                        "min": 0,
                        "max": 5,
                        "map": [],
                        "note": true,
                        "group": "review_group 2"
                    },
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/review_types?offset={2}",
                1, 1, 1
            ))
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
                        "name": "feasibility",
                        "description": "Feasibility Rating",
                        "min": 0,
                        "max": 5,
                        "map": [],
                        "note": true,
                        "group": "review_group 2"
                    },
                    {
                        "id": 5,
                        "name": "vpa_ranking",
                        "description": "VPA Ranking of the review",
                        "min": 0,
                        "max": 3,
                        "map": [
                            {"name": "Excellent", "desc": "Excellent Review"},
                            {"name": "Good", "desc": "Could be improved."},
                            {"name": "FilteredOut", "desc": "Exclude this review"},
                            {"name": "NA", "desc": "Not Applicable"}
                        ],
                        "note": false,
                    }
                ]
            ),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/review_types?limit={2}&offset={3}",
                1, 1, 1, 1
            ))
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
                        "name": "feasibility",
                        "description": "Feasibility Rating",
                        "min": 0,
                        "max": 5,
                        "map": [],
                        "note": true,
                        "group": "review_group 2"
                    },
                ]
            ),
        );
    }
}
