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
use event_db::types::{
    event::EventId, objective::ObjectiveId, proposal::ProposalId, review::AdvisorReview,
};
use std::sync::Arc;

pub fn review(state: Arc<State>) -> Router {
    Router::new().route(
        "/reviews",
        get(move |path, query| async { handle_result(reviews_exec(path, query, state).await) }),
    )
}

async fn reviews_exec(
    Path((SerdeType(event), SerdeType(objective), SerdeType(proposal))): Path<(
        SerdeType<EventId>,
        SerdeType<ObjectiveId>,
        SerdeType<ProposalId>,
    )>,
    lim_ofs: Query<LimitOffset>,
    state: Arc<State>,
) -> Result<Vec<SerdeType<AdvisorReview>>, Error> {
    tracing::debug!(
        "reviews_query, event:{0} objective: {1}, proposal: {2}",
        event.0,
        objective.0,
        proposal.0,
    );

    let reviews = state
        .event_db
        .get_reviews(event, objective, proposal, lim_ofs.limit, lim_ofs.offset)
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
    async fn reviews_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposal/{2}/reviews",
                1, 1, 10
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "assessor": "assessor 1",
                    "ratings": [
                        {
                            "review_type": 1,
                            "score": 10,
                            "note": "note 1"
                        },
                        {
                            "review_type": 2,
                            "score": 15,
                            "note": "note 2"
                        },
                        {
                            "review_type": 5,
                            "score": 20,
                            "note": "note 3"
                        }
                    ]
                },
                {
                    "assessor": "assessor 2",
                    "ratings": []
                },
                {
                    "assessor": "assessor 3",
                    "ratings": []
                }
            ]),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposal/{2}/reviews?limit={3}",
                1, 1, 10, 2
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "assessor": "assessor 1",
                    "ratings": [
                        {
                            "review_type": 1,
                            "score": 10,
                            "note": "note 1"
                        },
                        {
                            "review_type": 2,
                            "score": 15,
                            "note": "note 2"
                        },
                        {
                            "review_type": 5,
                            "score": 20,
                            "note": "note 3"
                        }
                    ]
                },
                {
                    "assessor": "assessor 2",
                    "ratings": []
                },
            ]),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposal/{2}/reviews?offset={3}",
                1, 1, 10, 1
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "assessor": "assessor 2",
                    "ratings": []
                },
                {
                    "assessor": "assessor 3",
                    "ratings": []
                }
            ]),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposal/{2}/reviews?limit={3}&offset={4}",
                1, 1, 10, 1, 1
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "assessor": "assessor 2",
                    "ratings": []
                },
            ]),
        );
    }
}
