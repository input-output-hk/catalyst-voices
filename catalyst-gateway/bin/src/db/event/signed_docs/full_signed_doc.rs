//! `FullSignedDoc` struct implementation.

use super::SignedDocBody;

/// Full signed doc event db struct
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct FullSignedDoc {
    /// Signed doc body
    pub(crate) body: SignedDocBody,
    /// `signed_doc` table `payload` field
    pub(crate) payload: Option<serde_json::Value>,
    /// `signed_doc` table `raw` field
    pub(crate) raw: Vec<u8>,
}

impl FullSignedDoc {
    /// Creates a  `FullSignedDoc` from postgresql row object.
    pub(crate) fn from_row(
        id: &uuid::Uuid, ver: &Option<uuid::Uuid>, row: &tokio_postgres::Row,
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
