//! Document Index Query

use std::future;

use dashmap::DashMap;
use futures::TryStreamExt;
use poem_openapi::{payload::Json, ApiResponse};
use query_filter::DocumentIndexQueryFilter;
use response::{
    DocumentIndexList, DocumentIndexListDocumented, IndexedDocument, IndexedDocumentDocumented,
    IndexedDocumentVersion, IndexedDocumentVersionDocumented,
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
pub(crate) async fn endpoint(
    filter: DocumentIndexQueryFilter, page: Option<Page>, limit: Option<Limit>,
) -> AllResponses {
    let query_limits = QueryLimits::new(limit, page);
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
                .map(|doc| -> anyhow::Result<_> {
                    Ok(IndexedDocumentVersionDocumented(IndexedDocumentVersion {
                        ver: doc.ver().to_string().try_into()?,
                        doc_type: doc.doc_type().to_string().try_into()?,
                        doc_ref: None,
                        reply: None,
                        template: None,
                        brand: None,
                        campaign: None,
                        category: None,
                    }))
                })
                .collect::<Result<_, _>>()?;

            Ok(IndexedDocument {
                doc_id: id.to_string().try_into()?,
                ver,
            })
        })
        .collect::<Result<_, _>>()?;
    Ok(docs)
}
