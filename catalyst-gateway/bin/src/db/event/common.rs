//! Reusable common database objects

#![allow(dead_code)]

/// A query `LIMIT` and `OFFSET` limits.
pub(crate) enum QueryLimits {
    /// Return all entries without any `LIMIT` and `OFFSET` parameters
    All,
    /// Specifies `LIMIT` parameter equals to `1`
    One,
    /// Specifies `LIMIT` parameter
    Limit(u64),
    /// Specifies `LIMIT` and `OFFSET` parameters
    LimitAndOffset(u64, u64),
}

impl QueryLimits {
    /// Returns a string with the corresponding query limit statement
    pub(crate) fn query_stmt(&self) -> String {
        match self {
            Self::All => String::new(),
            Self::One => "LIMIT 1".to_string(),
            Self::Limit(limit) => format!("LIMIT {limit}"),
            Self::LimitAndOffset(limit, offset) => format!("LIMIT {limit} OFFSET {offset}"),
        }
    }
}
