//! Shared state used by all endpoints.
use std::sync::Arc;

use tokio::sync::Mutex;
use tokio_postgres::{types::ToSql, Row};
use tracing::{debug, level_filters::LevelFilter};
use tracing_subscriber::{reload::Handle, Registry};

use crate::{
    event_db::{establish_connection, EventDB},
    logger::LogLevel,
};

#[derive(Clone, Copy, Debug, serde::Deserialize)]
#[serde(rename(deserialize = "lowercase"))]
/// Settings for deep query inspection
pub(crate) enum DeepQueryInspection {
    /// Enable deep query inspection
    Enabled,
    /// Disable deep query inspection
    Disabled,
}

#[derive(Clone, Copy)]
/// Settings for database inspection
pub(crate) struct DatabaseInspectionSettings {
    /// Toggle deep query inspection.
    deep_query: DeepQueryInspection,
    /// UUID for deep query inspection.
    uuid: uuid::Uuid,
}

/// Settings for logger level
pub(crate) struct LoggerSettings {
    /// Reload handle for formatting layer.
    layer_handle: Handle<LevelFilter, Registry>,
}

/// Settings for service inspection during runtime
pub(crate) struct InspectionSettings {
    /// Settings for inspecting the database.
    db: DatabaseInspectionSettings,
    /// Settings for inspecting the logs.
    log: LoggerSettings,
}

impl InspectionSettings {
    /// Create a new inspection settings
    ///
    /// # Arguments
    /// * `deep_query_inspection_enabled` - enable deep query inspection
    /// * `layer_handle` - reload handle for formatting layer
    ///
    /// # Returns
    /// A new inspection settings
    pub(crate) fn new(
        deep_query_inspection_enabled: bool, layer_handle: Handle<LevelFilter, Registry>,
    ) -> Self {
        Self {
            db: DatabaseInspectionSettings {
                deep_query: if deep_query_inspection_enabled {
                    DeepQueryInspection::Enabled
                } else {
                    DeepQueryInspection::Disabled
                },
                uuid: uuid::Uuid::new_v4(),
            },
            log: LoggerSettings { layer_handle },
        }
    }

    /// Modify the deep query inspection setting.
    pub(crate) fn modify_deep_query(&mut self, deep_query: DeepQueryInspection) {
        self.db.deep_query = deep_query;
        self.db.uuid = uuid::Uuid::new_v4();
    }

    /// Modify the logger level setting.
    /// This will reload the logger.
    pub(crate) fn modify_logger_level(&self, level: LogLevel) -> anyhow::Result<()> {
        self.log
            .layer_handle
            .modify(|f| *f = LevelFilter::from_level(level.into()))?;
        Ok(())
    }

    /// Check if deep query inspection is enabled.
    pub(crate) fn is_deep_query_enabled(&self) -> bool {
        match self.db.deep_query {
            DeepQueryInspection::Enabled => true,
            DeepQueryInspection::Disabled => false,
        }
    }

    /// Get the deep query inspection UUID.
    pub(crate) fn get_deep_query_uuid(&self) -> uuid::Uuid {
        self.db.uuid
    }
}

/// Global State of the service
pub(crate) struct State {
    /// This can be None, or a handle to the DB.
    /// If the DB fails, it can be set to None.
    /// If its None, an attempt to get it will try and connect to the DB.
    /// This is Private, it needs to be accessed with a function.
    // event_db_handle: Arc<ArcSwap<Option<dyn EventDbQueries>>>,
    // Private need to get it with a function.
    event_db: Arc<EventDB>, /* This needs to be obsoleted, we want the DB
                             * to be able to be down. */
    /// Settings for service inspection during runtime.
    inspection: Arc<Mutex<InspectionSettings>>,
}

impl State {
    /// Create a new global [`State`]
    pub(crate) async fn new(
        database_url: Option<String>, inspection_settings: InspectionSettings,
    ) -> anyhow::Result<Self> {
        // Get a configured pool to the Database, runs schema version check internally.
        let event_db = Arc::new(establish_connection(database_url).await?);
        let inspection = Arc::new(Mutex::new(inspection_settings));

        let state = Self {
            event_db,
            inspection,
        };

        // We don't care if this succeeds or not.
        // We just try our best to connect to the event DB.
        // let _ = state.event_db().await;

        Ok(state)
    }

    /// Get the reference to the database connection pool for `EventDB`.
    pub(crate) fn event_db(&self) -> Arc<EventDB> {
        self.event_db.clone()
    }

    /// Get the reference to the inspection settings.
    pub(crate) fn inspection_settings(&self) -> Arc<Mutex<InspectionSettings>> {
        self.inspection.clone()
    }

    /// Query the database.
    ///
    /// If deep query inspection is enabled, this will log the query plan inside a
    /// rolled-back transaction, before running the query.
    ///
    /// # Arguments
    /// * `stmt` - `&str` SQL statement.
    /// * `params` - `&[&(dyn ToSql + Sync)]` SQL parameters.
    ///
    /// # Returns
    /// `Result<Vec<Row>, anyhow::Error>`
    pub(crate) async fn query(
        &self, stmt: &str, params: &[&(dyn ToSql + Sync)],
    ) -> Result<Vec<Row>, anyhow::Error> {
        let mut conn = self.event_db.conn().await?;
        let inspection_settings = self.inspection.lock().await;
        if inspection_settings.is_deep_query_enabled() {
            let transaction = conn.transaction().await?;
            let explain_stmt = transaction
                .prepare(format!("EXPLAIN ANALYZE {stmt}").as_str())
                .await?;
            let query_plan = transaction.query_one(&explain_stmt, params).await?;
            debug!(
                { uuid = inspection_settings.get_deep_query_uuid().to_string(), query = stmt },
                "{:#?}", query_plan
            );
            transaction.rollback().await?;
        }
        let rows = conn.query(stmt, params).await?;
        Ok(rows)
    }
}
