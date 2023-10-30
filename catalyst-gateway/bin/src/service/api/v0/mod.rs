//! `v0` Endpoints
//!
use crate::service::common::tags::ApiTags;
use poem_openapi::{payload::Binary, OpenApi};

mod message_post;

/// `v0` API Endpoints
pub(crate) struct V0Api;

#[OpenApi(prefix_path = "/v0")]
impl V0Api {
    #[oai(
        path = "/message",
        method = "post",
        operation_id = "Message",
        tag = "ApiTags::Message"
    )]
    /// Posts a signed transaction.
    async fn message_post(&self, message: Binary<Vec<u8>>) -> message_post::AllResponses {
        message_post::endpoint(message).await
    }
}

/// Need to setup and run a test event db instance
/// To do it you can use the following commands:
/// Prepare docker images
/// ```
/// TODO
/// ```
/// Run event-db container
/// ```
/// TODO
/// ```
/// Also need establish `EVENT_DB_URL` env variable with the following value
/// ```
/// EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
/// ```
/// [readme](https://github.com/input-output-hk/catalyst-voices/blob/main/catalyst-gateway/event-db/Readme.md)

#[cfg(test)]
mod tests {
    use crate::{service::poem_service::tests::mk_test_app, state::State};
    use poem::http::StatusCode;
    use std::sync::Arc;

    #[tokio::test]
    async fn v0_test() {
        let state = Arc::new(State::new(None).await.unwrap());
        let app = mk_test_app(&state);

        let resp = app
            .post("/api/v0/message")
            .body("00000000000".to_string())
            .send()
            .await;
        resp.assert_status(StatusCode::BAD_REQUEST);
    }
}
