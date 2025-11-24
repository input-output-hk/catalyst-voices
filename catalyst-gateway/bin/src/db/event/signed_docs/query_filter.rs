//! `DocsQueryFilter` struct implementation.

use std::fmt::Display;

use super::DocumentRef;
use crate::db::event::common::{ConditionalStmt, uuid_list::UuidList, uuid_selector::UuidSelector};

/// A `select_signed_docs` query filtering argument.
/// If all fields would be `None` the query will search for all entries from the db.
#[derive(Clone, Debug, Default)]
pub(crate) struct DocsQueryFilter {
    /// `type` field. Empty list if unspecified.
    doc_type: UuidList,
    /// `id` field. `None` if unspecified.
    id: Option<UuidSelector>,
    /// `ver` field. `None` if unspecified.
    ver: Option<UuidSelector>,
    /// `metadata->'ref'` field.
    doc_ref: Option<DocumentRef>,
    /// `metadata->'template'` field.
    template: Option<DocumentRef>,
    /// `metadata->'reply'` field.
    reply: Option<DocumentRef>,
    /// `metadata->'parameters'` field.
    parameters: Option<DocumentRef>,
}

impl Display for DocsQueryFilter {
    fn fmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
    ) -> std::fmt::Result {
        write!(f, "TRUE")?;

        let stmts: [(_, Option<&dyn ConditionalStmt>); _] = [
            (
                "signed_docs.type",
                (!self.doc_type.is_empty()).then_some(&self.doc_type),
            ),
            (
                "signed_docs.id",
                self.id.as_ref().map(|v| -> &dyn ConditionalStmt { v }),
            ),
            (
                "signed_docs.ver",
                self.ver.as_ref().map(|v| -> &dyn ConditionalStmt { v }),
            ),
            (
                "metadata->'ref'",
                self.doc_ref.as_ref().map(|v| -> &dyn ConditionalStmt { v }),
            ),
            (
                "metadata->'template'",
                self.template
                    .as_ref()
                    .map(|v| -> &dyn ConditionalStmt { v }),
            ),
            (
                "metadata->'reply'",
                self.reply.as_ref().map(|v| -> &dyn ConditionalStmt { v }),
            ),
            (
                "metadata->'parameters'",
                self.parameters
                    .as_ref()
                    .map(|v| -> &dyn ConditionalStmt { v }),
            ),
        ];

        for (field_name, stmt) in stmts {
            if let Some(stmt) = stmt {
                write!(f, " AND ",)?;
                stmt.conditional_stmt(f, field_name)?;
            }
        }

        Ok(())
    }
}

impl DocsQueryFilter {
    /// Creates an empty filter stmt, so the query will retrieve all entries from the db.
    pub fn all() -> Self {
        DocsQueryFilter::default()
    }

    /// Set the `type` field filter condition
    pub fn with_type(
        self,
        doc_type: Vec<uuid::Uuid>,
    ) -> Self {
        DocsQueryFilter {
            doc_type: doc_type.into(),
            ..self
        }
    }

    /// Set the `id` field filter condition
    pub fn with_id(
        self,
        id: UuidSelector,
    ) -> Self {
        DocsQueryFilter {
            id: Some(id),
            ..self
        }
    }

    /// Set the `ver` field filter condition
    pub fn with_ver(
        self,
        ver: UuidSelector,
    ) -> Self {
        DocsQueryFilter {
            ver: Some(ver),
            ..self
        }
    }

    /// Set the `metadata->'ref'` field filter condition
    pub fn with_ref(
        self,
        arg: DocumentRef,
    ) -> Self {
        DocsQueryFilter {
            doc_ref: Some(arg),
            ..self
        }
    }

    /// Set the `metadata->'template'` field filter condition
    pub fn with_template(
        self,
        arg: DocumentRef,
    ) -> Self {
        DocsQueryFilter {
            template: Some(arg),
            ..self
        }
    }

    /// Set the `metadata->'reply'` field filter condition
    pub fn with_reply(
        self,
        arg: DocumentRef,
    ) -> Self {
        DocsQueryFilter {
            reply: Some(arg),
            ..self
        }
    }

    /// Set the `metadata->'parameters'` field filter condition
    pub fn with_parameters(
        self,
        arg: DocumentRef,
    ) -> Self {
        DocsQueryFilter {
            parameters: Some(arg),
            ..self
        }
    }
}
