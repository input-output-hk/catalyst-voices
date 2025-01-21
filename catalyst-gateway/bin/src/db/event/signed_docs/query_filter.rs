//! `DocsQueryFilter` struct implementation.

use std::fmt::Display;

/// Search either by a singe UUID, or a Range of UUIDs
#[derive(Clone, Debug, PartialEq)]
#[allow(dead_code)]
pub(crate) enum EqOrRangedUuid {
    /// Search by the exact UUID
    Eq(uuid::Uuid),
    /// Search in this UUID's range
    Range {
        /// Minimum UUID to find (inclusive)
        min: uuid::Uuid,
        /// Maximum UUID to find (inclusive)
        max: uuid::Uuid,
    },
}

impl EqOrRangedUuid {
    /// Return a sql conditional statement by the provided `table_field`
    pub(crate) fn conditional_stmt(&self, table_field: &str) -> String {
        match self {
            Self::Eq(id) => format!("{table_field} == {id}"),
            Self::Range { min, max } => {
                format!("{table_field} >= {min} AND {table_field} <= {max}")
            },
        }
    }
}

/// A `select_signed_docs` query filtering argument.
#[allow(dead_code)]
pub(crate) struct DocsQueryFilter {
    /// document id
    pub(crate) id: Option<EqOrRangedUuid>,
}

impl Display for DocsQueryFilter {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        use std::fmt::Write;
        let mut query = "TRUE".to_string();
        if let Some(id) = &self.id {
            write!(&mut query, " AND {}", id.conditional_stmt("signed_doc.id"))?;
        }
        write!(f, "{query}")
    }
}
