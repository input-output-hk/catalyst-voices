//! `v0` Endpoints
use poem_openapi::{payload::Binary, OpenApi};

use crate::service::{
    common::tags::ApiTags, utilities::middleware::schema_validation::schema_version_validation,
};
mod message_post;
mod plans_get;

/// `v0` API Endpoints
pub(crate) struct V0Api;

#[OpenApi(prefix_path = "/v0", tag = "ApiTags::Legacy")]
impl V0Api {
    /// Posts a signed transaction.
    ///
    /// Post a signed transaction in a form of message to the network.
    #[oai(
        path = "/message",
        method = "post",
        operation_id = "Message",
        deprecated = true
    )]
    async fn message_post(&self, message: Binary<Vec<u8>>) -> message_post::AllResponses {
        message_post::endpoint(message).await
    }

    /// Get all active vote plans endpoint.
    ///
    /// Get all active vote plans endpoint.
    #[oai(
        path = "/vote/active/plans",
        method = "get",
        operation_id = "GetActivePlans",
        transform = "schema_version_validation",
        deprecated = true
    )]
    async fn plans_get(&self) -> plans_get::AllResponses {
        plans_get::endpoint().await
    }
}
