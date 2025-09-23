//! `EqOrRangedUuid` query conditional stmt object.

/// Search either by a singe UUID, or a Range of UUIDs
#[derive(Clone, Debug, PartialEq)]
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
    /// Search by inclusion from the list of UUIDs
    In(Vec<uuid::Uuid>),
}

impl EqOrRangedUuid {
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
            Self::In(ids) if ids.is_empty() => "TRUE".to_string(),
            Self::In(ids) => {
                format!(
                    "{table_field} in ({})",
                    ids.iter()
                        .map(|v| format!("'{v}'"))
                        .collect::<Vec<_>>()
                        .join(",")
                )
            },
        }
    }
}
