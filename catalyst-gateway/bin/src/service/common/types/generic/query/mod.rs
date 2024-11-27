//! Generic Query ONLY parameters.

pub(crate) mod pagination;

// To add pagination to an endpoint add these two lines to the parameters:
//
// ```
//        #[doc = common::types::generic::query::pagination::PAGE_DESCRIPTION]
//        page: Query<Option<common::types::generic::query::pagination::Page>>,
//        #[doc = common::types::generic::query::pagination::LIMIT_DESCRIPTION]
//        limit: Query<Option<common::types::generic::query::pagination::Limit>>
// ```
