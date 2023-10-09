use crate::{
    types::{
        search::{
            SearchConstraint, SearchOrderBy, SearchQuery, SearchResult, SearchTable, ValueResults,
        },
        {
            event::EventId,
            event::EventSummary,
            objective::{ObjectiveId, ObjectiveSummary, ObjectiveType},
            proposal::{ProposalId, ProposalSummary},
        },
    },
    Error, EventDB,
};
use async_trait::async_trait;
use chrono::{NaiveDateTime, Utc};

#[async_trait]
pub trait SearchQueries: Sync + Send + 'static {
    async fn search(
        &self,
        search_query: SearchQuery,
        total: bool,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<SearchResult, Error>;
}

impl EventDB {
    const SEARCH_EVENTS_QUERY: &'static str =
        "SELECT event.row_id, event.name, event.start_time, event.end_time, snapshot.last_updated
        FROM event
        LEFT JOIN snapshot ON event.row_id = snapshot.event";

    const SEARCH_OBJECTIVES_QUERY: &'static str =
        "SELECT objective.id, objective.title, objective.description, objective.deleted, objective_category.name, objective_category.description as objective_category_description
        FROM objective
        INNER JOIN objective_category on objective.category = objective_category.name";

    const SEARCH_PROPOSALS_QUERY: &'static str =
        "SELECT DISTINCT proposal.id, proposal.title, proposal.summary, proposal.deleted
        FROM proposal";

    fn build_where_clause(table: &str, filter: &[SearchConstraint]) -> String {
        let mut where_clause = String::new();
        let mut filter_iter = filter.iter();
        if let Some(filter) = filter_iter.next() {
            where_clause.push_str(
                format!(
                    "WHERE {0}.{1} LIKE '%{2}%'",
                    table,
                    filter.column.to_string(),
                    filter.search
                )
                .as_str(),
            );
            for filter in filter_iter {
                where_clause.push_str(
                    format!(
                        "AND {0}.{1} LIKE '%{2}%'",
                        table,
                        filter.column.to_string(),
                        filter.search
                    )
                    .as_str(),
                );
            }
        }
        where_clause
    }

    fn build_order_by_clause(table: &str, order_by: &[SearchOrderBy]) -> String {
        let mut order_by_clause = String::new();
        let mut order_by_iter = order_by.iter();
        if let Some(order_by) = order_by_iter.next() {
            let order_type = if order_by.descending { "DESC" } else { "ASC" };
            order_by_clause.push_str(
                format!(
                    "ORDER BY {0}.{1} {2}",
                    table,
                    order_by.column.to_string(),
                    order_type
                )
                .as_str(),
            );
            for order_by in order_by_iter {
                let order_type = if order_by.descending { "DESC" } else { "ASC" };
                order_by_clause.push_str(
                    format!(
                        ", {0}.{1} LIKE '%{2}%'",
                        table,
                        order_by.column.to_string(),
                        order_type
                    )
                    .as_str(),
                );
            }
        }
        order_by_clause
    }

