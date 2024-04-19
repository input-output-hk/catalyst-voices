//! Shared state used by all endpoints.
use std::sync::Arc;

use crate::event_db::{establish_connection, EventDB};

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
}

impl State {
    /// Create a new global [`State`]
    pub(crate) async fn new(database_url: Option<String>) -> anyhow::Result<Self> {
        // Get a configured pool to the Database, runs schema version check internally.
        let event_db = Arc::new(establish_connection(database_url).await?);

        let state = Self { event_db };

        // We don't care if this succeeds or not.
        // We just try our best to connect to the event DB.
        // let _ = state.event_db().await;

        Ok(state)
    }

    /// Get the reference to the database connection pool for `EventDB`.
    pub(crate) fn event_db(&self) -> Arc<EventDB> {
        self.event_db.clone()
    }
}
