//! `FullSignedDoc` struct implementation.

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

impl FullSignedDoc {
    /// Creates a  `FullSignedDoc` instance.
    #[allow(dead_code)]
    pub(crate) fn new(
        body: SignedDocBody, payload: Option<serde_json::Value>, raw: Vec<u8>,
    ) -> Self {
        Self { body, payload, raw }
    }

    /// Returns the document id.
    pub(crate) fn id(&self) -> &uuid::Uuid {
        &self.body.id
    }

    /// Returns the document version.
    pub(crate) fn ver(&self) -> &uuid::Uuid {
        &self.body.ver
    }

    /// Returns the document author.
    #[allow(dead_code)]
    pub(crate) fn author(&self) -> &String {
        &self.body.author
    }

    /// Returns the `SignedDocBody`.
    #[allow(dead_code)]
    pub(crate) fn body(&self) -> &SignedDocBody {
        &self.body
    }

    /// Returns all signed document fields in that order which requires
    /// `INSERT_SIGNED_DOCS` query
    pub(crate) fn db_fields(&self) -> [&(dyn tokio_postgres::types::ToSql + Sync); 7] {
        [
            &self.body.id,
            &self.body.ver,
            &self.body.doc_type,
            &self.body.author,
            &self.body.metadata,
            &self.payload,
            &self.raw,
        ]
    }

    /// Creates a  `FullSignedDoc` from postgresql row object.
    pub(crate) fn from_row(
        id: &uuid::Uuid, ver: Option<&uuid::Uuid>, row: &tokio_postgres::Row,
    ) -> anyhow::Result<Self> {
        let ver = if let Some(ver) = ver {
            *ver
        } else {
            row.try_get("ver")?
        };

        Ok(FullSignedDoc {
            body: SignedDocBody {
                id: *id,
                ver,
                doc_type: row.try_get("type")?,
                author: row.try_get("author")?,
                metadata: row.try_get("metadata")?,
            },
            payload: row.try_get("payload")?,
            raw: row.try_get("raw")?,
        })
    }
}

impl SignedDocBody {
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
