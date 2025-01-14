//! Document Index Query

use poem::Body;
use poem_openapi::{ApiResponse, Object};
use query_filter::DocumentIndexQueryFilter;

use crate::service::common::{responses::WithErrorResponses, types::payload::cbor::Cbor};

pub(crate) mod query_filter;

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// ## OK
    /// 
    /// The Index of documents which match the query filter.
    #[oai(status = 200)]
    Ok(Cbor<Body>),
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
pub(crate) async fn endpoint(filter: DocumentIndexQueryFilter) -> AllResponses {
    let _filter = filter;

    // We return this when the filter results in no documents found.
    Responses::NotFound.into()
}
