use super::SerdeType;
use event_db::types::search::{
    SearchColumn, SearchConstraint, SearchOrderBy, SearchQuery, SearchResult, SearchTable,
    ValueResults,
};
use serde::{de::Deserializer, ser::Serializer, Deserialize, Serialize};

impl<'de> Deserialize<'de> for SerdeType<SearchTable> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<SearchTable>, D::Error>
    where
        D: Deserializer<'de>,
    {
        #[derive(Deserialize)]
        #[serde(rename_all = "kebab-case")]
        enum SearchTableSerde {
            Events,
            Objectives,
            Proposals,
        }
        match SearchTableSerde::deserialize(deserializer)? {
            SearchTableSerde::Events => Ok(SerdeType(SearchTable::Events)),
            SearchTableSerde::Objectives => Ok(SerdeType(SearchTable::Objectives)),
            SearchTableSerde::Proposals => Ok(SerdeType(SearchTable::Proposals)),
        }
    }
}

impl<'de> Deserialize<'de> for SerdeType<SearchColumn> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<SearchColumn>, D::Error>
    where
        D: Deserializer<'de>,
    {
        #[derive(Deserialize)]
        #[serde(rename_all = "kebab-case")]
        enum SearchColumnSerde {
            Title,
            Type,
            Description,
            Author,
            Funds,
        }
        match SearchColumnSerde::deserialize(deserializer)? {
            SearchColumnSerde::Title => Ok(SerdeType(SearchColumn::Title)),
            SearchColumnSerde::Type => Ok(SerdeType(SearchColumn::Type)),
            SearchColumnSerde::Description => Ok(SerdeType(SearchColumn::Description)),
            SearchColumnSerde::Author => Ok(SerdeType(SearchColumn::Author)),
            SearchColumnSerde::Funds => Ok(SerdeType(SearchColumn::Funds)),
        }
    }
}

impl<'de> Deserialize<'de> for SerdeType<SearchConstraint> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<SearchConstraint>, D::Error>
    where
        D: Deserializer<'de>,
    {
        #[derive(Deserialize)]
        struct SearchConstraintSerde {
            column: SerdeType<SearchColumn>,
            search: String,
        }
        let SearchConstraintSerde { column, search } =
            SearchConstraintSerde::deserialize(deserializer)?;
        Ok(SerdeType(SearchConstraint {
            column: column.0,
            search,
        }))
    }
}

impl<'de> Deserialize<'de> for SerdeType<SearchOrderBy> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<SearchOrderBy>, D::Error>
    where
        D: Deserializer<'de>,
    {
        #[derive(Deserialize)]
        struct SearchOrderBySerde {
            pub column: SerdeType<SearchColumn>,
            #[serde(default)]
            pub descending: bool,
        }
        let SearchOrderBySerde { column, descending } =
            SearchOrderBySerde::deserialize(deserializer)?;
        Ok(SerdeType(SearchOrderBy {
            column: column.0,
            descending,
        }))
    }
}

impl<'de> Deserialize<'de> for SerdeType<SearchQuery> {
    fn deserialize<D>(deserializer: D) -> Result<SerdeType<SearchQuery>, D::Error>
    where
        D: Deserializer<'de>,
    {
        #[derive(Deserialize)]
        struct SearchQuerySerde {
            pub table: SerdeType<SearchTable>,
            #[serde(default)]
            pub filter: Vec<SerdeType<SearchConstraint>>,
            #[serde(default)]
            pub order_by: Vec<SerdeType<SearchOrderBy>>,
        }
        let SearchQuerySerde {
            table,
            filter,
            order_by,
        } = SearchQuerySerde::deserialize(deserializer)?;
        Ok(SerdeType(SearchQuery {
            table: table.0,
            filter: filter.into_iter().map(|val| val.0).collect(),
            order_by: order_by.into_iter().map(|val| val.0).collect(),
        }))
    }
}

impl Serialize for SerdeType<&ValueResults> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        match self.0 {
            ValueResults::Events(events) => events
                .iter()
                .map(SerdeType)
                .collect::<Vec<_>>()
                .serialize(serializer),
            ValueResults::Objectives(events) => events
                .iter()
                .map(SerdeType)
                .collect::<Vec<_>>()
                .serialize(serializer),
            ValueResults::Proposals(events) => events
                .iter()
                .map(SerdeType)
                .collect::<Vec<_>>()
                .serialize(serializer),
        }
    }
}

