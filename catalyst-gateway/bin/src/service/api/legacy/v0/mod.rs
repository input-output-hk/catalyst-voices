//! `v0` Endpoints
use poem_openapi::{payload::Binary, OpenApi};

use crate::service::{
    common::tags::ApiTags, utilities::middleware::schema_validation::schema_version_validation,
};
mod message_post;
mod plans_get;
mod search;

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

    /// Search various resources with various constraints
    /// 
    /// Search various resources especially challenges and proposals with various constraints like contains some string etc.
    #[oai(
        path = "/search",
        method = "post",
        operation_id = "PostSearch",
        deprecated = true
    )]
    async fn search_post(&self) -> search::AllResponses {
        search::endpoint().await
    }

    // POST /api/v0/search_count
    #[oai(
        path = "/search_count",
        method = "post",
        operation_id = "PostSearchCount",
        deprecated = true
    )]
    // Get /api/v0/challenges/
    #[oai(
        path = "/challenges",
        method = "get",
        operation_id = "GetChallenges",
        deprecated = true
    )]
    // Get /api/v0/challenges/{challenge_id}
    #[oai(
        path = "/challenges/{challenge_id}",
        method = "get",
        operation_id = "GetChallengeId",
        deprecated = true
    )]
    // Get /api/v0/node/stats
    #[oai(
        path = "/node/stats",
        method = "get",
        operation_id = "NodeStats",
        deprecated = true
    )]
    // Get /api/v0/account/{account_id} 
    #[oai(
        path = "/account/{account_id}",
        method = "get",
        operation_id = "GetAccountId",
        deprecated = true
    )]
}
