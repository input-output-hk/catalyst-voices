//! Document Index Query

use std::future;

use dashmap::DashMap;
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
    service::common::{
        objects::generic::pagination::CurrentPage,
        responses::WithErrorResponses,
        types::{document::id::DocumentId, generic::query::pagination::Remaining},
    },
};

pub(crate) mod query_filter;
pub(crate) mod response;

/// Endpoint responses.
#[derive(ApiResponse)]
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
    #[allow(dead_code)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # POST `/document/index`
pub(crate) async fn endpoint(
    filter: DocumentIndexQueryFilter, page: Option<Page>, limit: Option<Limit>,
) -> AllResponses {
    let query_limits = QueryLimits::new(limit, page);
    let conditions = match filter.try_into() {
        Ok(db_filter) => db_filter,
        Err(e) => return AllResponses::handle_error(&e),
    };

    let (docs, counts) = tokio::join!(
        fetch_docs(&conditions, &query_limits),
        SignedDocBody::retrieve_count(&conditions)
    );

    // Use default if page or limit is None
    let page = page.unwrap_or_default();
    let limit = limit.unwrap_or_default();

    let total: u64 = match counts {
        Ok(total) => {
            match total.try_into() {
                Ok(t) => t,
                Err(e) => {
                    return AllResponses::handle_error(&e.into());
                },
            }
        },
        Err(e) => return AllResponses::handle_error(&e),
    };

    match docs {
        Ok(docs) => {
            let doc_count: u64 = match docs.len().try_into() {
                Ok(d) => d,
                Err(e) => return AllResponses::handle_error(&e.into()),
            };

            let remaining = Remaining::calculate(page.into(), limit.into(), total, doc_count);

            Responses::Ok(Json(DocumentIndexListDocumented(DocumentIndexList {
                docs,
                page: Some(CurrentPage {
                    page,
                    limit,
                    remaining,
                }),
            })))
            .into()
        },
        Err(e) => AllResponses::handle_error(&e),
    }
}

/// Fetch documents from the event db
async fn fetch_docs(
    conditions: &DocsQueryFilter, query_limits: &QueryLimits,
) -> anyhow::Result<Vec<IndexedDocumentDocumented>> {
    let docs_stream = SignedDocBody::retrieve(conditions, query_limits).await?;
    let indexed_docs = DashMap::new();

    docs_stream
        .try_for_each(|doc: SignedDocBody| {
            let id = *doc.id();
            indexed_docs.entry(id).or_insert_with(Vec::new).push(doc);
            future::ready(Ok(()))
        })
        .await?;

    let docs = indexed_docs
        .into_iter()
        .map(|(id, docs)| -> anyhow::Result<_> {
            let ver = docs
                .into_iter()
                .map(TryInto::try_into)
                .collect::<Result<_, _>>()?;

            Ok(IndexedDocumentDocumented(IndexedDocument {
                doc_id: DocumentId::new_unchecked(id.to_string()),
                ver,
            }))
        })
        .collect::<Result<_, _>>()?;
    Ok(docs)
}
