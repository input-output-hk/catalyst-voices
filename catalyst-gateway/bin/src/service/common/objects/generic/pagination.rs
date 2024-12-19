//! Pagination response object to be included in every paged response.

use poem_openapi::{types::Example, Object};

use crate::service::common;

/// Description for the `CurrentPage` object.
#[allow(dead_code)]
pub(crate) const CURRENT_PAGE_DESCRIPTION: &str =
    "The Page of results is being returned, and the Limit of results.
The data returned is constrained by this limit.
The limit applies to the total number of records returned.
*Note: The Limit may not be exactly as requested, if it was constrained by the response.
The caller must read this record to ensure the correct data requested was returned.*";

#[derive(Object)]
#[oai(example = true)]
/// Current Page of data being returned.
pub(crate) struct CurrentPage {
    #[allow(clippy::missing_docs_in_private_items)] // Type is pre documented
    pub page: common::types::generic::query::pagination::Page,
    #[allow(clippy::missing_docs_in_private_items)] // Type is pre documented
    pub limit: common::types::generic::query::pagination::Limit,
    #[allow(clippy::missing_docs_in_private_items)] // Type is pre documented
    pub remaining: common::types::generic::query::pagination::Remaining,
}

impl Example for CurrentPage {
    fn example() -> Self {
        Self {
            page: common::types::generic::query::pagination::Page::example(),
            limit: common::types::generic::query::pagination::Limit::example(),
            remaining: common::types::generic::query::pagination::Remaining::example(),
        }
    }
}

impl CurrentPage {
    /// Create a new `CurrentPage` object.
    ///
    /// # Errors
    ///  - Invalid `page` value, must be in range
    ///  - Invalid `limit` value, must be in range
    ///  - Invalid `remaining` value, must be in range
    #[allow(dead_code)]
    fn new(page: u64, limit: u64, remaining: u64) -> anyhow::Result<Self> {
        Ok(Self {
            page: page.try_into()?,
            limit: limit.try_into()?,
            remaining: remaining.try_into()?,
        })
    }
}