impl Serialize for SerdeType<ValueResults> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&SearchResult> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct SearchResultSerde<'a> {
            total: i64,
            #[serde(skip_serializing_if = "Option::is_none")]
            results: Option<SerdeType<&'a ValueResults>>,
        }
        SearchResultSerde {
            total: self.total,
            results: self.results.as_ref().map(SerdeType),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<SearchResult> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn search_table_json_test() {
        let json = json!("events");
        let search_table: SerdeType<SearchTable> = serde_json::from_value(json).unwrap();
        assert_eq!(search_table, SerdeType(SearchTable::Events));

        let json = json!("objectives");
        let search_table: SerdeType<SearchTable> = serde_json::from_value(json).unwrap();
        assert_eq!(search_table, SerdeType(SearchTable::Objectives));

        let json = json!("proposals");
        let search_table: SerdeType<SearchTable> = serde_json::from_value(json).unwrap();
        assert_eq!(search_table, SerdeType(SearchTable::Proposals));
    }

    #[test]
    fn search_column_json_test() {
        let json = json!("title");
        let search_table: SerdeType<SearchColumn> = serde_json::from_value(json).unwrap();
        assert_eq!(search_table, SerdeType(SearchColumn::Title));

        let json = json!("type");
        let search_table: SerdeType<SearchColumn> = serde_json::from_value(json).unwrap();
        assert_eq!(search_table, SerdeType(SearchColumn::Type));

        let json = json!("description");
        let search_table: SerdeType<SearchColumn> = serde_json::from_value(json).unwrap();
        assert_eq!(search_table, SerdeType(SearchColumn::Description));

        let json = json!("author");
        let search_table: SerdeType<SearchColumn> = serde_json::from_value(json).unwrap();
        assert_eq!(search_table, SerdeType(SearchColumn::Author));

        let json = json!("funds");
        let search_table: SerdeType<SearchColumn> = serde_json::from_value(json).unwrap();
        assert_eq!(search_table, SerdeType(SearchColumn::Funds));
    }

    #[test]
    fn search_contraint_json_test() {
        let json = json!({
            "column": "title",
            "search": "search 1"
        });
        let search_contraint: SerdeType<SearchConstraint> = serde_json::from_value(json).unwrap();
        assert_eq!(
            search_contraint,
            SerdeType(SearchConstraint {
                column: SearchColumn::Title,
                search: "search 1".to_string()
            })
        );
    }

    #[test]
    fn search_order_by_json_test() {
        let json = json!({
            "column": "title",
            "descending": true
        });
        let search_order_by: SerdeType<SearchOrderBy> = serde_json::from_value(json).unwrap();
        assert_eq!(
            search_order_by,
            SerdeType(SearchOrderBy {
                column: SearchColumn::Title,
                descending: true,
            })
        );

        let json = json!({
            "column": "title",
        });
        let search_order_by: SerdeType<SearchOrderBy> = serde_json::from_value(json).unwrap();
        assert_eq!(
            search_order_by,
            SerdeType(SearchOrderBy {
                column: SearchColumn::Title,
                descending: false,
            })
        );
    }

    #[test]
    fn search_query_json_test() {
        let json = json!({
            "table": "events",
            "filter": [
                {
                    "column": "title",
                    "search": "search 1"
                }
            ],
            "order_by": [
                {
                    "column": "title",
                    "descending": true
                }
            ]
        });
        let search_query: SerdeType<SearchQuery> = serde_json::from_value(json).unwrap();
        assert_eq!(
            search_query,
            SerdeType(SearchQuery {
                table: SearchTable::Events,
                filter: vec![SearchConstraint {
                    column: SearchColumn::Title,
                    search: "search 1".to_string()
                }],
                order_by: vec![SearchOrderBy {
                    column: SearchColumn::Title,
                    descending: true
                }]
            })
        );

        let json = json!({
            "table": "events",
        });
        let search_query: SerdeType<SearchQuery> = serde_json::from_value(json).unwrap();
        assert_eq!(
            search_query,
            SerdeType(SearchQuery {
                table: SearchTable::Events,
                filter: vec![],
                order_by: vec![]
            })
        );
    }
}
