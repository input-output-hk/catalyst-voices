//! `SignedDocBody` struct implementation.

/// Signed doc body event db struct
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct SignedDocBody {
    /// `signed_doc` table `id` field
    pub(crate) id: uuid::Uuid,
    /// `signed_doc` table `ver` field
    pub(crate) ver: uuid::Uuid,
    /// `signed_doc` table `type` field
    pub(crate) doc_type: uuid::Uuid,
    /// `signed_doc` table `author` field
    pub(crate) author: String,
    /// `signed_doc` table `metadata` field
    pub(crate) metadata: Option<serde_json::Value>,
}

impl SignedDocBody {
    /// Creates a  `SignedDocBody` from postgresql row object.
    pub(crate) fn from_row(row: &tokio_postgres::Row) -> anyhow::Result<Self> {
        let id = row.try_get("id")?;
        let ver = row.try_get("ver")?;
        let doc_type = row.try_get("type")?;
        let author = row.try_get("author")?;
        let metadata = row.try_get("metadata")?;
        Ok(Self {
            id,
            ver,
            doc_type,
            author,
            metadata,
        })
    }
}
