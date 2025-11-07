//! Document Index Query V2 endpoint implementation.

pub(crate) mod request;
pub(crate) mod response;

use std::collections::HashMap;

use futures::TryStreamExt;
use poem_openapi::{ApiResponse, payload::Json};

use crate::{
    db::event::{
        common::query_limits::QueryLimits,
        signed_docs::{DocsQueryFilter, SignedDocBody},
    },
    service::{
        api::documents::post_document_index_query::v2::{
            request::DocumentIndexQueryFilterV2,
            response::{
                DocumentIndexListDocumentedV2, DocumentIndexListV2, IndexedDocumentDocumentedV2,
                IndexedDocumentV2,
            },
        },
        common::{
            objects::generic::pagination::CurrentPage,
            responses::WithErrorResponses,
            types::{
                document::id::DocumentId,
                generic::query::pagination::{Limit, Page, Remaining},
            },
        },
    },
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## OK
    ///
    /// The Index of documents which match the query filter.
    #[oai(status = 200)]
    Ok(Json<response::DocumentIndexListDocumentedV2>),
    /// ## Not Found
    ///
    /// No documents were found which match the query filter.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # POST `/v2/document/index`
pub(crate) async fn endpoint(
    filter: DocumentIndexQueryFilterV2,
    page: Option<Page>,
    limit: Option<Limit>,
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
        Ok((docs, _)) if docs.is_empty() => Responses::NotFound.into(),
        Ok((docs, doc_count)) => {
            let remaining = Remaining::calculate(page.into(), limit.into(), total, doc_count);

            Responses::Ok(Json(DocumentIndexListDocumentedV2(DocumentIndexListV2 {
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
    conditions: &DocsQueryFilter,
    query_limits: &QueryLimits,
) -> anyhow::Result<(Vec<IndexedDocumentDocumentedV2>, u32)> {
    let docs_stream = SignedDocBody::retrieve(conditions, query_limits).await?;

    let (indexed_docs, total_fetched_doc_count) = docs_stream
        .try_fold(
            (HashMap::new(), 0u32),
            |(mut indexed_docs, mut total_fetched_doc_count), doc| {
                async move {
                    let id = *doc.id();
                    indexed_docs.entry(id).or_insert_with(Vec::new).push(doc);
                    total_fetched_doc_count = total_fetched_doc_count
                        .checked_add(1)
                        .ok_or(anyhow::anyhow!("Fetched Signed Documents overflow"))?;
                    Ok((indexed_docs, total_fetched_doc_count))
                }
            },
        )
        .await?;

    // convert to output response
    let docs = indexed_docs
        .into_iter()
        .map(|(id, docs)| -> anyhow::Result<_> {
            let ver = docs
                .into_iter()
                .map(TryInto::try_into)
                .collect::<Result<Vec<_>, _>>()?
                .into();

            Ok(IndexedDocumentDocumentedV2(IndexedDocumentV2 {
                doc_id: DocumentId::new_unchecked(id.to_string()),
                ver,
            }))
        })
        .collect::<Result<Vec<_>, _>>()?
        .into_iter()
        .filter(|indexed_doc| !indexed_doc.0.ver.is_empty())
        .collect::<_>();

    Ok((docs, total_fetched_doc_count))
}
