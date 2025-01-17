//! Document Index Query

use poem_openapi::{payload::Json, ApiResponse, Object};
use query_filter::DocumentIndexQueryFilter;
use response::DocumentIndexListDocumented;

use super::{Limit, Page};
use crate::service::common::responses::WithErrorResponses;

pub(crate) mod query_filter;
pub(crate) mod response;

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// ## OK
    ///
    /// The Index of documents which match the query filter.
    #[oai(status = 200)]
    Ok(Json<DocumentIndexListDocumented>),
    /// ## Not Found
    ///
    /// No documents were found which match the query filter.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Update user schema
#[derive(Debug, Object, Clone, Eq, PartialEq)]
pub(crate) struct QueryDocumentIndex {
    /// Name
    name: Option<String>,
}

/// # POST `/document/index`
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(
    filter: DocumentIndexQueryFilter, page: Option<Page>, limit: Option<Limit>,
) -> AllResponses {
    let _filter = filter;
    let _page = page;
    let _limit = limit;

    // We return this when the filter results in no documents found.
    Responses::NotFound.into()
}
