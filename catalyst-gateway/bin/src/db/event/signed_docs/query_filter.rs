//! `DocsQueryFilter` struct implementation.

use std::fmt::Display;

use super::DocumentRef;
use crate::db::event::common::eq_or_ranged_uuid::EqOrRangedUuid;

/// A `select_signed_docs` query filtering argument.
/// If all fields would be `None` the query will search for all entries from the db.
#[derive(Clone, Debug, Default)]
pub(crate) struct DocsQueryFilter {
    /// `type` field. Empty list if unspecified.
    doc_type: Vec<uuid::Uuid>,
    /// `id` field
    id: Option<EqOrRangedUuid>,
    /// `ver` field
    ver: Option<EqOrRangedUuid>,
    /// `metadata->'ref'` field. Empty list if unspecified.
    doc_ref: Vec<DocumentRef>,
    /// `metadata->'template'` field. Empty list if unspecified.
    template: Vec<DocumentRef>,
    /// `metadata->'reply'` field. Empty list if unspecified.
    reply: Vec<DocumentRef>,
    /// `metadata->'parameters'` field. Empty list if unspecified.
    parameters: Vec<DocumentRef>,
}

impl Display for DocsQueryFilter {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        use std::fmt::Write;
        let mut query = "TRUE".to_string();

        if !self.doc_type.is_empty() {
            write!(
                &mut query,
                " AND signed_docs.type IN ({})",
                self.doc_type
                    .iter()
                    .map(|uuid| format!("'{uuid}'"))
                    .collect::<Vec<_>>()
                    .join(",")
            )?;
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
        let doc_ref_queries = [
            ("ref", &self.doc_ref),
            ("template", &self.template),
            ("reply", &self.reply),
            ("parameters", &self.parameters),
        ];

        for (field_name, doc_refs) in doc_ref_queries {
            if !doc_refs.is_empty() {
                let stmt = doc_refs
                    .iter()
                    .map(|doc_ref| doc_ref.conditional_stmt(&format!("metadata->'{field_name}'")))
                    .collect::<Vec<_>>()
                    .join(" OR ");

                write!(&mut query, " AND ({stmt})")?;
            }
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
    pub fn with_type(self, doc_type: Vec<uuid::Uuid>) -> Self {
        DocsQueryFilter { doc_type, ..self }
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
    pub fn with_ref(self, arg: DocumentRef) -> Self {
        let mut doc_ref = self.doc_ref;
        doc_ref.push(arg);

        DocsQueryFilter { doc_ref, ..self }
    }

    /// Set the `metadata->'template'` field filter condition
    pub fn with_template(self, arg: DocumentRef) -> Self {
        let mut template = self.template;
        template.push(arg);

        DocsQueryFilter { template, ..self }
    }

    /// Set the `metadata->'reply'` field filter condition
    pub fn with_reply(self, arg: DocumentRef) -> Self {
        let mut reply = self.reply;
        reply.push(arg);

        DocsQueryFilter { reply, ..self }
    }

    /// Set the `metadata->'parameters'` field filter condition
    pub fn with_parameters(self, arg: DocumentRef) -> Self {
        let mut parameters = self.parameters;
        parameters.push(arg);

        DocsQueryFilter { parameters, ..self }
    }
}
