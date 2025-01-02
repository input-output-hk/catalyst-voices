//! Catalyst Election Database crate
use std::{
    str::FromStr,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, OnceLock,
    },
};

use bb8::Pool;
use bb8_postgres::PostgresConnectionManager;
use error::NotFoundError;
use futures::{Stream, StreamExt, TryStreamExt};
use tokio_postgres::{types::ToSql, NoTls, Row};
use tracing::{debug, debug_span, error, Instrument};

use crate::settings::Settings;

pub(crate) mod common;
pub(crate) mod config;
pub(crate) mod error;
pub(crate) mod legacy;
pub(crate) mod schema_check;
pub(crate) mod signed_docs;

/// Database version this crate matches.
/// Must equal the last Migrations Version Number from `event-db/migrations`.
pub(crate) const DATABASE_SCHEMA_VERSION: i32 = 2;

/// Postgres Connection Manager DB Pool
type SqlDbPool = Arc<Pool<PostgresConnectionManager<NoTls>>>;

/// Postgres Connection Manager DB Pool Instance
static EVENT_DB_POOL: OnceLock<SqlDbPool> = OnceLock::new();

/// Is Deep Query Analysis enabled or not?
static DEEP_QUERY_INSPECT: AtomicBool = AtomicBool::new(false);

/// The Catalyst Event SQL Database
pub(crate) struct EventDB {}

/// `EventDB` Errors
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
pub(crate) enum Error {
    /// Failed to get a DB Pool
    #[error("DB Pool uninitialized")]
    DbPoolUninitialized,
}

impl EventDB {
    /// Determine if deep query inspection is enabled.
    pub(crate) fn is_deep_query_enabled() -> bool {
        DEEP_QUERY_INSPECT.load(Ordering::SeqCst)
    }

    /// Modify the deep query inspection setting.
    ///
    /// # Arguments
    ///
    /// * `enable` - Set the `DeepQueryInspection` setting to this value.
    pub(crate) fn modify_deep_query(enable: bool) {
        DEEP_QUERY_INSPECT.store(enable, Ordering::SeqCst);
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
    /// `anyhow::Result<Vec<Row>>`
    #[must_use = "ONLY use this function for SELECT type operations which return row data, otherwise use `modify()`"]
    pub(crate) async fn query(
        stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<Vec<Row>> {
        if Self::is_deep_query_enabled() {
            Self::explain_analyze_rollback(stmt, params).await?;
        }
        let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
        let conn = pool.get().await?;
        let rows = conn.query(stmt, params).await?;
        Ok(rows)
    }

    /// Query the database and return a async stream of rows.
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
    /// `anyhow::Result<impl Stream<Item = anyhow::Result<Row>>>`
    #[must_use = "ONLY use this function for SELECT type operations which return row data, otherwise use `modify()`"]
    pub(crate) async fn query_stream(
        stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<impl Stream<Item = anyhow::Result<Row>>> {
        if Self::is_deep_query_enabled() {
            Self::explain_analyze_rollback(stmt, params).await?;
        }
        let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
        let conn = pool.get().await?;
        let rows = conn.query_raw(stmt, params.iter().copied()).await?;
        Ok(rows.map_err(Into::into).boxed())
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
        stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<Row> {
        if Self::is_deep_query_enabled() {
            Self::explain_analyze_rollback(stmt, params).await?;
        }
        let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
        let conn = pool.get().await?;
        let row = conn.query_opt(stmt, params).await?.ok_or(NotFoundError)?;
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
    #[allow(dead_code)]
    pub(crate) async fn modify(stmt: &str, params: &[&(dyn ToSql + Sync)]) -> anyhow::Result<()> {
        if Self::is_deep_query_enabled() {
            Self::explain_analyze_commit(stmt, params).await?;
        } else {
            let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
            let conn = pool.get().await?;
            conn.query(stmt, params).await?;
        }
        Ok(())
    }

    /// Prepend `EXPLAIN ANALYZE` to the query, and rollback the transaction.
    async fn explain_analyze_rollback(
        stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<()> {
        Self::explain_analyze(stmt, params, true).await
    }

    /// Prepend `EXPLAIN ANALYZE` to the query, and commit the transaction.
    #[allow(dead_code)]
    async fn explain_analyze_commit(
        stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<()> {
        Self::explain_analyze(stmt, params, false).await
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
        stmt: &str, params: &[&(dyn ToSql + Sync)], rollback: bool,
    ) -> anyhow::Result<()> {
        let span = debug_span!(
            "query_plan",
            query_statement = stmt,
            params = format!("{:?}", params),
            uuid = uuid::Uuid::new_v4().to_string()
        );

        async move {
            let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
            let mut conn = pool.get().await?;
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
pub fn establish_connection() {
    let (url, user, pass) = Settings::event_db_settings();

    // This was pre-validated and can't fail, but provide default in the impossible case it
    // does.
    let mut config = tokio_postgres::config::Config::from_str(url).unwrap_or_else(|_| {
        error!(url = url, "Postgres URL Pre Validation has failed.");
        tokio_postgres::config::Config::default()
    });
    if let Some(user) = user {
        config.user(user);
    }
    if let Some(pass) = pass {
        config.password(pass);
    }

    let pg_mgr = PostgresConnectionManager::new(config, tokio_postgres::NoTls);

    let pool = Pool::builder().build_unchecked(pg_mgr);

    if EVENT_DB_POOL.set(Arc::new(pool)).is_err() {
        error!("Failed to set event db pool. Called Twice?");
    }
}
