//! `DocsQueryFilter` struct implementation.

use std::fmt::Display;

use crate::db::event::common::eq_or_ranged_uuid::EqOrRangedUuid;

/// A `select_signed_docs` query filtering argument.
/// If all fields would be `None` the query will search for all entiries from the db.
#[allow(dead_code)]
#[derive(Clone, Debug)]
pub(crate) struct DocsQueryFilter {
    /// `type` field
    doc_type: Option<uuid::Uuid>,
    /// `id` field
    id: Option<EqOrRangedUuid>,
    /// `ver` field
    ver: Option<EqOrRangedUuid>,
}

impl Display for DocsQueryFilter {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        use std::fmt::Write;
        let mut query = "TRUE".to_string();

        if let Some(doc_type) = &self.doc_type {
            write!(&mut query, " AND signed_docs.type == '{doc_type}'")?;
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
        write!(f, "{query}")
    }
}

impl DocsQueryFilter {
    /// Creates an empty filter stmt, so the query will retrieve all entries from the db.
    pub fn all() -> Self {
        DocsQueryFilter {
            doc_type: None,
            id: None,
            ver: None,
        }
    }

    /// Set the `type` field filter condition
    pub fn with_type(self, doc_type: uuid::Uuid) -> Self {
        DocsQueryFilter {
            doc_type: Some(doc_type),
            ..self
        }
    }

    /// Set the `type` field filter condition
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
}
