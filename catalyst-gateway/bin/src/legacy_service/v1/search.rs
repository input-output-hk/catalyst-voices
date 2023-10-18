use crate::{
    legacy_service::{handle_result, types::SerdeType},
    service::Error,
    state::State,
};
use axum::{extract::Query, routing::post, Json, Router};
use event_db::types::search::{SearchQuery, SearchResult};
use serde::Deserialize;
use std::sync::Arc;

pub fn search(state: Arc<State>) -> Router {
    Router::new().route(
        "/search",
        post(move |query, body| async { handle_result(search_exec(query, body, state).await) }),
    )
}

/// Cannot use serde flattening, look this issue <https://github.com/nox/serde_urlencoded/issues/33>
#[derive(Deserialize)]
struct SearchParam {
    #[serde(default)]
    total: bool,
    limit: Option<i64>,
    offset: Option<i64>,
}

async fn search_exec(
    search_param: Query<SearchParam>,
    Json(SerdeType(search_query)): Json<SerdeType<SearchQuery>>,
    state: Arc<State>,
) -> Result<SerdeType<SearchResult>, Error> {
    tracing::debug!("search_query",);

    let res = state
        .event_db
        .search(
            search_query,
            search_param.total,
            search_param.limit,
            search_param.offset,
        )
        .await?
        .into();
    Ok(res)
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
        http::{header, Method, Request, StatusCode},
    };
    use tower::ServiceExt;

    #[tokio::test]
    async fn search_events_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "events",
                    "filter": [{
                        "column": "description",
                        "search": "Fund"
                    }],
                    "order_by": [{
                        "column": "description",
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!({
                "total": 6,
                "results": [
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
                        "final": true
                    },
                    {
                        "id": 2,
                        "name": "Test Fund 2",
                        "starts": "2021-05-01T12:00:00+00:00",
                        "ends": "2021-06-01T12:00:00+00:00",
                        "reg_checked": "2021-03-31T12:00:00+00:00",
                        "final": true
                    },
                    {
                        "id": 3,
                        "name": "Test Fund 3",
                        "starts": "2022-05-01T12:00:00+00:00",
                        "ends": "2022-06-01T12:00:00+00:00",
                        "reg_checked": "2022-03-31T12:00:00+00:00",
                        "final": true
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
            }),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search?total=true".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "events",
                    "filter": [{
                        "column": "description",
                        "search": "Fund"
                    }],
                    "order_by": [{
                        "column": "description",
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!({
                "total": 6,
            }),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "events",
                    "filter": [{
                        "column": "description",
                        "search": "Fund"
                    }],
                    "order_by": [{
                        "column": "description",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!({
                "total": 6,
                "results": [
                    {
                        "id": 5,
                        "name": "Test Fund 5",
                        "final": false
                    },
                    {
                        "id": 4,
                        "name": "Test Fund 4",
                        "starts": "2022-05-01T12:00:00+00:00",
                        "ends": "2024-06-01T12:00:00+00:00",
                        "final": false
                    },
                    {
                        "id": 3,
                        "name": "Test Fund 3",
                        "starts": "2022-05-01T12:00:00+00:00",
                        "ends": "2022-06-01T12:00:00+00:00",
                        "reg_checked": "2022-03-31T12:00:00+00:00",
                        "final": true
                    },
                    {
                        "id": 2,
                        "name": "Test Fund 2",
                        "starts": "2021-05-01T12:00:00+00:00",
                        "ends": "2021-06-01T12:00:00+00:00",
                        "reg_checked": "2021-03-31T12:00:00+00:00",
                        "final": true
                    },
                    {
                        "id": 1,
                        "name": "Test Fund 1",
                        "starts": "2020-05-01T12:00:00+00:00",
                        "ends": "2020-06-01T12:00:00+00:00",
                        "reg_checked": "2020-03-31T12:00:00+00:00",
                        "final": true
                    },
                    {
                        "id": 0,
                        "name": "Test Fund",
                        "starts": "1970-01-01T00:00:00+00:00",
                        "ends": "1970-01-01T00:00:00+00:00",
                        "final": true
                    }
                ]
            }),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri(format!("/api/v1/search?limit={0}", 2))
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "events",
                    "filter": [{
                        "column": "description",
                        "search": "Fund"
                    }],
                    "order_by": [{
                        "column": "description",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 2,
                    "results": [
                        {
                            "id": 5,
                            "name": "Test Fund 5",
                            "final": false
                        },
                        {
                            "id": 4,
                            "name": "Test Fund 4",
                            "starts": "2022-05-01T12:00:00+00:00",
                            "ends": "2024-06-01T12:00:00+00:00",
                            "final": false
                        },
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri(format!("/api/v1/search?offset={0}", 2))
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "events",
                    "filter": [{
                        "column": "description",
                        "search": "Fund"
                    }],
                    "order_by": [{
                        "column": "description",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 4,
                    "results": [
                        {
                            "id": 3,
                            "name": "Test Fund 3",
                            "starts": "2022-05-01T12:00:00+00:00",
                            "ends": "2022-06-01T12:00:00+00:00",
                            "reg_checked": "2022-03-31T12:00:00+00:00",
                            "final": true
                        },
                        {
                            "id": 2,
                            "name": "Test Fund 2",
                            "starts": "2021-05-01T12:00:00+00:00",
                            "ends": "2021-06-01T12:00:00+00:00",
                            "reg_checked": "2021-03-31T12:00:00+00:00",
                            "final": true
                        },
                        {
                            "id": 1,
                            "name": "Test Fund 1",
                            "starts": "2020-05-01T12:00:00+00:00",
                            "ends": "2020-06-01T12:00:00+00:00",
                            "reg_checked": "2020-03-31T12:00:00+00:00",
                            "final": true
                        },
                        {
                            "id": 0,
                            "name": "Test Fund",
                            "starts": "1970-01-01T00:00:00+00:00",
                            "ends": "1970-01-01T00:00:00+00:00",
                            "final": true
                        },
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri(format!("/api/v1/search?limit={0}&offset={1}", 1, 1))
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "events",
                    "filter": [{
                        "column": "description",
                        "search": "Fund"
                    }],
                    "order_by": [{
                        "column": "description",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 1,
                    "results": [
                        {
                            "id": 4,
                            "name": "Test Fund 4",
                            "starts": "2022-05-01T12:00:00+00:00",
                            "ends": "2024-06-01T12:00:00+00:00",
                            "final": false
                        },
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "events",
                    "filter": [{
                        "column": "funds",
                        "search": "Fund 4"
                    }],
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::NOT_FOUND);
    }

    #[tokio::test]
    async fn search_objectives_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "objectives",
                    "filter": [{
                        "column": "description",
                        "search": "description"
                    }],
                    "order_by": [{
                        "column": "description",
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 4,
                    "results": [
                        {
                            "id": 1,
                            "type": {
                                "id": "catalyst-simple",
                                "description": "A Simple choice"
                            },
                            "title": "title 1",
                            "description": "description 1",
                            "deleted": false,
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
                        },
                        {
                            "id": 3,
                            "type": {
                                "id": "catalyst-simple",
                                "description": "A Simple choice"
                            },
                            "title": "title 3",
                            "description": "description 3",
                            "deleted": false,
                        },
                        {
                            "id": 4,
                            "type": {
                                "id": "catalyst-native",
                                "description": "??"
                            },
                            "title": "title 4",
                            "description": "description 4",
                            "deleted": false,
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search?total=true".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "objectives",
                    "filter": [{
                        "column": "description",
                        "search": "description"
                    }],
                    "order_by": [{
                        "column": "description",
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 4,
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "objectives",
                    "filter": [{
                        "column": "description",
                        "search": "description"
                    }],
                    "order_by": [{
                        "column": "description",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 4,
                    "results": [
                        {
                            "id": 4,
                            "type": {
                                "id": "catalyst-native",
                                "description": "??"
                            },
                            "title": "title 4",
                            "description": "description 4",
                            "deleted": false,
                        },
                        {
                            "id": 3,
                            "type": {
                                "id": "catalyst-simple",
                                "description": "A Simple choice"
                            },
                            "title": "title 3",
                            "description": "description 3",
                            "deleted": false,
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
                        },
                        {
                            "id": 1,
                            "type": {
                                "id": "catalyst-simple",
                                "description": "A Simple choice"
                            },
                            "title": "title 1",
                            "description": "description 1",
                            "deleted": false,
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri(format!("/api/v1/search?limit={0}", 1))
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "objectives",
                    "filter": [{
                        "column": "description",
                        "search": "description"
                    }],
                    "order_by": [{
                        "column": "description",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 1,
                    "results": [
                        {
                            "id": 4,
                            "type": {
                                "id": "catalyst-native",
                                "description": "??"
                            },
                            "title": "title 4",
                            "description": "description 4",
                            "deleted": false,
                        },
                    ]

                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri(format!("/api/v1/search?offset={0}", 1))
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "objectives",
                    "filter": [{
                        "column": "description",
                        "search": "description"
                    }],
                    "order_by": [{
                        "column": "description",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 3,
                    "results": [
                        {
                            "id": 3,
                            "type": {
                                "id": "catalyst-simple",
                                "description": "A Simple choice"
                            },
                            "title": "title 3",
                            "description": "description 3",
                            "deleted": false,
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
                        },
                        {
                            "id": 1,
                            "type": {
                                "id": "catalyst-simple",
                                "description": "A Simple choice"
                            },
                            "title": "title 1",
                            "description": "description 1",
                            "deleted": false,
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "objectives",
                    "filter": [{
                        "column": "funds",
                        "search": "description 1"
                    }],
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::NOT_FOUND);
    }

    #[tokio::test]
    async fn search_proposals_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "proposals",
                    "filter": [{
                        "column": "title",
                        "search": "title"
                    }],
                    "order_by": [{
                        "column": "title",
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 3,
                    "results": [
                        {
                            "id": 10,
                            "title": "title 1",
                            "summary": "summary 1",
                            "deleted": false,
                        },
                        {
                            "id": 20,
                            "title": "title 2",
                            "summary": "summary 2",
                            "deleted": false,
                        },
                        {
                            "id": 30,
                            "title": "title 3",
                            "summary": "summary 3",
                            "deleted": false,
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search?total=true".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "proposals",
                    "filter": [{
                        "column": "title",
                        "search": "title"
                    }],
                    "order_by": [{
                        "column": "title",
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 3,
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "proposals",
                    "filter": [{
                        "column": "title",
                        "search": "title"
                    }],
                    "order_by": [{
                        "column": "title",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 3,
                    "results": [
                        {
                            "id": 30,
                            "title": "title 3",
                            "summary": "summary 3",
                            "deleted": false
                        },
                        {
                            "id": 20,
                            "title": "title 2",
                            "summary": "summary 2",
                            "deleted": false
                        },
                        {
                            "id": 10,
                            "title": "title 1",
                            "summary": "summary 1",
                            "deleted": false
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri(format!("/api/v1/search?limit={0}", 2))
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "proposals",
                    "filter": [{
                        "column": "title",
                        "search": "title"
                    }],
                    "order_by": [{
                        "column": "title",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 2,
                    "results": [
                        {
                            "id": 30,
                            "title": "title 3",
                            "summary": "summary 3",
                            "deleted": false
                        },
                        {
                            "id": 20,
                            "title": "title 2",
                            "summary": "summary 2",
                            "deleted": false
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri(format!("/api/v1/search?offset={0}", 1))
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "proposals",
                    "filter": [{
                        "column": "title",
                        "search": "title"
                    }],
                    "order_by": [{
                        "column": "title",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 2,
                    "results": [
                        {
                            "id": 20,
                            "title": "title 2",
                            "summary": "summary 2",
                            "deleted": false
                        },
                        {
                            "id": 10,
                            "title": "title 1",
                            "summary": "summary 1",
                            "deleted": false
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri(format!("/api/v1/search?limit={0}&offset={1}", 1, 1))
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "proposals",
                    "filter": [{
                        "column": "title",
                        "search": "title"
                    }],
                    "order_by": [{
                        "column": "title",
                        "descending": true,
                    }]
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            response_body_to_json(response).await.unwrap(),
            serde_json::json!(
                {
                    "total": 1,
                    "results": [
                        {
                            "id": 20,
                            "title": "title 2",
                            "summary": "summary 2",
                            "deleted": false
                        }
                    ]
                }
            ),
        );

        let request = Request::builder()
            .method(Method::POST)
            .uri("/api/v1/search".to_string())
            .header(header::CONTENT_TYPE, "application/json")
            .body(Body::from(
                serde_json::json!({
                    "table": "proposals",
                    "filter": [{
                        "column": "description",
                        "search": "description 1"
                    }],
                })
                .to_string(),
            ))
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::NOT_FOUND);
    }
}
