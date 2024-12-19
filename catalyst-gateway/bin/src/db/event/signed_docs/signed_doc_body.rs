//! `SignedDocBody` struct implementation.

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

impl SignedDocBody {
    /// Returns the document id.
    pub(crate) fn id(&self) -> &uuid::Uuid {
        &self.id
    }

    /// Returns the document version.
    pub(crate) fn ver(&self) -> &uuid::Uuid {
        &self.ver
    }

    /// Returns the document author.
    pub(crate) fn author(&self) -> &String {
        &self.author
    }

    /// Returns all signed document fields for the event db queries
    pub(crate) fn postgres_db_fields(&self) -> [&(dyn tokio_postgres::types::ToSql + Sync); 5] {
        [
            &self.id,
            &self.ver,
            &self.doc_type,
            &self.author,
            &self.metadata,
        ]
    }

    /// Creates a  `SignedDocBody` instance.
    #[allow(dead_code)]
    pub(crate) fn new(
        id: uuid::Uuid, ver: uuid::Uuid, doc_type: uuid::Uuid, author: String,
        metadata: Option<serde_json::Value>,
    ) -> Self {
        Self {
            id,
            ver,
            doc_type,
            author,
            metadata,
        }
    }

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
