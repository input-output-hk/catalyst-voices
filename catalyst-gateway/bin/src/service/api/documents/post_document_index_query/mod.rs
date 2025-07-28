//! Document Index Query

use std::collections::HashMap;

use catalyst_signed_doc::CatalystSignedDocument;
use futures::{future::join_all, TryStreamExt};
use poem_openapi::{payload::Json, ApiResponse};
use query_filter::DocumentIndexQueryFilter;
use response::{
    DocumentIndexList, DocumentIndexListDocumented, IndexedDocument, IndexedDocumentDocumented,
};

use super::{Limit, Page};
use crate::{
    db::event::{
        common::query_limits::QueryLimits,
        signed_docs::{DocsQueryFilter, FullSignedDoc, SignedDocBody},
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

    // need `FullSignedDoc` in order to read the `raw` part to check its deprecation.
    // this is performance hit, but we use this endpoint for transition temporarily.
    let tasks = indexed_docs.iter().flat_map(|(id, docs)| {
        docs.iter()
            .map(|item| async move { FullSignedDoc::retrieve(id, Some(item.ver())).await })
            .collect::<Vec<_>>()
    });

    let results = join_all(tasks).await;
    let results = results.into_iter().collect::<Result<Vec<_>, _>>()?;

    // filter for only deprecated signed docs
    let mut deprecated_docs = vec![];
    for doc in results.into_iter() {
        if CatalystSignedDocument::try_from(doc.raw())?.is_deprecated()? {
            deprecated_docs.push(doc);
        }
    }

    let indexed_docs = group_by(deprecated_docs, |doc| *doc.id());

    // convert to output response
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

fn group_by<T, K, F>(items: Vec<T>, key_fn: F) -> Vec<(K, Vec<T>)>
where
    F: Fn(&T) -> K,
    K: Eq + std::hash::Hash + Ord,
{
    let mut map: HashMap<K, Vec<T>> = HashMap::new();
    for item in items {
        let key = key_fn(&item);
        map.entry(key).or_default().push(item);
    }

    let mut vec: Vec<_> = map.into_iter().collect();
    // Descending order
    vec.sort_by(|a, b| b.0.cmp(&a.0));
    vec
}
