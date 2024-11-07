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
    /// The current `page` of data being returned.
    pub page: common::types::generic::query::pagination::Page,
    /// The current `limit` of data being returned per page.
    /// This `limit` may be less than requested if the response does not support the
    /// requested `limit`.
    pub limit: common::types::generic::query::pagination::Limit,
    /// Is this the final page?
    #[oai(
        rename = "final",
        default = "final_default",
        skip_serializing_if = "not_final"
    )]
    pub final_page: bool,
}

/// Default value to assign to `final` in response.
fn final_default() -> bool {
    false
}

/// Don't encode final, if its not final.
#[allow(clippy::trivially_copy_pass_by_ref)] // Poem requires this.
fn not_final(final_page: &bool) -> bool {
    !final_page
}

impl Example for CurrentPage {
    fn example() -> Self {
        Self {
            page: common::types::generic::query::pagination::Page::example(),
            limit: common::types::generic::query::pagination::Limit::example(),
            final_page: true,
        }
    }
}

impl CurrentPage {
    /// Create a new `CurrentPage` object.
    #[allow(dead_code)]
    fn new(
        page: common::types::generic::query::pagination::Page,
        limit: common::types::generic::query::pagination::Limit, final_page: bool,
    ) -> Self {
        Self {
            page,
            limit,
            final_page,
        }
    }
}
