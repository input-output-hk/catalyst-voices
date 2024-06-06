//! Catalyst Election Database crate
use std::{str::FromStr, sync::Arc};

use bb8::Pool;
use bb8_postgres::PostgresConnectionManager;
use dotenvy::dotenv;
use stringzilla::StringZilla;
use tokio::sync::RwLock;
use tokio_postgres::{types::ToSql, NoTls, Row};
use tracing::{debug, debug_span, Instrument};

pub(crate) mod cardano;
pub(crate) mod error;
pub(crate) mod legacy;
pub(crate) mod schema_check;

/// Database URL Environment Variable name.
/// eg: "`postgres://catalyst-dev:CHANGE_ME@localhost/CatalystDev`"
const DATABASE_URL_ENVVAR: &str = "EVENT_DB_URL";

/// Database version this crate matches.
/// Must equal the last Migrations Version Number.
pub(crate) const DATABASE_SCHEMA_VERSION: i32 = 9;

#[derive(Clone, Copy, Default, Debug, PartialEq, Eq)]
/// Settings for deep query inspection
pub(crate) enum DeepQueryInspectionFlag {
    /// Enable deep query inspection
    Enabled,
    /// Disable deep query inspection
    #[default]
    Disabled,
}

impl From<bool> for DeepQueryInspectionFlag {
    fn from(b: bool) -> Self {
        if b {
            Self::Enabled
        } else {
            Self::Disabled
        }
    }
}

#[allow(unused)]
/// Connection to the Election Database
pub(crate) struct EventDB {
    /// Internal database connection.  DO NOT MAKE PUBLIC.
    /// All database operations (queries, inserts, etc) should be constrained
    /// to this crate and should be exported with a clean data access api.
    pool: Pool<PostgresConnectionManager<NoTls>>,
    /// Deep query inspection flag.
    deep_query_inspection_flag: Arc<RwLock<DeepQueryInspectionFlag>>,
}

/// `EventDB` Errors
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
pub(crate) enum Error {
    /// Database statement is not a valid modify statement
    #[error("Invalid Modify Statement")]
    InvalidModifyStatement,
    /// Database statement is not a valid query statement
    #[error("Invalid Query Statement")]
    InvalidQueryStatement,
    /// No DB URL was provided
    #[error("DB URL is undefined")]
    NoDatabaseUrl,
}

impl EventDB {
    /// Determine if deep query inspection is enabled.
    pub(crate) async fn is_deep_query_enabled(&self) -> bool {
        *self.deep_query_inspection_flag.read().await == DeepQueryInspectionFlag::Enabled
    }

    /// Modify the deep query inspection setting.
    ///
    /// # Arguments
    ///
    /// * `deep_query` - `DeepQueryInspection` setting.
    pub(crate) async fn modify_deep_query(
        &self, deep_query_inspection_flag: DeepQueryInspectionFlag,
    ) {
        let mut flag = self.deep_query_inspection_flag.write().await;
        *flag = deep_query_inspection_flag;
    }

