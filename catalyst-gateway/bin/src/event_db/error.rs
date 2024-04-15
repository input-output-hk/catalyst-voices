//! Database Errors
use std::env::VarError;

use bb8::RunError;

/// Event database errors
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
pub(crate) enum Error {
    /// Schema in database does not match schema supported by the Crate.
    #[error(" Schema in database does not match schema supported by the Crate. The current schema version: {was}, the schema version we expected: {expected}")]
    MismatchedSchema {
        /// The current DB schema version.
        was: i32,
        /// The expected DB schema version.
        expected: i32,
    },
    /// No DB URL was provided
    #[error("DB URL is undefined")]
    NoDatabaseUrl,
    /// Cannot find this item
    #[error("Cannot find this item")]
    NotFound,
    /// DB connection timeout
    #[error("Connection to DB timed out")]
    TimedOut,
    /// Unknown error
    #[error("error: {0}")]
    Unknown(String),
    /// Variable error
    #[error(transparent)]
    VarErr(#[from] VarError),
    /// No config
    #[error("No config")]
    NoConfig,
    /// JSON Parsing error
    #[error("Unable to parse database data: {0}")]
    JsonParseIssue(String),
    /// Unable to extract policy assets
    #[error("Unable parse assets: {0}")]
    AssetParsingIssue(String),
    /// Unable to extract hashed witnesses
    #[allow(dead_code)]
    #[error("Unable to extract hashed witnesses: {0}")]
    HashedWitnessExtraction(String),
}

impl From<RunError<tokio_postgres::Error>> for Error {
    fn from(val: RunError<tokio_postgres::Error>) -> Self {
        match val {
            RunError::TimedOut => Self::TimedOut,
            RunError::User(_) => Self::Unknown(val.to_string()),
        }
    }
}

impl From<tokio_postgres::Error> for Error {
    fn from(val: tokio_postgres::Error) -> Self {
        Self::Unknown(val.to_string())
    }
}
