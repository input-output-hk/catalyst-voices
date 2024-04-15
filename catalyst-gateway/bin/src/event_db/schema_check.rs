//! Check if the schema is up-to-date.

use crate::event_db::{EventDB, DATABASE_SCHEMA_VERSION};

/// Schema in database does not match schema supported by the Crate.
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
#[error(" Schema in database does not match schema supported by the Crate. The current schema version: {was}, the schema version we expected: {expected}")]
pub(crate) struct MismatchedSchemaError {
    /// The current DB schema version.
    was: i32,
    /// The expected DB schema version.
    expected: i32,
}

impl EventDB {
    /// Check the schema version.
    /// return the current schema version if its current.
    /// Otherwise return an error.
    pub(crate) async fn schema_version_check(&self) -> anyhow::Result<i32> {
        let conn = self.pool.get().await?;

        let schema_check = conn
            .query_one(
                include_str!("../../../event-db/queries/schema_check/select_max_version.sql"),
                &[],
            )
            .await?;

        let current_ver = schema_check.try_get("max")?;

        if current_ver == DATABASE_SCHEMA_VERSION {
            Ok(current_ver)
        } else {
            Err(MismatchedSchemaError {
                was: current_ver,
                expected: DATABASE_SCHEMA_VERSION,
            }
            .into())
        }
    }
}
