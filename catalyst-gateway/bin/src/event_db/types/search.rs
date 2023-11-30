//! Search Queries
use super::{event::EventSummary, objective::ObjectiveSummary, proposal::ProposalSummary};

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// The Table to search
pub(crate) enum SearchTable {
    /// Search for events
    #[allow(dead_code)]
    Events,
    /// Search for objectives
    #[allow(dead_code)]
    Objectives,
    /// Search for proposals
    #[allow(dead_code)]
    Proposals,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// The column to search
pub(crate) enum SearchColumn {
    /// Search for the Title
    #[allow(dead_code)]
    Title,
    /// Search for the Type
    #[allow(dead_code)]
    Type,
    /// Search for the Description
    #[allow(dead_code)]
    Description,
    /// Search for the Author
    #[allow(dead_code)]
    Author,
    /// Search for the Funds
    #[allow(dead_code)]
    Funds,
}

impl ToString for SearchColumn {
    fn to_string(&self) -> String {
        match self {
            SearchColumn::Title => "title".to_string(),
            SearchColumn::Type => "type".to_string(),
            SearchColumn::Description => "description".to_string(),
            SearchColumn::Author => "author".to_string(),
            SearchColumn::Funds => "funds".to_string(),
        }
    }
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]

/// The constraint to the search
pub(crate) struct SearchConstraint {
    /// Column to search
    pub(crate) column: SearchColumn,
    /// Value to search
    pub(crate) search: String,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Results to be ordered
pub(crate) struct SearchOrderBy {
    /// Column to order
    pub(crate) column: SearchColumn,
    /// Ascending or descending
    pub(crate) descending: bool,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// The search query
pub(crate) struct SearchQuery {
    /// Table to search
    pub(crate) table: SearchTable,
    /// Constraints to filter the search
    pub(crate) filter: Vec<SearchConstraint>,
    /// How to order the results
    pub(crate) order_by: Vec<SearchOrderBy>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// The Value results
pub(crate) enum ValueResults {
    /// Events found
    Events(Vec<EventSummary>),
    /// Objectives found
    Objectives(Vec<ObjectiveSummary>),
    /// Proposals found
    Proposals(Vec<ProposalSummary>),
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
/// Full search results
pub(crate) struct SearchResult {
    /// Total number of results
    pub(crate) total: i64,
    /// Results
    pub(crate) results: Option<ValueResults>,
}
