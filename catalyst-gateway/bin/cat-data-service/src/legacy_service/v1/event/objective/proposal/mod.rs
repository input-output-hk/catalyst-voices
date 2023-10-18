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
    event::EventId,
    objective::ObjectiveId,
    proposal::{Proposal, ProposalId, ProposalSummary},
};
use std::sync::Arc;

mod ballot;
mod review;

pub fn proposal(state: Arc<State>) -> Router {
    let review = review::review(state.clone());
    let ballot = ballot::ballot(state.clone());

    Router::new()
        .nest(
            "/proposal/:proposal",
            Router::new()
                .route(
                    "/",
                    get({
                        let state = state.clone();
                        move |path| async { handle_result(proposal_exec(path, state).await) }
                    }),
                )
                .merge(review)
                .merge(ballot),
        )
        .route(
            "/proposals",
            get(move |path, query| async {
                handle_result(proposals_exec(path, query, state).await)
            }),
        )
}

async fn proposals_exec(
    Path((SerdeType(event), SerdeType(objective))): Path<(
        SerdeType<EventId>,
        SerdeType<ObjectiveId>,
    )>,
    lim_ofs: Query<LimitOffset>,
    state: Arc<State>,
) -> Result<Vec<SerdeType<ProposalSummary>>, Error> {
    tracing::debug!(
        "proposals_query, event:{0} objective: {1}",
        event.0,
        objective.0
    );

    let proposals = state
        .event_db
        .get_proposals(event, objective, lim_ofs.limit, lim_ofs.offset)
        .await?
        .into_iter()
        .map(SerdeType)
        .collect();
    Ok(proposals)
}

async fn proposal_exec(
    Path((SerdeType(event), SerdeType(objective), SerdeType(proposal))): Path<(
        SerdeType<EventId>,
        SerdeType<ObjectiveId>,
        SerdeType<ProposalId>,
    )>,
    state: Arc<State>,
) -> Result<SerdeType<Proposal>, Error> {
    tracing::debug!(
        "proposal_query, event:{0} objective: {1}, proposal: {2}",
        event.0,
        objective.0,
        proposal.0,
    );

    let proposal = state
        .event_db
        .get_proposal(event, objective, proposal)
        .await?
        .into();
    Ok(proposal)
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
    async fn proposal_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposal/{2}",
                1, 1, 10
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "id": 10,
                    "title": "title 1",
                    "summary": "summary 1",
                    "deleted": false,
                    "funds": 100,
                    "url": "url.xyz",
                    "files": "files.xyz",
                    "proposer": [
                        {
                            "name": "alice",
                            "email": "alice@io",
                            "url": "alice.prop.xyz",
                            "payment_key": "b7a3c12dc0c8c748ab07525b701122b88bd78f600c76342d27f25e5f92444cde"
                        }
                    ],
                    "supplemental": {
                        "brief": "Brief explanation of a proposal",
                        "goal": "The goal of the proposal is addressed to meet",
                        "importance": "The importance of the proposal",
                    }
                }
            ),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposal/{2}",
                3, 3, 3
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::NOT_FOUND);
    }

    #[tokio::test]
    async fn proposals_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri(format!("/api/v1/event/{0}/objective/{1}/proposals", 1, 1))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "id": 10,
                    "title": "title 1",
                    "summary": "summary 1",
                    "deleted": false
                },
                {
                    "id": 20,
                    "title": "title 2",
                    "summary": "summary 2",
                    "deleted": false
                },
                {
                    "id": 30,
                    "title": "title 3",
                    "summary": "summary 3",
                    "deleted": false
                }
            ]),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposals?limit={2}",
                1, 1, 2
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "id": 10,
                    "title": "title 1",
                    "summary": "summary 1",
                    "deleted": false
                },
                {
                    "id": 20,
                    "title": "title 2",
                    "summary": "summary 2",
                    "deleted": false
                },
            ]),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposals?offset={2}",
                1, 1, 1
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "id": 20,
                    "title": "title 2",
                    "summary": "summary 2",
                    "deleted": false
                },
                {
                    "id": 30,
                    "title": "title 3",
                    "summary": "summary 3",
                    "deleted": false
                }
            ]),
        );

        let request = Request::builder()
            .uri(format!(
                "/api/v1/event/{0}/objective/{1}/proposals?offset={2}&limit={3}",
                1, 1, 1, 1
            ))
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!([
                {
                    "id": 20,
                    "title": "title 2",
                    "summary": "summary 2",
                    "deleted": false
                },
            ]),
        );
    }
}
