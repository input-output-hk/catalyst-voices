//! Signed docs queries

#[cfg(test)]
mod tests;

use super::{common::query_limits::QueryLimits, EventDB, NotFoundError};
use crate::jinja::{get_template, JinjaTemplateSource};

/// Insert sql query
const INSERT_SIGNED_DOCS: &str = include_str!("./sql/insert_signed_documents.sql");

/// Select sql query jinja template
pub(crate) const SELECT_SIGNED_DOCS_TEMPLATE: JinjaTemplateSource = JinjaTemplateSource {
    name: "select_signed_documents.jinja.template",
    source: include_str!("./sql/select_signed_documents.sql.jinja"),
};

/// Advanced select sql query jinja template
pub(crate) const ADVANCED_SELECT_SIGNED_DOCS_TEMPLATE: JinjaTemplateSource = JinjaTemplateSource {
    name: "advanced_select_signed_documents.jinja.template",
    source: include_str!("./sql/advanced_select_signed_documents.sql.jinja"),
};

/// Signed doc body event db struct
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct SignedDocBody {
    /// `signed_doc` table `id` field
    id: uuid::Uuid,
    /// `signed_doc` table `ver` field
    ver: uuid::Uuid,
    /// `signed_doc` table `type` field
    doc_type: uuid::Uuid,
    /// `signed_doc` table `author` field
    author: String,
    /// `signed_doc` table `metadata` field
    metadata: Option<serde_json::Value>,
}

/// Full signed doc event db struct
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct FullSignedDoc {
    /// Signed doc body
    body: SignedDocBody,
    /// `signed_doc` table `payload` field
    payload: Option<serde_json::Value>,
    /// `signed_doc` table `raw` field
    raw: Vec<u8>,
}

/// Make an insert query into the `event-db` by adding data into the `signed_docs` table.
///
/// * IF the record primary key (id,ver) does not exist, then add the new record. Return
///   success.
/// * IF the record does exist, but all values are the same as stored, return Success.
/// * Otherwise return an error. (Can not over-write an existing record with new data).
///
/// # Arguments:
///  - `id` is a UUID v7
///  - `ver` is a UUID v7
///  - `doc_type` is a UUID v4
#[allow(dead_code)]
pub(crate) async fn insert_signed_docs(doc: &FullSignedDoc) -> anyhow::Result<()> {
    match select_signed_docs(&doc.body.id, &doc.body.ver).await {
        Ok(res_doc) => {
            anyhow::ensure!(
                &res_doc == doc,
                "Document with the same `id` and `ver` already exists"
            );
            return Ok(());
        },
        Err(err) if err.is::<NotFoundError>() => {},
        Err(err) => return Err(err),
    }

    EventDB::modify(INSERT_SIGNED_DOCS, &[
        &doc.body.id,
        &doc.body.ver,
        &doc.body.doc_type,
        &doc.body.author,
        &doc.body.metadata,
        &doc.payload,
        &doc.raw,
    ])
    .await?;
    Ok(())
}

/// Make a select query into the `event-db` by getting data from the `signed_docs` table.
async fn select_signed_docs(id: &uuid::Uuid, ver: &uuid::Uuid) -> anyhow::Result<FullSignedDoc> {
    let query_template = get_template(&SELECT_SIGNED_DOCS_TEMPLATE)?;
    let query = query_template.render(serde_json::json!({
        "id": id,
        "ver": ver,
    }))?;
    let res = EventDB::query_one(&query, &[]).await?;

    let doc_type = res.try_get("type")?;
    let author = res.try_get("author")?;
    let metadata = res.try_get("metadata")?;
    let payload = res.try_get("payload")?;
    let raw = res.try_get("raw")?;

    Ok(FullSignedDoc {
        body: SignedDocBody {
            id: *id,
            ver: *ver,
            doc_type,
            author,
            metadata,
        },
        payload,
        raw,
    })
}

/// A `select_signed_docs` query filtering argument.
#[allow(dead_code)]
pub(crate) enum DocsQueryFilter {
    /// All entries
    All,
    /// Select docs with the specific `type` field
    DocType(uuid::Uuid),
    /// Select docs with the specific `id` field
    DocId(uuid::Uuid),
    /// Select docs with the specific `id` and `ver` field
    DocVer(uuid::Uuid, uuid::Uuid),
    /// Select docs with the specific `author` field
    Author(String),
}

impl DocsQueryFilter {
    /// Returns a string with the corresponding query docs filter statement
    pub(crate) fn query_stmt(&self) -> String {
        match self {
            Self::All => "TRUE".to_string(),
            Self::DocType(doc_type) => format!("signed_docs.type = '{doc_type}'"),
            Self::DocId(id) => format!("signed_docs.id = '{id}'"),
            Self::DocVer(id, ver) => {
                format!("signed_docs.id = '{id}' AND signed_docs.ver = '{ver}'")
            },
            Self::Author(author) => format!("signed_docs.author = '{author}'"),
        }
    }
}

/// Make an filtered select query into the `event-db` by getting data from the
/// `signed_docs` table.
#[allow(dead_code)]
pub(crate) async fn filtered_select_signed_docs(
    conditions: &DocsQueryFilter, query_limits: &QueryLimits,
) -> anyhow::Result<Vec<SignedDocBody>> {
    let query_template = get_template(&ADVANCED_SELECT_SIGNED_DOCS_TEMPLATE)?;
    let query = query_template.render(serde_json::json!({
        "conditions": conditions.query_stmt(),
        "query_limits": query_limits.query_stmt(),
    }))?;
    let rows = EventDB::query(&query, &[]).await?;

    let docs = rows
        .into_iter()
        .map(|row| {
            let id = row.try_get("id")?;
            let ver = row.try_get("ver")?;
            let doc_type = row.try_get("type")?;
            let author = row.try_get("author")?;
            let metadata = row.try_get("metadata")?;
            Ok(SignedDocBody {
                id,
                ver,
                doc_type,
                author,
                metadata,
            })
        })
        .collect::<anyhow::Result<_>>()?;

    Ok(docs)
}
