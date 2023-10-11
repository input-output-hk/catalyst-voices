//! Catalyst Election Database crate
use bb8::Pool;
use bb8_postgres::PostgresConnectionManager;
use dotenvy::dotenv;
use error::Error;
use schema_check::SchemaVersion;
use std::str::FromStr;
use tokio_postgres::NoTls;

mod config_table;
pub mod error;
pub mod queries;
pub mod schema_check;
pub mod types;

/// Database URL Environment Variable name.
/// eg: "`postgres://catalyst-dev:CHANGE_ME@localhost/CatalystDev`"
const DATABASE_URL_ENVVAR: &str = "EVENT_DB_URL";

/// Database version this crate matches.
/// Must equal the last Migrations Version Number.
pub const DATABASE_SCHEMA_VERSION: i32 = 9;

#[allow(unused)]
/// Connection to the Election Database
pub struct EventDB {
    // Internal database connection.  DO NOT MAKE PUBLIC.
    // All database operations (queries, inserts, etc) should be constrained
    // to this crate and should be exported with a clean data access api.
    pool: Pool<PostgresConnectionManager<NoTls>>,
}

/// Establish a connection to the database, and check the schema is up-to-date.
///
/// # Parameters
///
/// * `url` set to the postgres connection string needed to connect to the
///   database.  IF it is None, then the env var "`DATABASE_URL`" will be used
///   for this connection string. eg:
///     "`postgres://catalyst-dev:CHANGE_ME@localhost/CatalystDev`"
///
/// # Errors
///
/// This function will return an error if:
/// * `url` is None and the environment variable "`DATABASE_URL`" isn't set.
/// * There is any error communicating the the database to check its schema.
/// * The database schema in the DB does not 100% match the schema supported by
///   this library.
///
/// # Notes
///
/// The env var "`DATABASE_URL`" can be set directly as an anv var, or in a
/// `.env` file.
pub async fn establish_connection(url: Option<&str>) -> Result<EventDB, Error> {
    // Support env vars in a `.env` file,  doesn't need to exist.
    dotenv().ok();

    let database_url = match url {
        Some(url) => url.to_string(),
        // If the Database connection URL is not supplied, try and get from the env var.
        None => std::env::var(DATABASE_URL_ENVVAR)?,
    };

    let config = tokio_postgres::config::Config::from_str(&database_url)?;

    let pg_mgr = PostgresConnectionManager::new(config, tokio_postgres::NoTls);

    let pool = Pool::builder().build(pg_mgr).await?;

    let db = EventDB { pool };

    db.schema_version_check().await?;

    Ok(db)
}

/// Need to setup and run a test event db instance
/// To do it you can use the following commands:
/// Prepare docker images
/// ```
/// earthly ./containers/event-db-migrations+docker --data=test
/// ```
/// Run event-db container
/// ```
/// docker-compose -f src/event-db/docker-compose.yml up migrations
/// ```
/// Also need establish `EVENT_DB_URL` env variable with the following value
/// ```
/// EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
/// ```
/// https://github.com/input-output-hk/catalyst-core/tree/main/src/event-db/Readme.md
#[cfg(test)]
mod test {
    use super::*;

    /// Check if the schema version in the DB is up to date.
    #[tokio::test]
    async fn check_schema_version() {
        establish_connection(None).await.unwrap();
    }
}
