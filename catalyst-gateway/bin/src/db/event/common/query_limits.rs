//! `QueryLimits` query argument object.

#![allow(dead_code)]

use anyhow::ensure;

use crate::service::common::types::generic::query::pagination::{Limit, Page};

/// A query limits struct.
pub(crate) struct QueryLimits(QueryLimitsInner);

/// `QueryLimits` inner enum representation.
enum QueryLimitsInner {
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
    /// Create a `QueryLimits` object from the service `Limit` and `Page` values.
    ///
    /// # Errors
    ///  - Invalid `limit` value, must be more than `0`.
    ///  - Invalid arguments, `limit` must be provided when `page` is not None.
    pub(crate) fn new(limit: Option<Limit>, page: Option<Page>) -> anyhow::Result<Self> {
        if let Some(limit) = limit {
            let limit = limit.into();
            ensure!(
                limit != 0_u64,
                "Invalid `limit` value, must be more than `0`"
            );

            if let Some(page) = page {
                Ok(Self(QueryLimitsInner::LimitAndOffset(limit, page.into())))
            } else if limit == 1_u64 {
                Ok(Self(QueryLimitsInner::One))
            } else {
                Ok(Self(QueryLimitsInner::Limit(limit)))
            }
        } else if page.is_none() {
            Ok(Self(QueryLimitsInner::All))
        } else {
            anyhow::bail!("Invalid arguments, `limit` must be provided when `page` is not None")
        }
    }

    /// Create a `QueryLimits` object with the limit equals to `1`.
    pub(crate) fn new_one() -> Self {
        Self(QueryLimitsInner::One)
    }

    /// Create a `QueryLimits` object without the any limits.
    pub(crate) fn new_all() -> Self {
        Self(QueryLimitsInner::All)
    }

    /// Returns a string with the corresponding query limit statement
    pub(crate) fn query_stmt(&self) -> String {
        match self.0 {
            QueryLimitsInner::All => String::new(),
            QueryLimitsInner::One => "LIMIT 1".to_string(),
            QueryLimitsInner::Limit(limit) => format!("LIMIT {limit}"),
            QueryLimitsInner::LimitAndOffset(limit, offset) => {
                format!("LIMIT {limit} OFFSET {offset}")
            },
        }
    }
}
