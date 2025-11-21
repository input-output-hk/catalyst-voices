//! `EqOrRangedUuid` query conditional stmt object.

use crate::db::event::common::{ConditionalStmt, uuid_list::UuidList};

/// Search either by a singe UUID, a range of UUIDs or a list of UUIDs.
#[derive(Clone, Debug, PartialEq)]
pub(crate) enum UuidSelector {
    /// Search by the exact UUID
    Eq(uuid::Uuid),
    /// Search in this UUID's range
    Range {
        /// Minimum UUID to find (inclusive)
        min: uuid::Uuid,
        /// Maximum UUID to find (inclusive)
        max: uuid::Uuid,
    },
    /// Search UUIDs in the given list.
    In(UuidList),
}

impl ConditionalStmt for UuidSelector {
    fn conditional_stmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        table_field: &str,
    ) -> std::fmt::Result {
        match self {
            Self::Eq(id) => write!(f, "{table_field} = '{id}'"),
            Self::Range { min, max } => {
                write!(f, "{table_field} >= '{min}' AND {table_field} <= '{max}'")
            },
            Self::In(ids) => ids.conditional_stmt(f, table_field),
        }
    }
}
