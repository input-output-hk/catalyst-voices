//! Catalyst Election Database crate
use std::{
    str::FromStr,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, LazyLock, Mutex, OnceLock,
    },
    time::Duration,
};

use error::NotFoundError;
use futures::{Stream, StreamExt, TryStreamExt};
use tokio::task::JoinHandle;
use tokio_postgres::{types::ToSql, Row};
use tracing::{debug, debug_span, error, info, Instrument};

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
pub(crate) const DATABASE_SCHEMA_VERSION: i32 = 3;

/// Postgres Connection Manager DB Pool
type SqlDbPool = Arc<deadpool::managed::Pool<deadpool_postgres::Manager>>;

/// Postgres Connection Manager DB Pool Instance
static EVENT_DB_POOL: OnceLock<SqlDbPool> = OnceLock::new();

/// Background Event DB probe check
static EVENT_DB_PROBE_TASK: LazyLock<Mutex<Option<JoinHandle<()>>>> =
    LazyLock::new(|| Mutex::new(None));

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
    async fn get_pool_connection(
    ) -> Result<deadpool::managed::Object<deadpool_postgres::Manager>, EventDBConnectionError> {
        let pool = EVENT_DB_POOL
            .get()
            .ok_or(EventDBConnectionError::DbPoolUninitialized)?;
        let res = pool
            .get()
            .await
            .map_err(|_| EventDBConnectionError::PoolConnectionUnavailable)?;
        Ok(res)
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
        stmt: &str,
        params: &[&(dyn ToSql + Sync)],
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
        stmt: &str,
        params: &[&(dyn ToSql + Sync)],
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
        stmt: &str,
        params: &[&(dyn ToSql + Sync)],
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
    pub(crate) async fn modify(
        stmt: &str,
        params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<()> {
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
        Self::schema_version_check()
            .await
            .inspect(|_| {
                if !event_db_liveness {
                    set_event_db_liveness(true);
                }
            })
            .inspect_err(|err| {
                error!(err = err.to_string(), "Event DB connection issues");
                if event_db_liveness {
                    set_event_db_liveness(false);
                }
            })
            .is_ok()
    }

    /// Prepend `EXPLAIN ANALYZE` to the query, and rollback the transaction.
    async fn explain_analyze_rollback(
        stmt: &str,
        params: &[&(dyn ToSql + Sync)],
    ) -> anyhow::Result<()> {
        Self::explain_analyze(stmt, params, true).await
    }

    /// Prepend `EXPLAIN ANALYZE` to the query, and commit the transaction.
    async fn explain_analyze_commit(
        stmt: &str,
        params: &[&(dyn ToSql + Sync)],
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
        stmt: &str,
        params: &[&(dyn ToSql + Sync)],
        rollback: bool,
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

    /// Wait for the Event DB to be ready before continuing
    pub(crate) async fn wait_until_ready(interval: Duration) {
        loop {
            if Self::connection_is_ok().await {
                return;
            }

            tokio::time::sleep(interval).await;
        }
    }

    /// Spawns a background task checking for the Event DB to be
    /// ready.
    /// Could spawn only one background task at a time
    pub(crate) fn spawn_ready_probe() {
        let spawning = || -> anyhow::Result<()> {
            let mut task = EVENT_DB_PROBE_TASK
                .lock()
                .map_err(|e| anyhow::anyhow!("{e}"))?;

            if task.as_ref().is_none_or(JoinHandle::is_finished) {
                /// Event DB probe check wait interval
                const INTERVAL: Duration = Duration::from_secs(1);

                *task = Some(tokio::spawn(async move {
                    Self::wait_until_ready(INTERVAL).await;
                    info!("Event DB is ready");
                }));
            }
            Ok(())
        };

        debug!("Waiting for the Event DB background probe check task to be spawned");
        while let Err(e) = spawning() {
            error!(error = ?e, "EVENT_DB_PROBE_TASK is poisoned, should never happen");
            EVENT_DB_PROBE_TASK.clear_poison();
        }
    }
}

/// Establish a connection pool to the database.
/// After successful initialisation of the connection pool, spawns a background ready
/// probe task.
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
pub fn establish_connection_pool() {
    debug!("Establishing connection with Event DB pool");

    // This was pre-validated and can't fail, but provide default in the impossible case it
    // does.
    let url = Settings::event_db_settings().url();
    let mut config = tokio_postgres::config::Config::from_str(url).unwrap_or_else(|_| {
        error!(url = url, "Postgres URL Pre Validation has failed.");
        tokio_postgres::config::Config::default()
    });
    if let Some(user) = Settings::event_db_settings().username() {
        config.user(user);
    }
    if let Some(pass) = Settings::event_db_settings().password() {
        config.password(pass);
    }

    let pg_mgr = deadpool_postgres::Manager::new(config, tokio_postgres::NoTls);

    match deadpool::managed::Pool::builder(pg_mgr)
        .max_size(Settings::event_db_settings().max_connections() as usize)
        .create_timeout(Some(
            Settings::event_db_settings().connection_creation_timeout(),
        ))
        .wait_timeout(Some(Settings::event_db_settings().slot_wait_timeout()))
        .recycle_timeout(Some(
            Settings::event_db_settings().connection_recycle_timeout(),
        ))
        .runtime(deadpool::Runtime::Tokio1)
        .build()
    {
        Ok(pool) => {
            debug!("Event DB pool configured.");
            if EVENT_DB_POOL.set(Arc::new(pool)).is_err() {
                error!("Failed to set EVENT_DB_POOL. Already set?");
            }
            EventDB::spawn_ready_probe();
        },
        Err(err) => {
            error!(error = %err, "Failed to establish connection with EventDB pool");
        },
    }
}
