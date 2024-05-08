//! Shared state used by all endpoints.
use std::sync::{Arc, Mutex};

use tracing::level_filters::LevelFilter;
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

/// Settings for service inspection during runtime
pub(crate) struct InspectionSettings {
    /// Toggle deep query inspection.
    pub(crate) deep_query: Arc<Mutex<DeepQueryInspection>>,
    /// Reload handle for logger.
    pub(crate) logger_handle: Handle<LevelFilter, Registry>,
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
    inspection: Arc<InspectionSettings>,
}

impl State {
    /// Create a new global [`State`]
    pub(crate) async fn new(
        database_url: Option<String>, inspection_settings: InspectionSettings,
    ) -> anyhow::Result<Self> {
        // Get a configured pool to the Database, runs schema version check internally.
        let event_db = Arc::new(establish_connection(database_url).await?);
        let inspection = Arc::new(inspection_settings);

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
    pub(crate) fn inspection_settings(&self) -> Arc<InspectionSettings> {
        self.inspection.clone()
    }
}
