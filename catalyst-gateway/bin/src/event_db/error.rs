//! Database Errors

/// DB not found error
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
#[error("Cannot find this item")]
pub(crate) struct NotFoundError;
/// DB timeout error
pub(crate) type TimedOutError = bb8::RunError<tokio_postgres::Error>;
