//! `FullSignedDoc` struct implementation.

use super::SignedDocBody;

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
        self.body.id()
    }

    /// Returns the document version.
    pub(crate) fn ver(&self) -> &uuid::Uuid {
        self.body.ver()
    }

    /// Returns the document author.
    #[allow(dead_code)]
    pub(crate) fn author(&self) -> &String {
        self.body.author()
    }

    /// Returns the `SignedDocBody`.
    #[allow(dead_code)]
    pub(crate) fn body(&self) -> &SignedDocBody {
        &self.body
    }

    /// Returns all signed document fields for the event db queries
    pub(crate) fn postgres_db_fields(&self) -> [&(dyn tokio_postgres::types::ToSql + Sync); 7] {
        let body_fields = self.body.postgres_db_fields();
        [
            body_fields[0],
            body_fields[1],
            body_fields[2],
            body_fields[3],
            body_fields[4],
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
            body: SignedDocBody::new(
                *id,
                ver,
                row.try_get("type")?,
                row.try_get("author")?,
                row.try_get("metadata")?,
            ),
            payload: row.try_get("payload")?,
            raw: row.try_get("raw")?,
        })
    }
}
