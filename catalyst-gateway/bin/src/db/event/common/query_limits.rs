//! `QueryLimits` query argument object.

use std::fmt::Display;

use crate::service::common::types::generic::query::pagination::{Limit, Page};

/// A query limits struct.
pub(crate) struct QueryLimits(QueryLimitsInner);

/// `QueryLimits` inner enum representation.
enum QueryLimitsInner {
    /// Return all entries without any `LIMIT` and `OFFSET` parameters
    All,
    /// Specifies `LIMIT` parameter
    Limit(u32),
    /// Specifies `LIMIT` and `OFFSET` parameters
    LimitAndOffset(u32, u32),
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
    #[allow(dead_code)]
    pub(crate) const ALL: QueryLimits = Self(QueryLimitsInner::All);
    /// Create a `QueryLimits` object with the limit equals to `1`.
    #[allow(dead_code)]
    pub(crate) const ONE: QueryLimits = Self(QueryLimitsInner::Limit(1));

    /// Create a `QueryLimits` object from the service `Limit` and `Page` values.
    pub(crate) fn new(limit: Option<Limit>, page: Option<Page>) -> Self {
        match (limit, page) {
            (Some(limit), Some(page)) => {
                Self(QueryLimitsInner::LimitAndOffset(
                    limit.into(),
                    cal_offset(limit.into(), page.into()),
                ))
            },
            (Some(limit), None) => {
                Self(QueryLimitsInner::LimitAndOffset(
                    limit.into(),
                    Page::default().into(),
                ))
            },
            (None, Some(page)) => {
                let limit = Limit::default();

                Self(QueryLimitsInner::LimitAndOffset(
                    limit.into(),
                    cal_offset(limit.into(), page.into()),
                ))
            },
            (None, None) => {
                Self(QueryLimitsInner::LimitAndOffset(
                    Limit::default().into(),
                    Page::default().into(),
                ))
            },
        }
    }
}

/// Calculate the offset value from page and limit.
/// offset = limit * page
fn cal_offset(page: u32, limit: u32) -> u32 {
    limit.saturating_mul(page)
}
