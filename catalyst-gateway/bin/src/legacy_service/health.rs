use axum::{routing::get, Router};

use super::handle_result;
use crate::service::Error;

pub(crate) fn health() -> Router {
    Router::new()
        .route(
            "/health/ready",
            get(|| async { handle_result(ready_exec()) }),
        )
        .route("/health/live", get(|| async { handle_result(live_exec()) }))
}

#[allow(clippy::unnecessary_wraps)]
fn ready_exec() -> Result<bool, Error> {
    tracing::debug!("health ready exec");

    Ok(true)
}

#[allow(clippy::unnecessary_wraps)]
fn live_exec() -> Result<bool, Error> {
    tracing::debug!("health live exec");

    Ok(true)
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
/// EVENT_DB_URL = "postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
/// ```
/// [readme](https://github.com/input-output-hk/catalyst-core/tree/main/src/event-db/Readme.md)
#[cfg(test)]
mod tests {
    use std::sync::Arc;

    use axum::{
        body::{Body, HttpBody},
        http::{Request, StatusCode},
    };
    use tower::ServiceExt;

    use crate::{legacy_service::app, state::State};

    #[tokio::test]
    async fn health_ready_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri("/health/ready".to_string())
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            String::from_utf8(response.into_body().data().await.unwrap().unwrap().to_vec())
                .unwrap()
                .as_str(),
            r#"true"#
        );
    }

    #[tokio::test]
    async fn health_live_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = app(state);

        let request = Request::builder()
            .uri("/health/live".to_string())
            .body(Body::empty())
            .unwrap();
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert_eq!(
            String::from_utf8(response.into_body().data().await.unwrap().unwrap().to_vec())
                .unwrap()
                .as_str(),
            r#"true"#
        );
    }
}
