//! `v1` Endpoints
use poem_openapi::{
    param::{Path, Query},
    payload::Json,
    OpenApi,
};

use crate::service::{
    common::{
        auth::none::NoAuthorization,
        objects::legacy::{
            account_votes::AccountId, fragments_batch::FragmentsBatch,
            fragments_processing_summary::FragmentId,
        },
        tags::ApiTags,
    },
    utilities::middleware::event_db_schema_validation::event_db_schema_version_validation,
};

mod account_votes_get;
mod fragments_post;
mod fragments_statuses;

/// V1 API Endpoints
pub(crate) struct V1Api;

#[OpenApi(prefix_path = "/v1", tag = "ApiTags::Legacy")]
impl V1Api {
    /// Get Account Votes
    ///
    /// Get from all active vote plans, the index of the voted proposals
    /// by the given account ID.
    #[oai(
        path = "/votes/plan/account-votes/:account_id",
        method = "get",
        operation_id = "AccountVotes",
        transform = "event_db_schema_version_validation",
        deprecated = true
    )]
    async fn get_account_votes(
        &self,
        /// A account ID to get the votes for.
        #[oai(validator(max_length = "100", pattern = "^0x[a-f0-9]+$"))]
        account_id: Path<AccountId>,
        _auth: NoAuthorization,
    ) -> account_votes_get::AllResponses {
        account_votes_get::endpoint(account_id).await
    }

    /// Process fragments
    ///
    /// Posts a fragments batch to be processed.
    #[oai(
        path = "/fragments",
        method = "post",
        operation_id = "fragments",
        transform = "event_db_schema_version_validation",
        deprecated = true
    )]
    async fn fragments_post(
        &self,
        /// Batch of fragments to be processed.
        Json(fragments_batch): Json<FragmentsBatch>,
        _auth: NoAuthorization,
    ) -> fragments_post::AllResponses {
        fragments_post::endpoint(fragments_batch).await
    }

    /// Get Fragment Statuses
    ///
    /// Get statuses of the fragments with the given ids.
    #[oai(
        path = "/fragments/statuses",
        method = "get",
        operation_id = "fragmentsStatuses",
        transform = "event_db_schema_version_validation",
        deprecated = true
    )]
    async fn fragments_statuses(
        &self,
        /// Comma-separated list of fragment ids for which the statuses will
        /// be retrieved.
        // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
        #[oai(validator(max_items = "1000"))]
        Query(fragment_ids): Query<Vec<FragmentId>>,
        _auth: NoAuthorization,
    ) -> fragments_statuses::AllResponses {
        fragments_statuses::endpoint(fragment_ids).await
    }
}
