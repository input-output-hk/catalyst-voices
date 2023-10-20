use super::{event::EventSummary, objective::ObjectiveSummary, proposal::ProposalSummary};

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) enum SearchTable {
    Events,
    Objectives,
    Proposals,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) enum SearchColumn {
    Title,
    Type,
    Description,
    Author,
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

pub(crate) struct SearchConstraint {
    pub(crate) column: SearchColumn,
    pub(crate) search: String,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct SearchOrderBy {
    pub(crate) column: SearchColumn,
    pub(crate) descending: bool,
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct SearchQuery {
    pub(crate) table: SearchTable,
    pub(crate) filter: Vec<SearchConstraint>,
    pub(crate) order_by: Vec<SearchOrderBy>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) enum ValueResults {
    Events(Vec<EventSummary>),
    Objectives(Vec<ObjectiveSummary>),
    Proposals(Vec<ProposalSummary>),
}

#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct SearchResult {
    pub(crate) total: i64,
    pub(crate) results: Option<ValueResults>,
}
