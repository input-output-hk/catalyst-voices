//! Shared state used by all endpoints.
use std::sync::{Arc, Mutex};

use crate::{
    cli::Error,
    event_db::{establish_connection, queries::EventDbQueries},
};

/// The status of the expected DB schema version.
pub(crate) enum SchemaVersionStatus {
    /// The current DB schema version matches what is expected.
    Ok,
    /// There is a mismatch between the current DB schema version
    /// and what is expected.
    Mismatch,
}

/// Global State of the service
pub(crate) struct State {
    /// This can be None, or a handle to the DB.
    /// If the DB fails, it can be set to None.
    /// If its None, an attempt to get it will try and connect to the DB.
    /// This is Private, it needs to be accessed with a function.
    // event_db_handle: Arc<ArcSwap<Option<dyn EventDbQueries>>>,
    // Private need to get it with a function.
    pub(crate) event_db: Arc<dyn EventDbQueries>, /* This needs to be obsoleted, we want the DB
                                                   * to be able to be down. */
    /// Status of the last DB schema version check.
    pub(crate) schema_version_status: Mutex<SchemaVersionStatus>,
}

impl State {
    /// Create a new global [`State`]
    pub(crate) async fn new(database_url: Option<String>) -> Result<Self, Error> {
        // Get a configured pool to the Database, runs schema version check internally.
        let event_db = Arc::new(establish_connection(database_url, false).await?);

        let state = Self {
            event_db,
            // It is safe to assume that the schema version matches if `event_db` doesn't fail,
            // due to the interior check ran by `establish_connection`.
            schema_version_status: Mutex::new(SchemaVersionStatus::Ok),
        };

        // We don't care if this succeeds or not.
        // We just try our best to connect to the event DB.
        // let _ = state.event_db().await;

        Ok(state)
    }

    // pub(crate) async fn event_db(&self) -> Option<Arc<dyn EventDbQueries>> {
    //
    //
    // }
}
