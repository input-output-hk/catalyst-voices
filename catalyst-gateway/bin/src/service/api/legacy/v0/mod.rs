//! `v0` Endpoints
use poem_openapi::{param::Path, payload::Binary, OpenApi};

use crate::service::{
    common::tags::ApiTags, utilities::middleware::schema_validation::schema_version_validation,
};

mod fund_get;
mod message_post;
mod plans_get;
mod proposal_by_id_get;
mod proposals_get;
mod proposals_post;
mod review_by_proposal_id_get;
mod settings_get;

/// `v0` API Endpoints
pub(crate) struct V0Api;

#[OpenApi(prefix_path = "/v0", tag = "ApiTags::V0")]
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

    #[oai(
        path = "/settings",
        method = "get",
        operation_id = "GetSettings",
        deprecated = true
    )]
    async fn settings_get(&self) -> settings_get::AllResponses {
        settings_get::endpoint().await
    }

    #[oai(
        path = "/fund/",
        method = "get",
        operation_id = "GetFund",
        deprecated = true
    )]
    async fn fund_get(&self) -> fund_get::AllResponses {
        fund_get::endpoint().await
    }

    #[oai(
        path = "/proposals",
        method = "get",
        operation_id = "GetProposals",
        deprecated = true
    )]
    async fn proposals_get(&self) -> proposals_get::AllResponses {
        proposals_get::endpoint().await
    }

    #[oai(
        path = "/proposals",
        method = "post",
        operation_id = "CreateProposal",
        deprecated = true
    )]
    async fn proposals_post(&self, message: Binary<Vec<u8>>) -> proposals_post::AllResponses {
        proposals_post::endpoint(message.0).await
    }

    #[oai(
        path = "/proposals/:id",
        method = "get",
        operation_id = "GetProposalById",
        deprecated = true
    )]
    async fn proposal_by_id_get(&self, id: Path<String>) -> proposal_by_id_get::AllResponses {
        proposal_by_id_get::endpoint(id.0).await
    }

    #[oai(
        path = "/reviews/:proposal_id",
        method = "get",
        operation_id = "GetReviewByProposalId",
        deprecated = true
    )]
    async fn review_by_proposal_id_get(
        &self, proposal_id: Path<String>,
    ) -> review_by_proposal_id_get::AllResponses {
        review_by_proposal_id_get::endpoint(proposal_id.0).await
    }
}
