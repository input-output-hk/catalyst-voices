//! Shared state used by all endpoints.
use std::sync::{Arc, Mutex, MutexGuard};

use crate::{
    cli::Error,
    event_db::{establish_connection, EventDB},
    service::Error as ServiceError,
};

/// The status of the expected DB schema version.
#[derive(Debug, PartialEq, Eq)]
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
    event_db: Arc<EventDB>, /* This needs to be obsoleted, we want the DB
                             * to be able to be down. */
    /// Status of the last DB schema version check.
    schema_version_status: Mutex<SchemaVersionStatus>,
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

    /// Get the reference to the database connection pool for `EventDB`.
    #[allow(dead_code)]
    pub(crate) fn event_db(&self) -> Result<Arc<EventDB>, Error> {
        let guard = self.schema_version_status_lock();
        match *guard {
            SchemaVersionStatus::Ok => Ok(self.event_db.clone()),
            SchemaVersionStatus::Mismatch => Err(ServiceError::SchemaVersionMismatch.into()),
        }
    }

    /// Check the DB schema version matches the one expected by the service.
    pub(crate) async fn schema_version_check(&self) -> Result<i32, Error> {
        Ok(self.event_db.schema_version_check().await?)
    }

    /// Compare the `State`'s inner value with a given `&SchemaVersionStatus`, returns
    /// `bool`.
    pub(crate) fn is_schema_version_status(&self, svs: &SchemaVersionStatus) -> bool {
        let guard = self.schema_version_status_lock();
        &*guard == svs
    }

    /// Set the state's `SchemaVersionStatus`.
    pub(crate) fn set_schema_version_status(&self, svs: SchemaVersionStatus) {
        let mut guard = self.schema_version_status_lock();
        tracing::debug!(
            status = format!("{:?}", svs),
            "db schema version status was set"
        );
        *guard = svs;
    }

    /// Get the `MutexGuard<SchemaVersionStatus>` from inner the variable.
    ///
    /// Handle poisoned mutex by recovering the guard, and tracing the error.
    fn schema_version_status_lock(&self) -> MutexGuard<SchemaVersionStatus> {
        match self.schema_version_status.lock() {
            Ok(guard) => guard,
            Err(poisoned) => {
                tracing::error!(
                    error = format!("{:?}", poisoned),
                    "recovering DB schema version status fom poisoned mutex"
                );
                poisoned.into_inner()
            },
        }
    }
}
