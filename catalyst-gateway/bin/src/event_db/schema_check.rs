//! Check if the schema is up-to-date.

use crate::event_db::{Error, EventDB, DATABASE_SCHEMA_VERSION};

impl EventDB {
    /// Check the schema version.
    /// return the current schema version if its current.
    /// Otherwise return an error.
    pub(crate) async fn schema_version_check(&self) -> Result<i32, Error> {
        let conn = self.pool.get().await?;
        let schema_check = conn
            .query_one("SELECT MAX(version) FROM refinery_schema_history;", &[])
            .await?;

        let current_ver = schema_check.try_get("max")?;

        if current_ver == DATABASE_SCHEMA_VERSION {
            Ok(current_ver)
        } else {
            Err(Error::MismatchedSchema {
                was: current_ver,
                expected: DATABASE_SCHEMA_VERSION,
            })
        }
    }
}
