//! Search Queries
use chrono::{NaiveDateTime, Utc};

use crate::db::event::{
    error::NotFoundError,
    legacy::types::{
        event::{EventId, EventSummary},
        objective::{ObjectiveId, ObjectiveSummary, ObjectiveType},
        proposal::{ProposalId, ProposalSummary},
        search::{
            SearchConstraint, SearchOrderBy, SearchQuery, SearchResult, SearchTable, ValueResults,
        },
    },
    EventDB,
};

impl EventDB {
    /// Search for events query template
    const SEARCH_EVENTS_QUERY: &'static str =
        "SELECT event.row_id, event.name, event.start_time, event.end_time, snapshot.last_updated
        FROM event
        LEFT JOIN snapshot ON event.row_id = snapshot.event";
    /// Search for objectives query template
    const SEARCH_OBJECTIVES_QUERY: &'static str =
        "SELECT objective.id, objective.title, objective.description, objective.deleted, objective_category.name, objective_category.description as objective_category_description
        FROM objective
        INNER JOIN objective_category on objective.category = objective_category.name";
    /// Search for proposals query template
    const SEARCH_PROPOSALS_QUERY: &'static str =
        "SELECT DISTINCT proposal.id, proposal.title, proposal.summary, proposal.deleted
        FROM proposal";

    /// Build a where clause
    fn build_where_clause(table: &str, filter: &[SearchConstraint]) -> String {
        let mut where_clause = String::new();
        let mut filter_iter = filter.iter();
        if let Some(filter) = filter_iter.next() {
            where_clause.push_str(
                format!(
                    "WHERE {0}.{1} LIKE '%{2}%'",
                    table, filter.column, filter.search
                )
                .as_str(),
            );
            for filter in filter_iter {
                where_clause.push_str(
                    format!(
                        "AND {0}.{1} LIKE '%{2}%'",
                        table, filter.column, filter.search
                    )
                    .as_str(),
                );
            }
        }
        where_clause
    }

    /// Build an order by clause
    fn build_order_by_clause(table: &str, order_by: &[SearchOrderBy]) -> String {
        let mut order_by_clause = String::new();
        let mut order_by_iter = order_by.iter();
        if let Some(order_by) = order_by_iter.next() {
            let order_type = if order_by.descending { "DESC" } else { "ASC" };
            order_by_clause.push_str(
                format!("ORDER BY {0}.{1} {2}", table, order_by.column, order_type).as_str(),
            );
            for order_by in order_by_iter {
                let order_type = if order_by.descending { "DESC" } else { "ASC" };
                order_by_clause.push_str(
                    format!(", {0}.{1} LIKE '%{2}%'", table, order_by.column, order_type).as_str(),
                );
            }
        }
        order_by_clause
    }

    /// Construct a search query
    fn construct_query(search_query: &SearchQuery) -> String {
        let (query, table) = match search_query.table {
            SearchTable::Events => (Self::SEARCH_EVENTS_QUERY, "event"),
            SearchTable::Objectives => (Self::SEARCH_OBJECTIVES_QUERY, "objective"),
            SearchTable::Proposals => (Self::SEARCH_PROPOSALS_QUERY, "proposal"),
        };
        format!(
            "{0} {1} {2} LIMIT $1 OFFSET $2;",
            query,
            Self::build_where_clause(table, &search_query.filter),
            Self::build_order_by_clause(table, &search_query.order_by),
        )
    }

    /// Construct a count query
    fn construct_count_query(search_query: &SearchQuery) -> String {
        let (query, table) = match search_query.table {
            SearchTable::Events => (Self::SEARCH_EVENTS_QUERY, "event"),
            SearchTable::Objectives => (Self::SEARCH_OBJECTIVES_QUERY, "objective"),
            SearchTable::Proposals => (Self::SEARCH_PROPOSALS_QUERY, "proposal"),
        };
        format!(
            "SELECT COUNT(*) as total FROM ({0} {1} LIMIT $1 OFFSET $2) as result;",
            query,
            Self::build_where_clause(table, &search_query.filter),
        )
    }