    fn contruct_query(search_query: &SearchQuery) -> String {
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

    fn contruct_count_query(search_query: &SearchQuery) -> String {
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
}

#[async_trait]
impl SearchQueries for EventDB {
    async fn search(
        &self,
        search_query: SearchQuery,
        total: bool,
        limit: Option<i64>,
        offset: Option<i64>,
    ) -> Result<SearchResult, Error> {
        let conn = self.pool.get().await?;

        if total {
            let rows: Vec<tokio_postgres::Row> = conn
                .query(
                    &Self::contruct_count_query(&search_query),
                    &[&limit, &offset.unwrap_or(0)],
                )
                .await
                .map_err(|e| Error::NotFound(e.to_string()))?;
            let row = rows.get(0).unwrap();

            Ok(SearchResult {
                total: row.try_get("total")?,
                results: None,
            })
        } else {
            match search_query.table {
                SearchTable::Events => {
                    let rows: Vec<tokio_postgres::Row> = conn
                        .query(
                            &Self::contruct_query(&search_query),
                            &[&limit, &offset.unwrap_or(0)],
                        )
                        .await
                        .map_err(|e| Error::NotFound(e.to_string()))?;

                    let mut events = Vec::new();
                    for row in rows {
                        let ends = row
                            .try_get::<&'static str, Option<NaiveDateTime>>("end_time")?
                            .map(|val| val.and_local_timezone(Utc).unwrap());
                        let is_final = ends.map(|ends| Utc::now() > ends).unwrap_or(false);
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
                        })
                    }

                    Ok(SearchResult {
                        total: events.len() as i64,
                        results: Some(ValueResults::Events(events)),
                    })
                }
                SearchTable::Objectives => {
                    let rows: Vec<tokio_postgres::Row> = conn
                        .query(
                            &Self::contruct_query(&search_query),
                            &[&limit, &offset.unwrap_or(0)],
                        )
                        .await
                        .map_err(|e| Error::NotFound(e.to_string()))?;

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

                    Ok(SearchResult {
                        total: objectives.len() as i64,
                        results: Some(ValueResults::Objectives(objectives)),
                    })
                }
                SearchTable::Proposals => {
                    let rows: Vec<tokio_postgres::Row> = conn
                        .query(
                            &Self::contruct_query(&search_query),
                            &[&limit, &offset.unwrap_or(0)],
                        )
                        .await
                        .map_err(|e| Error::NotFound(e.to_string()))?;

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

                    Ok(SearchResult {
                        total: proposals.len() as i64,
                        results: Some(ValueResults::Proposals(proposals)),
                    })
                }
            }
        }
    }
}

