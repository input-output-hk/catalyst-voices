//! `FullSignedDoc` struct implementation.

use super::SignedDocBody;
use crate::{
    db::event::EventDB,
    jinja::{JinjaTemplateSource, get_template},
};

/// Insert sql query
const INSERT_SIGNED_DOCS: &str = include_str!("./sql/insert_signed_documents.sql");

/// Select sql query jinja template
pub(crate) const SELECT_SIGNED_DOCS_TEMPLATE: JinjaTemplateSource = JinjaTemplateSource {
    name: "select_signed_documents.jinja.template",
    source: include_str!("./sql/select_signed_documents.sql.jinja"),
};

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

impl TryFrom<&catalyst_signed_doc::CatalystSignedDocument> for FullSignedDoc {
    type Error = anyhow::Error;

    fn try_from(doc: &catalyst_signed_doc::CatalystSignedDocument) -> Result<Self, Self::Error> {
        let authors = doc
            .authors()
            .iter()
            .map(|v| v.as_short_id().to_string())
            .collect();

        let doc_meta_json = doc.doc_meta().to_json()?;

        let payload = if matches!(
            doc.doc_content_type(),
            Some(catalyst_signed_doc::ContentType::Json)
        ) {
            match serde_json::from_slice(doc.decoded_content()?.as_slice()) {
                Ok(payload) => Some(payload),
                Err(e) => {
                    anyhow::bail!("Invalid Document Content, not Json encoded: {e}");
                },
            }
        } else {
            None
        };

        let doc_body = SignedDocBody::new(
            doc.doc_id()?.into(),
            doc.doc_ver()?.into(),
            doc.doc_type()?.uuid(),
            authors,
            Some(doc_meta_json),
        );
        let doc_bytes = doc.to_bytes()?;

        Ok(FullSignedDoc::new(doc_body, payload, doc_bytes))
    }
}

impl FullSignedDoc {
    /// Creates a  `FullSignedDoc` instance.
    pub(crate) fn new(
        body: SignedDocBody,
        payload: Option<serde_json::Value>,
        raw: Vec<u8>,
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

    /// Returns the document metadata.
    #[allow(dead_code)]
    pub(crate) fn metadata(&self) -> Option<&serde_json::Value> {
        self.body.metadata()
    }

    /// Returns the `SignedDocBody`.
    #[allow(dead_code)]
    pub(crate) fn body(&self) -> &SignedDocBody {
        &self.body
    }

    /// Returns the document raw bytes.
    pub(crate) fn raw(&self) -> &[u8] {
        &self.raw
    }

    /// Uploads a `FullSignedDoc` to the event db.
    ///
    /// Make an insert query into the `event-db` by adding data into the `signed_docs`
    /// table.
    ///
    /// * IF the record primary key (id,ver) does not exist, then add the new record.
    ///   Return success.
    /// * Otherwise return an error. (Can not over-write an existing record with new
    ///   data).
    ///
    /// # Arguments:
    ///  - `id` is a UUID v7
    ///  - `ver` is a UUID v7
    ///  - `doc_type` is a UUID v4
    pub(crate) async fn store(&self) -> anyhow::Result<()> {
        // Perform insert before checking if the document already exists.
        // This should prevent race condition.
        match EventDB::modify(INSERT_SIGNED_DOCS, &self.postgres_db_fields()).await {
            // Able to insert, no conflict
            Ok(()) => Ok(()),
            Err(e) => Err(e),
        }
    }

    /// Loads a `FullSignedDoc` from the event db.
    ///
    /// Make a select query into the `event-db` by getting data from the `signed_docs`
    /// table.
    ///
    /// * This returns a single document. All data from the document is returned,
    ///   including the `payload` and `raw` fields.
    /// * `ver` should be able to be optional, in which case get the latest ver of the
    ///   given `id`.
    ///
    /// # Arguments:
    ///  - `id` is a UUID v7
    ///  - `ver` is a UUID v7
    pub(crate) async fn retrieve(
        id: &uuid::Uuid,
        ver: Option<&uuid::Uuid>,
    ) -> anyhow::Result<Self> {
        let query_template = get_template(&SELECT_SIGNED_DOCS_TEMPLATE)?;
        let query = query_template.render(serde_json::json!({
            "id": id,
            "ver": ver,
        }))?;
        let row = EventDB::query_one(&query, &[]).await?;

        Self::from_row(id, ver, &row)
    }

    /// Returns all signed document fields for the event db queries
    fn postgres_db_fields(&self) -> [&(dyn tokio_postgres::types::ToSql + Sync); 7] {
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
    fn from_row(
        id: &uuid::Uuid,
        ver: Option<&uuid::Uuid>,
        row: &tokio_postgres::Row,
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
                row.try_get("authors")?,
                row.try_get("metadata")?,
            ),
            payload: row.try_get("payload")?,
            raw: row.try_get("raw")?,
        })
    }
}
