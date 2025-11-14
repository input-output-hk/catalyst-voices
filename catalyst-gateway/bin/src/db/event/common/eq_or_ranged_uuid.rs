//! `EqOrRangedUuid` query conditional stmt object.

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
    In(Vec<uuid::Uuid>),
}

impl UuidSelector {
    /// Return a sql conditional statement by the provided `table_field`
    pub(crate) fn conditional_stmt(
        &self,
        table_field: &str,
    ) -> String {
        match self {
            Self::Eq(id) => format!("{table_field} = '{id}'"),
            Self::Range { min, max } => {
                format!("{table_field} >= '{min}' AND {table_field} <= '{max}'")
            },
            Self::In(ids) => {
                itertools::intersperse(
                    ids.iter().map(|id| format!("{table_field} = '{id}'")),
                    " OR ".to_string(),
                )
                .collect()
            },
        }
    }
}
