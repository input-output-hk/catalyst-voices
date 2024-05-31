//! Shared state used by all endpoints.
use std::sync::Arc;

use tracing::level_filters::LevelFilter;
use tracing_subscriber::{reload::Handle, Registry};

use crate::{
    event_db::{establish_connection, EventDB},
    logger::LogLevel,
};

/// Settings for logger level
pub(crate) struct LoggerSettings {
    /// Logger handle for formatting layer.
    logger_handle: Handle<LevelFilter, Registry>,
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
    /// Logger settings
    logger_settings: Arc<LoggerSettings>,
}

impl State {
    /// Create a new global [`State`]
    pub(crate) async fn new(
        database_url: Option<String>, logger_handle: Handle<LevelFilter, Registry>,
    ) -> anyhow::Result<Self> {
        // Get a configured pool to the Database, runs schema version check internally.
        let event_db = Arc::new(establish_connection(database_url).await?);
        let logger_settings = Arc::new(LoggerSettings { logger_handle });

        let state = Self {
            event_db,
            logger_settings,
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

    /// Modify the logger level setting.
    /// This will reload the logger.
    pub(crate) fn modify_logger_level(&self, level: LogLevel) -> anyhow::Result<()> {
        self.logger_settings
            .logger_handle
            .modify(|f| *f = LevelFilter::from_level(level.into()))?;
        Ok(())
    }
}
