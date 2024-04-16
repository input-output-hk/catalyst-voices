//! Database Errors

/// DB not found error
#[derive(thiserror::Error, Debug, PartialEq, Eq)]
#[error("Cannot find this item")]
pub(crate) struct NotFoundError;
