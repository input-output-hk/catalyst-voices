//! Database Errors

use bb8::RunError;

/// DB not found error
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
#[error("Cannot find this item")]
pub(crate) struct NotFoundError;

/// DB connection timeout error
#[derive(thiserror::Error, Debug)]
#[error("Connection to DB timed out")]
pub(crate) struct TimedOutError(#[from] RunError<tokio_postgres::Error>);
