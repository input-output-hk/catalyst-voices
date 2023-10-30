//! Message Endpoints
//!
use crate::service::common::tags::ApiTags;
use poem_openapi::{payload::Binary, OpenApi};

mod message_post;

/// Message API Endpoints
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
