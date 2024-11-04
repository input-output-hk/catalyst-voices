//! `v0` Endpoints
use poem_openapi::{
    payload::{Binary, Json},
    OpenApi,
};

use crate::service::{
    common::{objects::legacy::{challenges::Challenge, search::SearchQuery}, tags::ApiTags},
    utilities::middleware::schema_validation::schema_version_validation,
};
mod challenges;
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

    /// Search various resources with various constraints.
    ///
    /// Search various resources especially challenges and proposals with various constraints like contains some string etc.
    #[oai(
        path = "/search",
        method = "post",
        operation_id = "PostSearch",
        deprecated = true
    )]
    async fn search_post(&self, body: Json<SearchQuery>) -> search::SearchAllResponses {
        search::search_post(body).await
    }

    /// Returns count of the result set of search operation.
    ///
    /// Search various resources with various constraints and returns count of the result set.
    #[oai(
        path = "/search_count",
        method = "post",
        operation_id = "PostSearchCount",
        deprecated = true
    )]
    async fn search_count_post(&self, body: Json<i32>) -> search::SearchCountAllResponses {
        search::search_count_post(body).await
    }

    /// Get all available challenges
    ///
    /// Lists all available challenges following insertion order.
    #[oai(
        path = "/challenges",
        method = "get",
        operation_id = "GetAllChallenges",
        deprecated = true
    )]
    async fn challenges_get(&self, body: Json<Challenge>) -> challenges::SearchAllResponses {
            challenges::challenges_get(body).await
        }

    // // Get /api/v0/challenges/{challenge_id}
    /// Get challenge by id.
    /// 
    /// Retrieves information on the identified challenge,
    /// including the proposals submitted for it.
    #[oai(
        path = "/challenges/{id}",
        method = "get",
        operation_id = "GetChallengeById",
        deprecated = true
    )]
    async fn challenges_id_get(&self) -> challenges::SearchAllResponses {
        challenges::challenges_id_get(0).await
    }
    // // Get /api/v0/node/stats
    // #[oai(
    //     path = "/node/stats",
    //     method = "get",
    //     operation_id = "NodeStats",
    //     deprecated = true
    // )]
    // // Get /api/v0/account/{account_id}
    // #[oai(
    //     path = "/account/{account_id}",
    //     method = "get",
    //     operation_id = "GetAccountId",
    //     deprecated = true
    // )]
}
