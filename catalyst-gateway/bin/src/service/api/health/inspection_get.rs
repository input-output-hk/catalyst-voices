//! Implementation of the GET /health/inspection endpoint

use std::sync::Arc;

use poem::web::Data;
use poem_openapi::{ApiResponse, Enum};
use tracing::debug;

use crate::{event_db, logger, service::common::responses::WithErrorResponses, state::State};

/// LogLevel api argument.
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

impl Into<logger::LogLevel> for LogLevel {
    fn into(self) -> logger::LogLevel {
        match self {
            LogLevel::Debug => logger::LogLevel::Debug,
            LogLevel::Info => logger::LogLevel::Info,
            LogLevel::Warn => logger::LogLevel::Warn,
            LogLevel::Error => logger::LogLevel::Error,
        }
    }
}

#[derive(Debug, Clone, Copy, Enum)]
#[oai(rename_all = "lowercase")]
/// Settings for deep query inspection
pub(crate) enum DeepQueryInspectionFlag {
    /// Enable deep query inspection
    Enabled,
    /// Disable deep query inspection
    Disabled,
}

impl Into<event_db::DeepQueryInspectionFlag> for DeepQueryInspectionFlag {
    fn into(self) -> event_db::DeepQueryInspectionFlag {
        match self {
            DeepQueryInspectionFlag::Enabled => event_db::DeepQueryInspectionFlag::Enabled,
            DeepQueryInspectionFlag::Disabled => event_db::DeepQueryInspectionFlag::Disabled,
        }
    }
}

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Service is Started and can serve requests.
    #[oai(status = 204)]
    NoContent,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET /health/inspection
///
/// Inspection settings endpoint.
pub(crate) async fn endpoint(
    state: Data<&Arc<State>>, log_level: Option<LogLevel>,
    query_inspection: Option<DeepQueryInspectionFlag>,
) -> AllResponses {
    if let Some(level) = log_level {
        match state.modify_logger_level(level.into()) {
            Ok(()) => debug!("successfully set log level to: {:?}", level),
            Err(err) => return AllResponses::handle_error(&err),
        }
    }

    if let Some(inspection_mode) = query_inspection {
        let event_db = state.event_db();
        event_db.modify_deep_query(inspection_mode.into()).await;
        debug!(
            "successfully set deep query inspection mode to: {:?}",
            inspection_mode
        );
    }
    // otherwise everything seems to be A-OK
    Responses::NoContent.into()
}
