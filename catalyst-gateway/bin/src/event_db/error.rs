//! Database Errors

use bb8::RunError;

/// DB connection timeout error
#[derive(thiserror::Error, Debug)]
#[error("Connection to DB timed out")]
pub(crate) struct TimedOutError(#[from] RunError<tokio_postgres::Error>);

/// Event database errors
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
pub(crate) enum Error {
    /// Cannot find this item
    #[error("Cannot find this item")]
    NotFound,
    /// DB connection timeout
    #[error("Connection to DB timed out")]
    TimedOut,
    /// Unknown error
    #[error("error: {0}")]
    Unknown(String),
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
