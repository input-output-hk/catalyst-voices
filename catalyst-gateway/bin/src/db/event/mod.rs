//! Catalyst Election Database crate
use std::{
    str::FromStr,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, OnceLock,
    },
};

use bb8::{Pool, PooledConnection};
use bb8_postgres::PostgresConnectionManager;
use error::NotFoundError;
use futures::{Stream, StreamExt, TryStreamExt};
use tokio_postgres::{types::ToSql, NoTls, Row};
use tracing::{debug, debug_span, error, Instrument};

use crate::{
    service::utilities::health::{event_db_is_live, set_event_db_liveness},
    settings::Settings,
};

pub(crate) mod common;
pub(crate) mod config;
pub(crate) mod error;
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
pub(crate) enum EventDBConnectionError {
    /// Failed to get a DB Pool
    #[error("DB Pool uninitialized")]
    DbPoolUninitialized,
    /// Failed to get a DB Pool Connection
    #[error("DB Pool connection is unavailable")]
    PoolConnectionUnavailable,
}

impl EventDB {
    /// Get a connection from the pool.
    async fn get_pool_connection<'a>(
    ) -> Result<PooledConnection<'a, PostgresConnectionManager<NoTls>>, EventDBConnectionError>
    {
        let pool = EVENT_DB_POOL
            .get()
            .ok_or(EventDBConnectionError::DbPoolUninitialized)?;
        pool.get()
            .await
            .map_err(|_| EventDBConnectionError::PoolConnectionUnavailable)
    }

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
        let conn = Self::get_pool_connection().await?;
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
        let conn = Self::get_pool_connection().await?;
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
        let conn = Self::get_pool_connection().await?;
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
    pub(crate) async fn modify(stmt: &str, params: &[&(dyn ToSql + Sync)]) -> anyhow::Result<()> {
        if Self::is_deep_query_enabled() {
            Self::explain_analyze_commit(stmt, params).await?;
        } else {
            let conn = Self::get_pool_connection().await?;
            conn.query(stmt, params).await?;
        }
        Ok(())
    }

    /// Checks that connection to `EventDB` is available.
    pub(crate) async fn connection_is_ok() -> bool {
        let event_db_liveness = event_db_is_live();
        Self::get_pool_connection()
            .await
            .inspect(|_| {
                if !event_db_liveness {
                    set_event_db_liveness(true);
                }
            })
            .inspect_err(|_| {
                if event_db_liveness {
                    set_event_db_liveness(false);
                }
            })
            .is_ok()
    }

    /// Prepend `EXPLAIN ANALYZE` to the query, and rollback the transaction.
    async fn explain_analyze_rollback(
        stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<()> {
        Self::explain_analyze(stmt, params, true).await
    }

    /// Prepend `EXPLAIN ANALYZE` to the query, and commit the transaction.
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
            let mut conn = Self::get_pool_connection().await?;
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
///
/// If connection to the pool is `OK`, the `LIVE_EVENT_DB` atomic flag is set to `true`.
pub async fn establish_connection_pool() {
    let (url, user, pass, max_connections, max_lifetime, min_idle, connection_timeout) =
        Settings::event_db_settings();
    debug!("Establishing connection with Event DB pool");

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

    match Pool::builder()
        .max_size(max_connections)
        .max_lifetime(Some(core::time::Duration::from_secs(max_lifetime.into())))
        .min_idle(min_idle)
        .connection_timeout(core::time::Duration::from_secs(connection_timeout.into()))
        .build(pg_mgr)
        .await
    {
        Ok(pool) => {
            debug!("Event DB pool configured.");
            if EVENT_DB_POOL.set(Arc::new(pool)).is_err() {
                error!("Failed to set EVENT_DB_POOL. Already set?");
            }
        },
        Err(err) => {
            error!(error = %err, "Failed to establish connection with EventDB pool");
        },
    }
}
