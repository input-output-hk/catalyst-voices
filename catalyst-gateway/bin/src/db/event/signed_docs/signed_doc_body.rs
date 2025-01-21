//! `SignedDocBody` struct implementation.

use futures::{Stream, StreamExt};

use super::DocsQueryFilter;
use crate::{
    db::event::{common::query_limits::QueryLimits, EventDB},
    jinja::{get_template, JinjaTemplateSource},
};

/// Filtered select sql query jinja template
pub(crate) const FILTERED_SELECT_SIGNED_DOCS_TEMPLATE: JinjaTemplateSource = JinjaTemplateSource {
    name: "filtered_select_signed_documents.jinja.template",
    source: include_str!("./sql/filtered_select_signed_documents.sql.jinja"),
};

/// Signed doc body event db struct
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct SignedDocBody {
    /// `signed_doc` table `id` field
    id: uuid::Uuid,
    /// `signed_doc` table `ver` field
    ver: uuid::Uuid,
    /// `signed_doc` table `type` field
    doc_type: uuid::Uuid,
    /// `signed_doc` table `authors` field
    authors: Vec<String>,
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

    /// Returns the document type.
    pub(crate) fn doc_type(&self) -> &uuid::Uuid {
        &self.doc_type
    }

    /// Returns the document authors.
    pub(crate) fn authors(&self) -> &Vec<String> {
        &self.authors
    }

    /// Returns the document metadata.
    pub(crate) fn metadata(&self) -> Option<&serde_json::Value> {
        self.metadata.as_ref()
    }

    /// Returns all signed document fields for the event db queries
    pub(crate) fn postgres_db_fields(&self) -> [&(dyn tokio_postgres::types::ToSql + Sync); 5] {
        [
            &self.id,
            &self.ver,
            &self.doc_type,
            &self.authors,
            &self.metadata,
        ]
    }

    /// Creates a  `SignedDocBody` instance.
    pub(crate) fn new(
        id: uuid::Uuid, ver: uuid::Uuid, doc_type: uuid::Uuid, authors: Vec<String>,
        metadata: Option<serde_json::Value>,
    ) -> Self {
        Self {
            id,
            ver,
            doc_type,
            authors,
            metadata,
        }
    }

    /// Loads a async stream of `SignedDocBody` from the event db.
    #[allow(dead_code)]
    pub(crate) async fn retrieve(
        conditions: &DocsQueryFilter, query_limits: &QueryLimits,
    ) -> anyhow::Result<impl Stream<Item = anyhow::Result<Self>>> {
        let query_template = get_template(&FILTERED_SELECT_SIGNED_DOCS_TEMPLATE)?;
        let query = query_template.render(serde_json::json!({
            "conditions": conditions.to_string(),
            "query_limits": query_limits.to_string(),
        }))?;
        println!("{query}");
        let rows = EventDB::query_stream(&query, &[]).await?;
        let docs = rows.map(|res_row| res_row.and_then(|row| SignedDocBody::from_row(&row)));
        Ok(docs)
    }

    /// Creates a  `SignedDocBody` from postgresql row object.
    fn from_row(row: &tokio_postgres::Row) -> anyhow::Result<Self> {
        let id = row.try_get("id")?;
        let ver = row.try_get("ver")?;
        let doc_type = row.try_get("type")?;
        let authors = row.try_get("authors")?;
        let metadata = row.try_get("metadata")?;
        Ok(Self {
            id,
            ver,
            doc_type,
            authors,
            metadata,
        })
    }
}
