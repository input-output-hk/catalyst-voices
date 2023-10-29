//! Message Endpoints
//!
use crate::service::common::tags::ApiTags;
use poem_openapi::{payload::Binary, OpenApi};

mod message_post;

/// Message API Endpoints
pub(crate) struct MessageApi;

#[OpenApi(prefix_path = "/message", tag = "ApiTags::Message")]
impl MessageApi {
    #[oai(path = "/", method = "post", operation_id = "Message")]
    /// Posts a signed transaction.
    async fn message_post(&self, message: Binary<Vec<u8>>) -> message_post::AllResponses {
        message_post::endpoint(message).await
    }
}
