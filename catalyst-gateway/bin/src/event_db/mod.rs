//! Catalyst Election Database crate
use std::str::FromStr;

use bb8::Pool;
use bb8_postgres::PostgresConnectionManager;
use dotenvy::dotenv;
use error::Error;
use tokio_postgres::NoTls;

mod config_table;
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
pub(crate) async fn establish_connection(
    url: Option<String>, do_schema_check: bool,
) -> Result<EventDB, Error> {
    // Support env vars in a `.env` file,  doesn't need to exist.
    dotenv().ok();

    let database_url = match url {
        Some(url) => url,
        // If the Database connection URL is not supplied, try and get from the env var.
        None => std::env::var(DATABASE_URL_ENVVAR).map_err(|_| Error::NoDatabaseUrl)?,
    };

    let config = tokio_postgres::config::Config::from_str(&database_url)?;

    let pg_mgr = PostgresConnectionManager::new(config, tokio_postgres::NoTls);

    let pool = Pool::builder().build(pg_mgr).await?;

    let db = EventDB { pool };

    if do_schema_check {
        db.schema_version_check().await?;
    }

    Ok(db)
}
