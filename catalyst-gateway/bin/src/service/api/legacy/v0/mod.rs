//! `v0` Endpoints
use poem_openapi::{
    param::Path,
    payload::{Binary, Json},
    OpenApi,
};

use crate::service::{
    common::{auth::none::NoAuthorization, tags::ApiTags},
    utilities::middleware::schema_validation::schema_version_validation,
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
    async fn message_post(
        &self, message: Binary<Vec<u8>>, _auth: NoAuthorization,
    ) -> message_post::AllResponses {
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
    async fn plans_get(&self, _auth: NoAuthorization) -> plans_get::AllResponses {
        plans_get::endpoint().await
    }

    /// Get settings.
    ///
    /// Get settings information including fees detail.
    #[oai(
        path = "/settings",
        method = "get",
        operation_id = "GetSettings",
        deprecated = true
    )]
    async fn settings_get(&self, _auth: NoAuthorization) -> settings_get::AllResponses {
        settings_get::endpoint().await
    }

    /// Get fund.
    ///
    /// Get fund information.
    #[oai(
        path = "/fund/",
        method = "get",
        operation_id = "GetFund",
        deprecated = true
    )]
    async fn fund_get(&self, _auth: NoAuthorization) -> fund_get::AllResponses {
        fund_get::endpoint().await
    }

    /// Get list of proposals.
    ///
    /// Get list of proposals and the proposal's detail.
    #[oai(
        path = "/proposals",
        method = "get",
        operation_id = "GetProposals",
        deprecated = true
    )]
    async fn proposals_get(&self, _auth: NoAuthorization) -> proposals_get::AllResponses {
        proposals_get::endpoint().await
    }

    /// Get list of proposals.
    ///
    /// Get list of proposals according to the filter options.
    /// This is a POST method, only to send the filter data over the HTTP body.
    #[oai(
        path = "/proposals",
        method = "post",
        operation_id = "GetProposalsByFilter",
        deprecated = true
    )]
    async fn proposals_post(
        &self, message: Json<Vec<proposals_post::dto::VotingHistoryItem>>, _auth: NoAuthorization,
    ) -> proposals_post::AllResponses {
        proposals_post::endpoint(message.0).await
    }

    /// Get a proposal.
    ///
    /// Get a proposal filtering by its identifier.
    #[oai(
        path = "/proposals/:id",
        method = "get",
        operation_id = "ShowProposalById",
        deprecated = true
    )]
    async fn proposal_by_id_get(
        &self,
        /// The proposal identifier to be retrieved.
        #[oai(validator(max_length = 256, min_length = 0, pattern = "[A-Za-z0-9_-]"))]
        id: Path<String>,
        _auth: NoAuthorization,
    ) -> proposal_by_id_get::AllResponses {
        proposal_by_id_get::endpoint(id.0).await
    }

    /// Get proposal reviews.
    ///
    /// Get proposal reviews by proposal identifier.
    #[oai(
        path = "/reviews/:proposal_id",
        method = "get",
        operation_id = "GetReviewByProposalId",
        deprecated = true
    )]
    async fn review_by_proposal_id_get(
        &self,
        /// The proposal identifier to retrieve the reviews.
        #[oai(validator(max_length = 256, min_length = 0, pattern = "[A-Za-z0-9_-]"))]
        proposal_id: Path<String>,
        _auth: NoAuthorization,
    ) -> review_by_proposal_id_get::AllResponses {
        review_by_proposal_id_get::endpoint(proposal_id.0).await
    }
}
