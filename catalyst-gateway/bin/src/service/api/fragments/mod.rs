//! Fragment endpoints

mod index;
mod statuses;

use poem_openapi::{param::Query, payload::Json, OpenApi};

use self::statuses::FragmentIds;
use crate::service::common::{objects::fragments_batch::FragmentsBatch, tags::ApiTags};

/// All Responses
pub(crate) struct FragmentsApi;

#[OpenApi(prefix_path = "/v1/fragments", tag = "ApiTags::Fragments")]
impl FragmentsApi {
    /// Process fragments
    ///
    /// Posts a fragments batch to be processed.
    #[oai(path = "/", method = "post", operation_id = "fragments")]
    async fn index(
        &self,
        /// Batch of fragments to be processed.
        Json(fragments_batch): Json<FragmentsBatch>,
    ) -> index::AllResponses {
        index::endpoint(fragments_batch).await
    }

    /// Get Fragment Statuses
    ///
    /// Get statuses of the fragments with the given ids.
    #[oai(path = "/statuses", method = "get", operation_id = "fragmentsStatuses")]
    async fn statuses(
        &self,
        /// Comma-separated list of fragment ids for which the statuses will
        /// be retrieved.
        Query(fragment_ids): Query<FragmentIds>,
    ) -> statuses::AllResponses {
        statuses::endpoint(fragment_ids).await
    }
}
