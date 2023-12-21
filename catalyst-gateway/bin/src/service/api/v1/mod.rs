//! `v1` Endpoints

use std::sync::Arc;

use poem::web::{Data, Path};
use poem_openapi::{param::Query, payload::Json, OpenApi};

use crate::{
    service::common::{
        objects::{account_votes::AccountId, fragments_batch::FragmentsBatch},
        tags::ApiTags,
    },
    state::State,
};

mod account_votes_get;
mod fragments_post;
mod fragments_statuses;

/// V1 API Endpoints
pub(crate) struct V1Api;

#[OpenApi(prefix_path = "/v1", tag = "ApiTags::V1")]
impl V1Api {
    #[oai(
        path = "/votes/plan/account-votes/:account_id",
        method = "get",
        operation_id = "AccountVotes"
    )]
    /// Get from all active vote plans, the index of the voted proposals
    /// by th given account ID.
    async fn get_account_votes(
        &self, state: Data<&Arc<State>>, account_id: Path<AccountId>,
    ) -> account_votes_get::AllResponses {
        account_votes_get::endpoint(state, account_id).await
    }

    /// Process fragments
    ///
    /// Posts a fragments batch to be processed.
    #[oai(
        path = "/fragments",
        method = "post",
        operation_id = "fragments",
        tag = "ApiTags::Fragments",
        deprecated = true
    )]
    async fn fragments_post(
        &self,
        /// Batch of fragments to be processed.
        Json(fragments_batch): Json<FragmentsBatch>,
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
        tag = "ApiTags::Fragments",
        deprecated = true
    )]
    async fn fragments_statuses(
        &self,
        /// Comma-separated list of fragment ids for which the statuses will
        /// be retrieved.
        Query(fragment_ids): Query<fragments_statuses::FragmentIds>,
    ) -> fragments_statuses::AllResponses {
        fragments_statuses::endpoint(fragment_ids).await
    }
}