    /// Search for a total.
    async fn search_total(
        search_query: SearchQuery, limit: Option<i64>, offset: Option<i64>,
    ) -> anyhow::Result<SearchResult> {
        let rows: Vec<tokio_postgres::Row> =
            Self::query(&Self::construct_count_query(&search_query), &[
                &limit,
                &offset.unwrap_or(0),
            ])
            .await
            .map_err(|_| NotFoundError)?;
        let row = rows.first().ok_or(NotFoundError)?;

        Ok(SearchResult {
            total: row.try_get("total")?,
            results: None,
        })
    }

    /// Search for events
    async fn search_events(
        search_query: SearchQuery, limit: Option<i64>, offset: Option<i64>,
    ) -> anyhow::Result<SearchResult> {
        let rows: Vec<tokio_postgres::Row> = Self::query(&Self::construct_query(&search_query), &[
            &limit,
            &offset.unwrap_or(0),
        ])
        .await
        .map_err(|_| NotFoundError)?;

        let mut events = Vec::new();
        for row in rows {
            let ends = row
                .try_get::<&'static str, Option<NaiveDateTime>>("end_time")?
                .map(|val| val.and_local_timezone(Utc).unwrap());
            let is_final = ends.map_or(false, |ends| Utc::now() > ends);
            events.push(EventSummary {
                id: EventId(row.try_get("row_id")?),
                name: row.try_get("name")?,
                starts: row
                    .try_get::<&'static str, Option<NaiveDateTime>>("start_time")?
                    .map(|val| val.and_local_timezone(Utc).unwrap()),
                reg_checked: row
                    .try_get::<&'static str, Option<NaiveDateTime>>("last_updated")?
                    .map(|val| val.and_local_timezone(Utc).unwrap()),
                ends,
                is_final,
            });
        }

        let total: i64 = events.len().try_into()?;

        Ok(SearchResult {
            total,
            results: Some(ValueResults::Events(events)),
        })
    }

    /// Search for objectives
    async fn search_objectives(
        &self, search_query: SearchQuery, limit: Option<i64>, offset: Option<i64>,
    ) -> anyhow::Result<SearchResult> {
        let rows: Vec<tokio_postgres::Row> = Self::query(&Self::construct_query(&search_query), &[
            &limit,
            &offset.unwrap_or(0),
        ])
        .await
        .map_err(|_| NotFoundError)?;

        let mut objectives = Vec::new();
        for row in rows {
            let objective = ObjectiveSummary {
                id: ObjectiveId(row.try_get("id")?),
                objective_type: ObjectiveType {
                    id: row.try_get("name")?,
                    description: row.try_get("objective_category_description")?,
                },
                title: row.try_get("title")?,
                description: row.try_get("description")?,
                deleted: row.try_get("deleted")?,
            };
            objectives.push(objective);
        }

        let total: i64 = objectives.len().try_into()?;

        Ok(SearchResult {
            total,
            results: Some(ValueResults::Objectives(objectives)),
        })
    }

    /// Search for proposals
    async fn search_proposals(
        &self, search_query: SearchQuery, limit: Option<i64>, offset: Option<i64>,
    ) -> anyhow::Result<SearchResult> {
        let rows: Vec<tokio_postgres::Row> = Self::query(&Self::construct_query(&search_query), &[
            &limit,
            &offset.unwrap_or(0),
        ])
        .await
        .map_err(|_| NotFoundError)?;

        let mut proposals = Vec::new();
        for row in rows {
            let summary = ProposalSummary {
                id: ProposalId(row.try_get("id")?),
                title: row.try_get("title")?,
                summary: row.try_get("summary")?,
                deleted: row.try_get("deleted")?,
            };

            proposals.push(summary);
        }

        let total: i64 = proposals.len().try_into()?;

        Ok(SearchResult {
            total,
            results: Some(ValueResults::Proposals(proposals)),
        })
    }
}

impl EventDB {
    /// Search query
    #[allow(dead_code)]
    pub(crate) async fn search(
        &self, search_query: SearchQuery, total: bool, limit: Option<i64>, offset: Option<i64>,
    ) -> anyhow::Result<SearchResult> {
        if total {
            Self::search_total(search_query, limit, offset).await
        } else {
            match search_query.table {
                SearchTable::Events => Self::search_events(search_query, limit, offset).await,
                SearchTable::Objectives => {
                    self.search_objectives(search_query, limit, offset).await
                },
                SearchTable::Proposals => self.search_proposals(search_query, limit, offset).await,
            }
        }
    }
}
