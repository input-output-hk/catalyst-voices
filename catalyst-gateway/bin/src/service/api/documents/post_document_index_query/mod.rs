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
pub(crate) async fn endpoint(
    filter: DocumentIndexQueryFilter, page: Option<Page>, limit: Option<Limit>,
) -> AllResponses {
    let query_limits = QueryLimits::new(limit, page);
    let conditions = match filter.try_into() {
        Ok(db_filter) => db_filter,
        Err(e) => return AllResponses::handle_error(&e),
    };

    let (fetched_docs, total_doc_count) = tokio::join!(
        fetch_docs(&conditions, &query_limits),
        SignedDocBody::retrieve_count(&conditions)
    );

    // Use default if page or limit is None
    let page = page.unwrap_or_default();
    let limit = limit.unwrap_or_default();

    let total: u32 = match total_doc_count {
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

    match fetched_docs {
        Ok((docs, doc_count)) => {
            let remaining = Remaining::calculate(page.into(), limit.into(), total, doc_count);

            Responses::Ok(Json(DocumentIndexListDocumented(DocumentIndexList {
                docs: docs.into(),
                page: CurrentPage {
                    page,
                    limit,
                    remaining,
                }
                .into(),
            })))
            .into()
        },
        Err(e) => AllResponses::handle_error(&e),
    }
}

/// Fetch documents from the event db
async fn fetch_docs(
    conditions: &DocsQueryFilter, query_limits: &QueryLimits,
) -> anyhow::Result<(Vec<IndexedDocumentDocumented>, u32)> {
    let docs_stream = SignedDocBody::retrieve(conditions, query_limits).await?;
    let indexed_docs = DashMap::new();

    let mut total_fetched_doc_count: u32 = 0;
    docs_stream
        .try_for_each(|doc: SignedDocBody| {
            let id = *doc.id();
            indexed_docs.entry(id).or_insert_with(Vec::new).push(doc);
            match total_fetched_doc_count.checked_add(1) {
                Some(updated_count) => {
                    total_fetched_doc_count = updated_count;
                },
                None => {
                    return future::ready(Err(anyhow::anyhow!(
                        "Fetched Signed Documents overflow"
                    )));
                },
            };
            future::ready(Ok(()))
        })
        .await?;

    let docs = indexed_docs
        .into_iter()
        .map(|(id, docs)| -> anyhow::Result<_> {
            let ver = docs
                .into_iter()
                .map(TryInto::try_into)
                .collect::<Result<Vec<_>, _>>()?
                .into();

            Ok(IndexedDocumentDocumented(IndexedDocument {
                doc_id: DocumentId::new_unchecked(id.to_string()),
                ver,
            }))
        })
        .collect::<Result<_, _>>()?;
    Ok((docs, total_fetched_doc_count))
}
