//! `FullSignedDoc` struct implementation.

use super::SignedDocBody;
use crate::{
    db::event::{EventDB, NotFoundError},
    jinja::{get_template, JinjaTemplateSource},
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

    /// Uploads a `FullSignedDoc` to the event db.
    /// Returns `true` if document was added into the db, `false` if it was already added
    /// previously.
    ///
    /// Make an insert query into the `event-db` by adding data into the `signed_docs`
    /// table.
    ///
    /// * IF the record primary key (id,ver) does not exist, then add the new record.
    ///   Return success.
    /// * IF the record does exist, but all values are the same as stored, return Success.
    /// * Otherwise return an error. (Can not over-write an existing record with new
    ///   data).
    ///
    /// # Arguments:
    ///  - `id` is a UUID v7
    ///  - `ver` is a UUID v7
    ///  - `doc_type` is a UUID v4
    #[allow(dead_code)]
    pub(crate) async fn store(&self) -> anyhow::Result<bool> {
        match Self::retrieve(self.id(), Some(self.ver())).await {
            Ok(res_doc) => {
                anyhow::ensure!(
                    &res_doc == self,
                    "Document with the same `id` and `ver` already exists"
                );
                Ok(false)
            },
            Err(err) if err.is::<NotFoundError>() => {
                EventDB::modify(INSERT_SIGNED_DOCS, &self.postgres_db_fields()).await?;
                Ok(false)
            },
            Err(err) => Err(err),
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
    #[allow(dead_code)]
    pub(crate) async fn retrieve(
        id: &uuid::Uuid, ver: Option<&uuid::Uuid>,
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