    /// Query the database.
    ///
    /// If deep query inspection is enabled, this will log the query plan inside a
    /// rolled-back transaction, before running the query.
    ///
    /// # Arguments
    ///
    /// * `stmt` - `&str` SQL statement.
    /// * `params` - `&[&(dyn ToSql + Sync)]` SQL parameters.
    ///
    /// # Returns
    ///
    /// `Result<Vec<Row>, anyhow::Error>`
    #[must_use = "ONLY use this function for SELECT type operations which return row data, otherwise use `modify()`"]
    pub(crate) async fn query(
        &self, stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> Result<Vec<Row>, anyhow::Error> {
        if self.is_deep_query_enabled().await {
            // Check if this is a query statement
            // if is_query_stmt(stmt) {
            //     self.explain_analyze_rollback(stmt, params).await?;
            // } else {
            //     return Err(Error::InvalidQueryStatement.into());
            // }
            self.explain_analyze_rollback(stmt, params).await?;
        }
        let rows = self.pool.get().await?.query(stmt, params).await?;
        Ok(rows)
    }

    /// Query the database for a single row.
    ///
    /// # Arguments
    ///
    /// * `stmt` - `&str` SQL statement.
    /// * `params` - `&[&(dyn ToSql + Sync)]` SQL parameters.
    ///
    /// # Returns
    ///
    /// `Result<Row, anyhow::Error>`
    #[must_use = "ONLY use this function for SELECT type operations which return row data, otherwise use `modify()`"]
    pub(crate) async fn query_one(
        &self, stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> Result<Row, anyhow::Error> {
        if self.is_deep_query_enabled().await {
            // Check if this is a query statement
            // if is_query_stmt(stmt) {
            //     self.explain_analyze_rollback(stmt, params).await?;
            // } else {
            //     return Err(Error::InvalidQueryStatement.into());
            // }
            self.explain_analyze_rollback(stmt, params).await?;
        }
        let row = self.pool.get().await?.query_one(stmt, params).await?;
        Ok(row)
    }

    /// Modify the database.
    ///
    /// Use this for `UPDATE`, `DELETE`, and other DB statements that
    /// don't return data.
    ///
    /// # Arguments
    ///
    /// * `stmt` - `&str` SQL statement.
    /// * `params` - `&[&(dyn ToSql + Sync)]` SQL parameters.
    ///
    /// # Returns
    ///
    /// `anyhow::Result<()>`
    pub(crate) async fn modify(
        &self, stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<()> {
        if self.is_deep_query_enabled().await {
            // Check if this is a query statement
            // if is_query_stmt(stmt) {
            //     return Err(Error::InvalidModifyStatement.into());
            // }
            self.explain_analyze_commit(stmt, params).await?;
        } else {
            self.pool.get().await?.query(stmt, params).await?;
        }
        Ok(())
    }

    /// Prepend `EXPLAIN ANALYZE` to the query, and rollback the transaction.
    async fn explain_analyze_rollback(
        &self, stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<()> {
        self.explain_analyze(stmt, params, true).await
    }

    /// Prepend `EXPLAIN ANALYZE` to the query, and commit the transaction.
    async fn explain_analyze_commit(
        &self, stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<()> {
        self.explain_analyze(stmt, params, false).await
    }

    /// Prepend `EXPLAIN ANALYZE` to the query.
    ///
    /// Log the query plan inside a transaction that may be committed or rolled back.
    ///
    /// # Arguments
    ///
    /// * `stmt` - `&str` SQL statement.
    /// * `params` - `&[&(dyn ToSql + Sync)]` SQL parameters.
    /// * `rollback` - `bool` whether to roll back the transaction or not.
    async fn explain_analyze(
        &self, stmt: &str, params: &[&(dyn ToSql + Sync)], rollback: bool,
    ) -> anyhow::Result<()> {
        let span = debug_span!(
            "query_plan",
            query_statement = stmt,
            params = format!("{:?}", params),
            uuid = uuid::Uuid::new_v4().to_string()
        );

        async move {
            let mut conn = self.pool.get().await?;
            let transaction = conn.transaction().await?;
            let explain_stmt = transaction
                .prepare(format!("EXPLAIN ANALYZE {stmt}").as_str())
                .await?;
            let rows = transaction.query(&explain_stmt, params).await?;
            for r in rows {
                let query_plan_str: String = r.get("QUERY PLAN");
                debug!("{}", query_plan_str);
            }
            if rollback {
                transaction.rollback().await?;
            } else {
                transaction.commit().await?;
            }
            Ok(())
        }
        .instrument(span)
        .await
    }
}

/// Establish a connection to the database, and check the schema is up-to-date.
///
/// # Parameters
///
/// * `url` set to the postgres connection string needed to connect to the database.  IF
///   it is None, then the env var "`DATABASE_URL`" will be used for this connection
///   string. eg: "`postgres://catalyst-dev:CHANGE_ME@localhost/CatalystDev`"
/// * `do_schema_check` boolean flag to decide whether to verify the schema version or
///   not. If it is `true`, a query is made to verify the DB schema version.
///
/// # Errors
///
/// This function will return an error if:
/// * `url` is None and the environment variable "`DATABASE_URL`" isn't set.
/// * There is any error communicating the the database to check its schema.
/// * The database schema in the DB does not 100% match the schema supported by this
///   library.
///
/// # Notes
///
/// The env var "`DATABASE_URL`" can be set directly as an anv var, or in a
/// `.env` file.
pub(crate) async fn establish_connection(url: Option<String>) -> anyhow::Result<EventDB> {
    // Support env vars in a `.env` file,  doesn't need to exist.
    dotenv().ok();

    let database_url = match url {
        Some(url) => url,
        // If the Database connection URL is not supplied, try and get from the env var.
        None => std::env::var(DATABASE_URL_ENVVAR).map_err(|_| Error::NoDatabaseUrl)?,
    };

    let config = tokio_postgres::config::Config::from_str(&database_url)?;

    let pg_mgr = PostgresConnectionManager::new(config, tokio_postgres::NoTls);

    let pool = Pool::builder().build(pg_mgr).await?;

    Ok(EventDB {
        pool,
        deep_query_inspection_flag: Arc::default(),
    })
}

/// Determine if the statement is a query statement.
///
/// Returns true f the query statement starts with `SELECT` or contains `RETURNING`.
fn is_query_stmt(stmt: &str) -> bool {
    // First, determine if the statement is a `SELECT` operation
    if let Some(stmt) = &stmt.get(..6) {
        if *stmt == "SELECT" {
            return true;
        }
    }
    // Otherwise, determine if the statement contains `RETURNING`
    stmt.sz_rfind("RETURNING").is_some()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_is_query_statement() {
        let stmt = "SELECT * FROM dummy";
        assert!(is_query_stmt(stmt));
        let stmt = "UPDATE dummy SET foo = $1 WHERE bar = $2 RETURNING *";
        assert!(is_query_stmt(stmt));
    }

    #[test]
    fn test_is_not_query_statement() {
        let stmt = "UPDATE dummy SET foo_count = foo_count + 1 WHERE bar = (SELECT bar_id FROM foo WHERE name = 'FooBar')";
        assert!(!is_query_stmt(stmt));
        let stmt = "UPDATE dummy SET foo = $1 WHERE bar = $2";
        assert!(!is_query_stmt(stmt));
    }
}
