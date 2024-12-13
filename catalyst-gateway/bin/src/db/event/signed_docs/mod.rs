//! Signed docs queries

#[cfg(test)]
mod tests;

use super::EventDB;

/// Upsert sql query
const UPSERT_SIGNED_DOCS: &str = include_str!("./sql/upsert_signed_documents.sql");

/// Make an upsert query into the `event-db` by adding data into the `signed_docs` table
///
/// * IF the record primary key (id,ver) does not exist, then add the new record. Return
///   success.
/// * IF the record does exist, but all values are the same as stored, return Success.
/// * Otherwise return an error. (Can not over-write an existing record with new data).
#[allow(dead_code)]
pub(crate) async fn upsert_signed_docs(
    id: &uuid::Uuid, ver: &uuid::Uuid, doc_type: &uuid::Uuid, author: &String,
    metadata: &serde_json::Value, payload: &serde_json::Value, raw: &Vec<u8>,
) -> anyhow::Result<()> {
    anyhow::ensure!(
        id.get_version() == Some(uuid::Version::SortRand),
        "`id` must be a UUID v7"
    );
    anyhow::ensure!(
        ver.get_version() == Some(uuid::Version::SortRand),
        "`ver` must be a UUID v7"
    );
    anyhow::ensure!(
        doc_type.get_version() == Some(uuid::Version::Random),
        "`doc_type` must be a UUID v4"
    );

    EventDB::modify(UPSERT_SIGNED_DOCS, &[
        id, ver, doc_type, author, metadata, payload, raw,
    ])
    .await?;
    Ok(())
}
