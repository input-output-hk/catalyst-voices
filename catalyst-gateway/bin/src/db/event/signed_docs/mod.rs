//! Signed docs queries

mod full_signed_doc;
mod query_filter;
mod signed_doc_body;
#[cfg(test)]
mod tests;

pub(crate) use full_signed_doc::FullSignedDoc;
pub(crate) use query_filter::DocsQueryFilter;
pub(crate) use signed_doc_body::{SignedDocBody, FILTERED_SELECT_SIGNED_DOCS_TEMPLATE};

use super::{EventDB, NotFoundError};
use crate::jinja::{get_template, JinjaTemplateSource};

/// Insert sql query
const INSERT_SIGNED_DOCS: &str = include_str!("./sql/insert_signed_documents.sql");

/// Select sql query jinja template
pub(crate) const SELECT_SIGNED_DOCS_TEMPLATE: JinjaTemplateSource = JinjaTemplateSource {
    name: "select_signed_documents.jinja.template",
    source: include_str!("./sql/select_signed_documents.sql.jinja"),
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

    EventDB::modify(INSERT_SIGNED_DOCS, &doc.postgres_db_fields()).await?;
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
