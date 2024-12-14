//! Signed docs queries

#[cfg(test)]
mod tests;

use super::{EventDB, NotFoundError};
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
pub(crate) async fn insert_signed_docs(doc: &SignedDoc) -> anyhow::Result<()> {
    match select_signed_docs(&doc.id, &Some(doc.ver)).await {
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
#[allow(dead_code)]
pub(crate) async fn select_signed_docs(
    id: &uuid::Uuid, ver: &Option<uuid::Uuid>,
) -> anyhow::Result<SignedDoc> {
    let query_template = get_template(&SELECT_SIGNED_DOCS_TEMPLATE)?;
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

/// Make an advanced select query into the `event-db` by getting data from the
/// `signed_docs` table.
///
/// # Arguments:
///  - `conditions` an SQL `WHERE` statements
#[allow(dead_code)]
pub(crate) async fn advanced_select_signed_docs(
    conditions: &str, limit: Option<u64>, offset: Option<u64>,
) -> anyhow::Result<SignedDoc> {
    let query_template = get_template(&ADVANCED_SELECT_SIGNED_DOCS_TEMPLATE)?;
    let query = query_template.render(serde_json::json!({
        "conditions": conditions,
        "limit": limit,
        "offset": offset,
    }))?;
    let res = EventDB::query_one(&query, &[]).await?;

    let id = res.try_get("id")?;
    let ver = res.try_get("ver")?;
    let doc_type = res.try_get("type")?;
    let author = res.try_get("author")?;
    let metadata = res.try_get("metadata")?;
    let payload = res.try_get("payload")?;
    let raw = res.try_get("raw")?;

    Ok(SignedDoc {
        id,
        ver,
        doc_type,
        author,
        metadata,
        payload,
        raw,
    })
}
