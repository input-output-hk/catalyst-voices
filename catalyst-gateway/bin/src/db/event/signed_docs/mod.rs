//! Signed docs queries

mod types;
#[cfg(test)]
mod tests;

pub(crate) use types::{FullSignedDoc, SignedDocBody};

use super::{common::query_limits::QueryLimits, EventDB, NotFoundError};
use crate::jinja::{get_template, JinjaTemplateSource};

/// Insert sql query
const INSERT_SIGNED_DOCS: &str = include_str!("./sql/insert_signed_documents.sql");

/// Select sql query jinja template
pub(crate) const SELECT_SIGNED_DOCS_TEMPLATE: JinjaTemplateSource = JinjaTemplateSource {
    name: "select_signed_documents.jinja.template",
    source: include_str!("./sql/select_signed_documents.sql.jinja"),
};

/// Filtered select sql query jinja template
pub(crate) const FILTERED_SELECT_SIGNED_DOCS_TEMPLATE: JinjaTemplateSource = JinjaTemplateSource {
    name: "filtered_select_signed_documents.jinja.template",
    source: include_str!("./sql/filtered_select_signed_documents.sql.jinja"),
};

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
    match select_signed_docs(doc.id(), Some(doc.ver())).await {
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

    EventDB::modify(INSERT_SIGNED_DOCS, &doc.db_fields()).await?;
    Ok(())
}

/// Make a select query into the `event-db` by getting data from the `signed_docs` table.
///
/// * This returns a single document. All data from the document is returned, including
///   the `payload` and `raw` fields.
/// * `ver` should be able to be optional, in which case get the latest ver of the given
///   `id`.
///
/// # Arguments:
///  - `id` is a UUID v7
///  - `ver` is a UUID v7
pub(crate) async fn select_signed_docs(
    id: &uuid::Uuid, ver: Option<&uuid::Uuid>,
) -> anyhow::Result<FullSignedDoc> {
    let query_template = get_template(&SELECT_SIGNED_DOCS_TEMPLATE)?;
    let query = query_template.render(serde_json::json!({
        "id": id,
        "ver": ver,
    }))?;
    let row = EventDB::query_one(&query, &[]).await?;

    FullSignedDoc::from_row(id, ver, &row)
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
    let query_template = get_template(&FILTERED_SELECT_SIGNED_DOCS_TEMPLATE)?;
    let query = query_template.render(serde_json::json!({
        "conditions": conditions.query_stmt(),
        "query_limits": query_limits.query_stmt(),
    }))?;
    let rows = EventDB::query(&query, &[]).await?;

    let docs = rows
        .iter()
        .map(SignedDocBody::from_row)
        .collect::<anyhow::Result<_>>()?;

    Ok(docs)
}
