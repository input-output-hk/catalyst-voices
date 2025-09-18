//! `EqOrRangedUuid` query conditional stmt object.

/// Search either by a singe UUID, or a Range of UUIDs
#[derive(Clone, Debug, PartialEq)]
pub(crate) enum EqOrRangedUuid {
    /// Search by the exact UUIDs from the list
    Eq(Vec<uuid::Uuid>),
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
            Self::Eq(ids) if ids.is_empty() => "TRUE".to_string(),
            Self::Eq(ids) => {
                format!(
                    "{table_field} in ({})",
                    ids.iter()
                        .map(ToString::to_string)
                        .collect::<Vec<_>>()
                        .join(",")
                )
            },
            Self::Range { min, max } => {
                format!("{table_field} >= '{min}' AND {table_field} <= '{max}'")
            },
        }
    }
}
