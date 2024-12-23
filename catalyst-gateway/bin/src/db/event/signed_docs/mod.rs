//! Signed docs queries

#[cfg(test)]
mod tests;

use super::EventDB;

/// Insert sql query
const INSERT_SIGNED_DOCS: &str = include_str!("./sql/insert_signed_documents.sql");

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
pub(crate) async fn insert_signed_docs(
    id: &uuid::Uuid, ver: &uuid::Uuid, doc_type: &uuid::Uuid, author: &String,
    metadata: &Option<serde_json::Value>, payload: &Option<serde_json::Value>, raw: &Vec<u8>,
) -> anyhow::Result<()> {
    EventDB::modify(INSERT_SIGNED_DOCS, &[
        id, ver, doc_type, author, metadata, payload, raw,
    ])
    .await?;
    Ok(())
}
