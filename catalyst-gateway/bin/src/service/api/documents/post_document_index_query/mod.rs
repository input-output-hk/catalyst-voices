//! Document Index Query

use futures::TryStreamExt;
use poem_openapi::{payload::Json, ApiResponse};
use query_filter::DocumentIndexQueryFilter;
use response::{
    DocumentIndexList, DocumentIndexListDocumented, IndexedDocument, IndexedDocumentDocumented,
};

use super::{Limit, Page};
use crate::{
    db::event::{
        common::query_limits::QueryLimits,
        signed_docs::{DocsQueryFilter, SignedDocBody},
    },
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

    match fetch_docs(&conditions, &query_limits).await {
        Ok(docs) if docs.is_empty() => Responses::NotFound.into(),
        Ok(docs) => {
            Responses::Ok(Json(DocumentIndexListDocumented(DocumentIndexList {
                docs: docs.into_iter().map(IndexedDocumentDocumented).collect(),
                page: None,
            })))
            .into()
        },
        Err(e) => AllResponses::handle_error(&e),
    }
}

/// Fetch documents from the event db
async fn fetch_docs(
    conditions: &DocsQueryFilter, query_limits: &QueryLimits,
) -> anyhow::Result<Vec<IndexedDocument>> {
    let mut docs_iter = SignedDocBody::retrieve(conditions, query_limits).await?;

    while let Some(_doc) = docs_iter.try_next().await? {}

    let docs = Vec::new();
    Ok(docs)
}
