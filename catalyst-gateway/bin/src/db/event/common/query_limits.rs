//! `QueryLimits` query argument object.

#![allow(dead_code)]

use std::fmt::Display;

use crate::service::common::types::generic::query::pagination::{Limit, Page};

/// A query limits struct.
pub(crate) struct QueryLimits(QueryLimitsInner);

/// `QueryLimits` inner enum representation.
enum QueryLimitsInner {
    /// Return all entries without any `LIMIT` and `OFFSET` parameters
    All,
    /// Specifies `LIMIT` parameter
    Limit(u64),
    /// Specifies `LIMIT` and `OFFSET` parameters
    LimitAndOffset(u64, u64),
}

impl Display for QueryLimits {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.0 {
            QueryLimitsInner::All => write!(f, ""),
            QueryLimitsInner::Limit(limit) => write!(f, "LIMIT {limit}"),
            QueryLimitsInner::LimitAndOffset(limit, offset) => {
                write!(f, "LIMIT {limit} OFFSET {offset}")
            },
        }
    }
}

impl QueryLimits {
    /// Create a `QueryLimits` object without the any limits.
    pub(crate) const ALL: QueryLimits = Self(QueryLimitsInner::All);
    /// Create a `QueryLimits` object with the limit equals to `1`.
    pub(crate) const ONE: QueryLimits = Self(QueryLimitsInner::Limit(1));

    /// Create a `QueryLimits` object from the service `Limit` and `Page` values.
    ///
    /// # Errors
    ///  - Invalid `limit` value, must be more than `0`.
    ///  - Invalid arguments, `limit` must be provided when `page` is not None.
    pub(crate) fn new(limit: Option<Limit>, page: Option<Page>) -> anyhow::Result<Self> {
        match (limit, page) {
            (Some(limit), Some(page)) => {
                Ok(Self(QueryLimitsInner::LimitAndOffset(
                    limit.into(),
                    page.into(),
                )))
            },
            (Some(limit), None) => Ok(Self(QueryLimitsInner::Limit(limit.into()))),
            (None, None) => Ok(Self(QueryLimitsInner::All)),
            (None, Some(_)) => {
                anyhow::bail!("Invalid arguments, `limit` must be provided when `page` is not None")
            },
        }
    }
}
