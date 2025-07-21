//! `ArrayQueryUuid` query builder for UUID array rows.

/// Represents a PostgreSQL array query operation.
///
/// Useful for generating SQL query fragments for array comparisons,
/// such as `@>`, `&&`, and `= '{}'`.
#[allow(dead_code)]
#[derive(Clone, Debug, PartialEq)]
pub enum ArrayQueryUuid {
    /// Matches arrays that are exactly equal to the given array.
    /// The order and length must match exactly.
    ///
    /// Corresponds to `= ARRAY[...]` in SQL.
    Equals(Vec<uuid::Uuid>),

    /// Matches arrays that contain the given element.
    ///
    /// Corresponds to `@> ARRAY[elem]` in SQL.
    Has(uuid::Uuid),

    /// Matches arrays that contain *every* element in the given array.
    ///
    /// Corresponds to `@> ARRAY[...]` in SQL.
    HasEvery(Vec<uuid::Uuid>),

    /// Matches arrays that contain *at least one* element from the given array.
    ///
    /// Corresponds to `&& ARRAY[...]` in SQL.
    HasSome(Vec<uuid::Uuid>),

    /// Matches arrays that are completely empty.
    ///
    /// Corresponds to `= '{}'` in SQL.
    IsEmpty,
}

impl ArrayQueryUuid {
    /// Return a sql conditional statement by the provided `table_field`
    pub(crate) fn conditional_stmt(&self, table_field: &str) -> String {
        match self {
            ArrayQueryUuid::Equals(values) => {
                format!(
                    "{table_field} = ARRAY[{}]::uuid[]",
                    display_uuid_vec(values),
                )
            },
            ArrayQueryUuid::Has(value) => {
                format!(
                    "{table_field} @> ARRAY[{}]::uuid[]",
                    display_uuid_vec(&[value.clone()]),
                )
            },
            ArrayQueryUuid::HasEvery(values) => {
                format!(
                    "{table_field} @> ARRAY[{}]::uuid[]",
                    display_uuid_vec(values),
                )
            },
            ArrayQueryUuid::HasSome(values) => {
                format!(
                    "{table_field} && ARRAY[{}]::uuid[]",
                    display_uuid_vec(values),
                )
            },
            ArrayQueryUuid::IsEmpty => {
                format!("{table_field} = ARRAY[]::uuid[]")
            },
        }
    }
}

/// Helper to join values with comma for SQL ARRAY display
fn display_uuid_vec(values: &[uuid::Uuid]) -> String {
    values
        .iter()
        .map(|v| format!("'{}'", v))
        .collect::<Vec<String>>()
        .join(", ")
}
