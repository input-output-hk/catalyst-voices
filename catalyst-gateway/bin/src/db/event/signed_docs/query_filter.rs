//! `DocsQueryFilter` struct implementation.

use std::fmt::Display;

use super::DocumentRef;
use crate::db::event::common::eq_or_ranged_uuid::EqOrRangedUuid;

/// A `select_signed_docs` query filtering argument.
/// If all fields would be `None` the query will search for all entries from the db.
#[derive(Clone, Debug, Default)]
pub(crate) struct DocsQueryFilter {
    /// `type` field
    doc_type: Option<uuid::Uuid>,
    /// `id` field
    id: Option<EqOrRangedUuid>,
    /// `ver` field
    ver: Option<EqOrRangedUuid>,
    /// `metadata->'ref'` field
    doc_ref: Option<DocumentRef>,
    /// `metadata->'template'` field
    template: Option<DocumentRef>,
    /// `metadata->'reply'` field
    reply: Option<DocumentRef>,
}

impl Display for DocsQueryFilter {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        use std::fmt::Write;
        let mut query = "TRUE".to_string();

        if let Some(doc_type) = &self.doc_type {
            write!(&mut query, " AND signed_docs.type = '{doc_type}'")?;
        }

        if let Some(id) = &self.id {
            write!(&mut query, " AND {}", id.conditional_stmt("signed_docs.id"))?;
        }
        if let Some(ver) = &self.ver {
            write!(
                &mut query,
                " AND {}",
                ver.conditional_stmt("signed_docs.ver")
            )?;
        }
        if let Some(doc_ref) = &self.doc_ref {
            write!(
                &mut query,
                " AND {}",
                doc_ref.conditional_stmt("metadata->'ref'")
            )?;
        }
        if let Some(template) = &self.template {
            write!(
                &mut query,
                " AND {}",
                template.conditional_stmt("metadata->'template'")
            )?;
        }
        if let Some(reply) = &self.reply {
            write!(
                &mut query,
                " AND {}",
                reply.conditional_stmt("metadata->'reply'")
            )?;
        }

        write!(f, "{query}")
    }
}

impl DocsQueryFilter {
    /// Creates an empty filter stmt, so the query will retrieve all entries from the db.
    pub fn all() -> Self {
        DocsQueryFilter::default()
    }

    /// Set the `type` field filter condition
    pub fn with_type(self, doc_type: uuid::Uuid) -> Self {
        DocsQueryFilter {
            doc_type: Some(doc_type),
            ..self
        }
    }

    /// Set the `id` field filter condition
    pub fn with_id(self, id: EqOrRangedUuid) -> Self {
        DocsQueryFilter {
            id: Some(id),
            ..self
        }
    }

    /// Set the `ver` field filter condition
    pub fn with_ver(self, ver: EqOrRangedUuid) -> Self {
        DocsQueryFilter {
            ver: Some(ver),
            ..self
        }
    }

    /// Set the `metadata->'ref'` field filter condition
    pub fn with_ref(self, doc_ref: DocumentRef) -> Self {
        DocsQueryFilter {
            doc_ref: Some(doc_ref),
            ..self
        }
    }

    /// Set the `metadata->'template'` field filter condition
    pub fn with_template(self, template: DocumentRef) -> Self {
        DocsQueryFilter {
            template: Some(template),
            ..self
        }
    }

    /// Set the `metadata->'reply'` field filter condition
    pub fn with_reply(self, reply: DocumentRef) -> Self {
        DocsQueryFilter {
            reply: Some(reply),
            ..self
        }
    }
}
