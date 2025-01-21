//! Document Index Query

use poem_openapi::{payload::Json, ApiResponse, Object};
use query_filter::DocumentIndexQueryFilter;
use response::DocumentIndexListDocumented;

use super::{Limit, Page};
use crate::{
    db::event::{common::query_limits::QueryLimits, signed_docs::SignedDocBody},
    service::common::responses::WithErrorResponses,
};

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

/// # POST `/document/index`
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(
    filter: DocumentIndexQueryFilter, page: Option<Page>, limit: Option<Limit>,
) -> AllResponses {
    let query_limits = match QueryLimits::new(limit, page) {
        Ok(query_limits) => query_limits,
        Err(_e) => return AllResponses::unauthorized(),
    };

    let conditions = match filter.try_into() {
        Ok(db_filter) => db_filter,
        Err(e) => return AllResponses::handle_error(&e),
    };

    match SignedDocBody::retrieve(&conditions, &query_limits).await {
        // We return this when the filter results in no documents found.
        Ok(_) => Responses::NotFound.into(),
        Err(e) => AllResponses::handle_error(&e),
    }
}
