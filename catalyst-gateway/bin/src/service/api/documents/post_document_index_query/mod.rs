//! Document Index Query

use std::future;

use catalyst_signed_doc::CatalystSignedDocument;
use dashmap::DashMap;
use futures::TryStreamExt;
use poem_openapi::{payload::Json, ApiResponse};
use query_filter::DocumentIndexQueryFilter;
use response::{
    DocumentIndexList, DocumentIndexListDocumented, IndexedDocument, IndexedDocumentDocumented,
};
use serde_json::json;

use super::{templates::TEMPLATES, Limit, Page};
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
    let conditions: DocsQueryFilter = match filter.try_into() {
        Ok(db_filter) => db_filter,
        Err(e) => return AllResponses::handle_error(&e),
    };

    let mut templates = vec![];

    for template in TEMPLATES.iter() {
        if conditions.filter(template) {
            templates.push(template);
        }
    }

    let (docs, counts) = tokio::join!(
        fetch_docs(&conditions, &query_limits, templates.clone()),
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

            let remaining = Remaining::calculate(
                page.into(),
                limit.into(),
                total.saturating_add(templates.len().try_into().unwrap_or_default()),
                doc_count,
            );

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
    static_doc: Vec<&CatalystSignedDocument>,
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

    for doc in static_doc {
        let authors = doc
            .signatures()
            .kids()
            .into_iter()
            .map(|kid| kid.to_string())
            .collect();

        indexed_docs
            .entry(doc.doc_id().uuid())
            .or_insert_with(Vec::new)
            .push(SignedDocBody::new(
                doc.doc_id().uuid(),
                doc.doc_ver().uuid(),
                doc.doc_type().uuid(),
                authors,
                // This should not fail
                Some(json!(doc.doc_meta())),
            ));
    }

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