/// Need to setup and run a test event db instance
/// To do it you can use the following commands:
/// Prepare docker images
/// ```
/// earthly ./containers/event-db-migrations+docker --data=test
/// ```
/// Run event-db container
/// ```
/// docker-compose -f src/event-db/docker-compose.yml up migrations
/// ```
/// Also need establish `EVENT_DB_URL` env variable with the following value
/// ```
/// EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
/// ```
/// https://github.com/input-output-hk/catalyst-core/tree/main/src/event-db/Readme.md
#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        establish_connection,
        types::search::{SearchColumn, SearchConstraint, SearchOrderBy},
    };
    use chrono::{DateTime, NaiveDate, NaiveTime};

    #[tokio::test]
    async fn search_events_test() {
        let event_db = establish_connection(None).await.unwrap();

        let search_query = SearchQuery {
            table: SearchTable::Events,
            filter: vec![SearchConstraint {
                column: SearchColumn::Description,
                search: "Fund".to_string(),
            }],
            order_by: vec![SearchOrderBy {
                column: SearchColumn::Description,
                descending: false,
            }],
        };
        let query_result = event_db
            .search(search_query.clone(), false, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 6);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Events(vec![
                EventSummary {
                    id: EventId(0),
                    name: "Test Fund".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    ends: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    reg_checked: None,
                    is_final: true,
                },
                EventSummary {
                    id: EventId(1),
                    name: "Test Fund 1".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(2),
                    name: "Test Fund 2".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(3),
                    name: "Test Fund 3".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(4),
                    name: "Test Fund 4".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2024, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: None,
                    is_final: false,
                },
                EventSummary {
                    id: EventId(5),
                    name: "Test Fund 5".to_string(),
                    starts: None,
                    ends: None,
                    reg_checked: None,
                    is_final: false,
                },
            ]))
        );

        let query_result = event_db
            .search(search_query, true, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 6);
        assert_eq!(query_result.results, None);

        let search_query = SearchQuery {
            table: SearchTable::Events,
            filter: vec![SearchConstraint {
                column: SearchColumn::Description,
                search: "Fund".to_string(),
            }],
            order_by: vec![SearchOrderBy {
                column: SearchColumn::Description,
                descending: true,
            }],
        };
        let query_result = event_db
            .search(search_query.clone(), false, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 6);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Events(vec![
                EventSummary {
                    id: EventId(5),
                    name: "Test Fund 5".to_string(),
                    starts: None,
                    ends: None,
                    reg_checked: None,
                    is_final: false,
                },
                EventSummary {
                    id: EventId(4),
                    name: "Test Fund 4".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2024, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: None,
                    is_final: false,
                },
                EventSummary {
                    id: EventId(3),
                    name: "Test Fund 3".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(2),
                    name: "Test Fund 2".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(1),
                    name: "Test Fund 1".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(0),
                    name: "Test Fund".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    ends: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    reg_checked: None,
                    is_final: true,
                }
            ]))
        );

        let query_result = event_db
            .search(search_query.clone(), false, Some(2), None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 2);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Events(vec![
                EventSummary {
                    id: EventId(5),
                    name: "Test Fund 5".to_string(),
                    starts: None,
                    ends: None,
                    reg_checked: None,
                    is_final: false,
                },
                EventSummary {
                    id: EventId(4),
                    name: "Test Fund 4".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2024, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: None,
                    is_final: false,
                },
            ]))
        );

        let query_result = event_db
            .search(search_query.clone(), false, None, Some(2))
            .await
            .unwrap();
        assert_eq!(query_result.total, 4);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Events(vec![
                EventSummary {
                    id: EventId(3),
                    name: "Test Fund 3".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2022, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(2),
                    name: "Test Fund 2".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2021, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(1),
                    name: "Test Fund 1".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 5, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    ends: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 6, 1).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    reg_checked: Some(DateTime::<Utc>::from_utc(
                        NaiveDateTime::new(
                            NaiveDate::from_ymd_opt(2020, 3, 31).unwrap(),
                            NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                        ),
                        Utc
                    )),
                    is_final: true,
                },
                EventSummary {
                    id: EventId(0),
                    name: "Test Fund".to_string(),
                    starts: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    ends: Some(DateTime::<Utc>::from_utc(NaiveDateTime::default(), Utc)),
                    reg_checked: None,
                    is_final: true,
                }
            ]))
        );

        let query_result = event_db
            .search(search_query, false, Some(1), Some(1))
            .await
            .unwrap();
        assert_eq!(query_result.total, 1);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Events(vec![EventSummary {
                id: EventId(4),
                name: "Test Fund 4".to_string(),
                starts: Some(DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2022, 5, 1).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                )),
                ends: Some(DateTime::<Utc>::from_utc(
                    NaiveDateTime::new(
                        NaiveDate::from_ymd_opt(2024, 6, 1).unwrap(),
                        NaiveTime::from_hms_opt(12, 0, 0).unwrap()
                    ),
                    Utc
                )),
                reg_checked: None,
                is_final: false,
            },]))
        );

        let search_query = SearchQuery {
            table: SearchTable::Events,
            filter: vec![SearchConstraint {
                column: SearchColumn::Funds,
                search: "Fund 4".to_string(),
            }],
            order_by: vec![],
        };
        assert_eq!(
            event_db.search(search_query, false, None, None).await,
            Err(Error::NotFound(
                "db error: ERROR: column event.funds does not exist".to_string()
            ))
        )
    }

    #[tokio::test]
    async fn search_objectives_test() {
        let event_db = establish_connection(None).await.unwrap();

        let search_query: SearchQuery = SearchQuery {
            table: SearchTable::Objectives,
            filter: vec![SearchConstraint {
                column: SearchColumn::Description,
                search: "description".to_string(),
            }],
            order_by: vec![SearchOrderBy {
                column: SearchColumn::Description,
                descending: false,
            }],
        };
        let query_result = event_db
            .search(search_query.clone(), false, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 4);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Objectives(vec![
                ObjectiveSummary {
                    id: ObjectiveId(1),
                    objective_type: ObjectiveType {
                        id: "catalyst-simple".to_string(),
                        description: "A Simple choice".to_string()
                    },
                    title: "title 1".to_string(),
                    description: "description 1".to_string(),
                    deleted: false,
                },
                ObjectiveSummary {
                    id: ObjectiveId(2),
                    objective_type: ObjectiveType {
                        id: "catalyst-native".to_string(),
                        description: "??".to_string()
                    },
                    title: "title 2".to_string(),
                    description: "description 2".to_string(),
                    deleted: false,
                },
                ObjectiveSummary {
                    id: ObjectiveId(3),
                    objective_type: ObjectiveType {
                        id: "catalyst-simple".to_string(),
                        description: "A Simple choice".to_string()
                    },
                    title: "title 3".to_string(),
                    description: "description 3".to_string(),
                    deleted: false,
                },
                ObjectiveSummary {
                    id: ObjectiveId(4),
                    objective_type: ObjectiveType {
                        id: "catalyst-native".to_string(),
                        description: "??".to_string()
                    },
                    title: "title 4".to_string(),
                    description: "description 4".to_string(),
                    deleted: false,
                },
            ]))
        );

        let query_result = event_db
            .search(search_query, true, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 4);
        assert_eq!(query_result.results, None);

        let search_query: SearchQuery = SearchQuery {
            table: SearchTable::Objectives,
            filter: vec![SearchConstraint {
                column: SearchColumn::Description,
                search: "description".to_string(),
            }],
            order_by: vec![SearchOrderBy {
                column: SearchColumn::Description,
                descending: true,
            }],
        };
        let query_result = event_db
            .search(search_query.clone(), false, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 4);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Objectives(vec![
                ObjectiveSummary {
                    id: ObjectiveId(4),
                    objective_type: ObjectiveType {
                        id: "catalyst-native".to_string(),
                        description: "??".to_string()
                    },
                    title: "title 4".to_string(),
                    description: "description 4".to_string(),
                    deleted: false,
                },
                ObjectiveSummary {
                    id: ObjectiveId(3),
                    objective_type: ObjectiveType {
                        id: "catalyst-simple".to_string(),
                        description: "A Simple choice".to_string()
                    },
                    title: "title 3".to_string(),
                    description: "description 3".to_string(),
                    deleted: false,
                },
                ObjectiveSummary {
                    id: ObjectiveId(2),
                    objective_type: ObjectiveType {
                        id: "catalyst-native".to_string(),
                        description: "??".to_string()
                    },
                    title: "title 2".to_string(),
                    description: "description 2".to_string(),
                    deleted: false,
                },
                ObjectiveSummary {
                    id: ObjectiveId(1),
                    objective_type: ObjectiveType {
                        id: "catalyst-simple".to_string(),
                        description: "A Simple choice".to_string()
                    },
                    title: "title 1".to_string(),
                    description: "description 1".to_string(),
                    deleted: false,
                },
            ]))
        );

        let query_result = event_db
            .search(search_query.clone(), false, Some(1), None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 1);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Objectives(vec![ObjectiveSummary {
                id: ObjectiveId(4),
                objective_type: ObjectiveType {
                    id: "catalyst-native".to_string(),
                    description: "??".to_string()
                },
                title: "title 4".to_string(),
                description: "description 4".to_string(),
                deleted: false,
            },]))
        );

        let query_result = event_db
            .search(search_query, false, None, Some(1))
            .await
            .unwrap();
        assert_eq!(query_result.total, 3);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Objectives(vec![
                ObjectiveSummary {
                    id: ObjectiveId(3),
                    objective_type: ObjectiveType {
                        id: "catalyst-simple".to_string(),
                        description: "A Simple choice".to_string()
                    },
                    title: "title 3".to_string(),
                    description: "description 3".to_string(),
                    deleted: false,
                },
                ObjectiveSummary {
                    id: ObjectiveId(2),
                    objective_type: ObjectiveType {
                        id: "catalyst-native".to_string(),
                        description: "??".to_string()
                    },
                    title: "title 2".to_string(),
                    description: "description 2".to_string(),
                    deleted: false,
                },
                ObjectiveSummary {
                    id: ObjectiveId(1),
                    objective_type: ObjectiveType {
                        id: "catalyst-simple".to_string(),
                        description: "A Simple choice".to_string()
                    },
                    title: "title 1".to_string(),
                    description: "description 1".to_string(),
                    deleted: false,
                },
            ]))
        );

        let search_query = SearchQuery {
            table: SearchTable::Objectives,
            filter: vec![SearchConstraint {
                column: SearchColumn::Funds,
                search: "description 1".to_string(),
            }],
            order_by: vec![],
        };
        assert_eq!(
            event_db.search(search_query, false, None, None).await,
            Err(Error::NotFound(
                "db error: ERROR: column objective.funds does not exist".to_string()
            ))
        )
    }

    #[tokio::test]
    async fn search_proposals_test() {
        let event_db = establish_connection(None).await.unwrap();

        let search_query: SearchQuery = SearchQuery {
            table: SearchTable::Proposals,
            filter: vec![SearchConstraint {
                column: SearchColumn::Title,
                search: "title".to_string(),
            }],
            order_by: vec![SearchOrderBy {
                column: SearchColumn::Title,
                descending: false,
            }],
        };
        let query_result = event_db
            .search(search_query.clone(), false, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 3);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Proposals(vec![
                ProposalSummary {
                    id: ProposalId(10),
                    title: String::from("title 1"),
                    summary: String::from("summary 1"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(20),
                    title: String::from("title 2"),
                    summary: String::from("summary 2"),
                    deleted: false,
                },
                ProposalSummary {
                    id: ProposalId(30),
                    title: String::from("title 3"),
                    summary: String::from("summary 3"),
                    deleted: false
                },
            ]))
        );

        let query_result = event_db
            .search(search_query, true, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 3);
        assert_eq!(query_result.results, None);

        let search_query: SearchQuery = SearchQuery {
            table: SearchTable::Proposals,
            filter: vec![SearchConstraint {
                column: SearchColumn::Title,
                search: "title".to_string(),
            }],
            order_by: vec![SearchOrderBy {
                column: SearchColumn::Title,
                descending: true,
            }],
        };
        let query_result = event_db
            .search(search_query.clone(), false, None, None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 3);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Proposals(vec![
                ProposalSummary {
                    id: ProposalId(30),
                    title: String::from("title 3"),
                    summary: String::from("summary 3"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(20),
                    title: String::from("title 2"),
                    summary: String::from("summary 2"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(10),
                    title: String::from("title 1"),
                    summary: String::from("summary 1"),
                    deleted: false
                },
            ]))
        );

        let query_result = event_db
            .search(search_query.clone(), false, Some(2), None)
            .await
            .unwrap();
        assert_eq!(query_result.total, 2);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Proposals(vec![
                ProposalSummary {
                    id: ProposalId(30),
                    title: String::from("title 3"),
                    summary: String::from("summary 3"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(20),
                    title: String::from("title 2"),
                    summary: String::from("summary 2"),
                    deleted: false
                },
            ]))
        );

        let query_result = event_db
            .search(search_query.clone(), false, None, Some(1))
            .await
            .unwrap();
        assert_eq!(query_result.total, 2);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Proposals(vec![
                ProposalSummary {
                    id: ProposalId(20),
                    title: String::from("title 2"),
                    summary: String::from("summary 2"),
                    deleted: false
                },
                ProposalSummary {
                    id: ProposalId(10),
                    title: String::from("title 1"),
                    summary: String::from("summary 1"),
                    deleted: false
                },
            ]))
        );

        let query_result = event_db
            .search(search_query, false, Some(1), Some(1))
            .await
            .unwrap();
        assert_eq!(query_result.total, 1);
        assert_eq!(
            query_result.results,
            Some(ValueResults::Proposals(vec![ProposalSummary {
                id: ProposalId(20),
                title: String::from("title 2"),
                summary: String::from("summary 2"),
                deleted: false
            },]))
        );

        let search_query = SearchQuery {
            table: SearchTable::Proposals,
            filter: vec![SearchConstraint {
                column: SearchColumn::Description,
                search: "description 1".to_string(),
            }],
            order_by: vec![],
        };
        assert_eq!(
            event_db.search(search_query, false, None, None).await,
            Err(Error::NotFound(
                "db error: ERROR: column proposal.description does not exist".to_string()
            ))
        )
    }
}
