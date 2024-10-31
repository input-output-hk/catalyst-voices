//! Frontend configuration objects.

use poem_openapi::{types::Example, Object};

/// Search query object.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct SearchQuery {
    /// Table to search.
    table: SearchConstraint,
    /// Constraints to filter the search
    filter: Option<Vec<SearchConstraint>>,
    /// How to order the results
    order_by: Option<Vec<SearchOrderBy>>,
    /// Sets the limit clause of the search query.
    limit: Option<i32>,
    /// Sets the offset clause of the search query.
    offset: Option<i32>,
}

impl Example for SearchQuery {
    fn example() -> Self {
        Self {
            table: SearchConstraint::example(),
            filter: Some(vec![SearchConstraint::example()]),
            order_by: Some(vec![SearchOrderBy::example()]),
            limit: Some(10),
            offset: Some(0),
        }
    }
}

/// Search contraint object.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct SearchConstraint {
    /// Column to search.
    column: SearchColumn,
    /// Text which must be present in the given column (case insensitive)
    search: String,
}

impl Example for SearchConstraint {
    fn example() -> Self {
        Self {
            column: SearchColumn::Title,
            search: "example".to_string(),
        }
    }
}

/// Search order by object.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct SearchOrderBy {
    column: SearchColumn,
    #[oai(default)]
    descending: Option<bool>,
}

impl Example for SearchOrderBy {
    fn example() -> Self {
        Self {
            column: SearchColumn::Title,
            descending: Some(false),
        }
    }
}

#[derive(poem_openapi::Enum)]
pub(crate) enum SearchColumn {
    Title,
    Type,
    Desc,
    Author,
    Funds,
}
