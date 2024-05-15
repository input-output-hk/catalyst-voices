//! Catalyst Election Database crate
use std::{str::FromStr, sync::Arc};

use bb8::Pool;
use bb8_postgres::PostgresConnectionManager;
use dotenvy::dotenv;
use tokio::sync::RwLock;
use tokio_postgres::{types::ToSql, NoTls, Row};
use tracing::{debug, debug_span, Instrument};

use crate::state::{DatabaseInspectionSettings, DeepQueryInspection};

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

#[allow(unused)]
/// Connection to the Election Database
pub(crate) struct EventDB {
    /// Internal database connection.  DO NOT MAKE PUBLIC.
    /// All database operations (queries, inserts, etc) should be constrained
    /// to this crate and should be exported with a clean data access api.
    pool: Pool<PostgresConnectionManager<NoTls>>,
    /// Settings for inspecting the database.
    inspection_settings: Arc<RwLock<DatabaseInspectionSettings>>,
}

/// No DB URL was provided
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
#[error("DB URL is undefined")]
pub(crate) struct NoDatabaseUrlError;

impl EventDB {
    /// Determine if deep query inspection is enabled.
    pub(crate) async fn is_deep_query_enabled(&self) -> bool {
        self.inspection_settings.read().await.deep_query == DeepQueryInspection::Enabled
    }

    /// Modify the deep query inspection setting.
    ///
    /// # Arguments
    ///
    /// * `deep_query` - `DeepQueryInspection` setting.
    pub(crate) async fn modify_deep_query(&self, deep_query: DeepQueryInspection) {
        let mut settings = self.inspection_settings.write().await;
        settings.deep_query = deep_query;
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
            self.explain_analyze(stmt, params, true).await?;
        }
        let conn = self.pool.get().await?;
        let rows = conn.query(stmt, params).await?;
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
            self.explain_analyze(stmt, params, true).await?;
        }
        let conn = self.pool.get().await?;
        let row = conn.query_one(stmt, params).await?;
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
    /// `Result<(), anyhow::Error>`
    pub(crate) async fn modify(
        &self, stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> Result<(), anyhow::Error> {
        if self.is_deep_query_enabled().await {
            self.explain_analyze(stmt, params, false).await?;
        }
        let conn = self.pool.get().await?;
        let _row = conn.query(stmt, params).await?;
        Ok(())
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
        None => std::env::var(DATABASE_URL_ENVVAR).map_err(|_| NoDatabaseUrlError)?,
    };

    let config = tokio_postgres::config::Config::from_str(&database_url)?;

    let pg_mgr = PostgresConnectionManager::new(config, tokio_postgres::NoTls);

    let pool = Pool::builder().build(pg_mgr).await?;

    Ok(EventDB {
        pool,
        inspection_settings: Arc::new(RwLock::new(DatabaseInspectionSettings::default())),
    })
}
