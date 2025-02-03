//! Implementation of the GET /health/inspection endpoint
use poem_openapi::{ApiResponse, Enum};
use tracing::debug;

use crate::{db::event::EventDB, logger, service::common::responses::WithErrorResponses};

/// Set of all log levels which can be selected.
#[derive(Debug, Clone, Copy, Enum)]
#[oai(rename_all = "lowercase")]
pub(crate) enum LogLevel {
    /// Debug messages
    Debug,
    /// Informational Messages
    Info,
    /// Warnings
    Warn,
    /// Errors
    Error,
}

impl From<LogLevel> for logger::LogLevel {
    fn from(val: LogLevel) -> Self {
        match val {
            LogLevel::Debug => logger::LogLevel::Debug,
            LogLevel::Info => logger::LogLevel::Info,
            LogLevel::Warn => logger::LogLevel::Warn,
            LogLevel::Error => logger::LogLevel::Error,
        }
    }
}

/// Enable or Disable Deep Database Query Inspection.
#[derive(Debug, Clone, Copy, Enum)]
#[oai(rename_all = "lowercase")]
pub(crate) enum DeepQueryInspectionFlag {
    /// Enable deep query inspection
    Enabled,
    /// Disable deep query inspection
    Disabled,
}

impl From<DeepQueryInspectionFlag> for bool {
    fn from(val: DeepQueryInspectionFlag) -> Self {
        match val {
            DeepQueryInspectionFlag::Enabled => true,
            DeepQueryInspectionFlag::Disabled => false,
        }
    }
}

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## No Content
    /// 
    /// Service is Started and can serve requests.
    #[oai(status = 204)]
    NoContent,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET /health/inspection
///
/// Inspection settings endpoint.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    log_level: Option<LogLevel>, query_inspection: Option<DeepQueryInspectionFlag>,
) -> AllResponses {
    if let Some(level) = log_level {
        logger::modify_logger_level(level.into());
    }

    if let Some(inspection_mode) = query_inspection {
        EventDB::modify_deep_query(inspection_mode.into());
        debug!(
            "successfully set deep query inspection mode to: {:?}",
            inspection_mode
        );
    }
    // otherwise everything seems to be A-OK
    Responses::NoContent.into()
}
