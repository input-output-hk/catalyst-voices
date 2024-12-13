//! Signed docs queries

#[cfg(test)]
mod tests;

use super::EventDB;
use crate::jinja::{JinjaTemplateSource, JINJA_ENV};

/// Insert sql query
const INSERT_SIGNED_DOCS: &str = include_str!("./sql/insert_signed_documents.sql");

/// Select sql query jinja template
pub(crate) const SELECT_SIGNED_DOCS_TEMPLATE: JinjaTemplateSource = JinjaTemplateSource {
    name: "select_signed_documents.jinja.template",
    source: include_str!("./sql/select_signed_documents.sql.jinja"),
};

/// signed doc event db struct
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct SignedDoc {
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
    /// `signed_doc` table `payload` field
    payload: Option<serde_json::Value>,
    /// `signed_doc` table `raw` field
    raw: Vec<u8>,
}

/// Make an insert query into the `event-db` by adding data into the `signed_docs` table
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
pub(crate) async fn insert_signed_docs(doc: &SignedDoc) -> anyhow::Result<()> {
    EventDB::modify(INSERT_SIGNED_DOCS, &[
        &doc.id,
        &doc.ver,
        &doc.doc_type,
        &doc.author,
        &doc.metadata,
        &doc.payload,
        &doc.raw,
    ])
    .await?;
    Ok(())
}

/// Make an select query into the `event-db` by getting data from the `signed_docs` table
///
/// * This returns a single document. All data from the document is returned, including
///   the `payload` and `raw` fields.
/// * `ver` should be able to be optional, in which case get the latest ver of the given
///   `id`.
///
/// # Arguments:
///  - `id` is a UUID v7
///  - `ver` is a UUID v7
#[allow(dead_code)]
pub(crate) async fn select_signed_docs(
    id: &uuid::Uuid, ver: &Option<uuid::Uuid>,
) -> anyhow::Result<SignedDoc> {
    let query_template = JINJA_ENV.get_template(SELECT_SIGNED_DOCS_TEMPLATE.name)?;
    let query = query_template.render(serde_json::json!({
        "id": id,
        "ver": ver,
    }))?;
    let res = EventDB::query_one(&query, &[]).await?;

    let ver = if let Some(ver) = ver {
        *ver
    } else {
        res.try_get("ver")?
    };

    let doc_type = res.try_get("type")?;
    let author = res.try_get("author")?;
    let metadata = res.try_get("metadata")?;
    let payload = res.try_get("payload")?;
    let raw = res.try_get("raw")?;

    Ok(SignedDoc {
        id: *id,
        ver,
        doc_type,
        author,
        metadata,
        payload,
        raw,
    })
}
