//! Implementation of the GET /health/inspection endpoint

use std::sync::Arc;

use poem::web::Data;
use poem_extensions::{response, UniResponse::T204};
use tracing::{debug, error};

use crate::{
    logger::LogLevel,
    service::common::responses::{
        resp_2xx::NoContent,
        resp_4xx::ApiValidationError,
        resp_5xx::{ServerError, ServiceUnavailable},
    },
    state::{DeepQueryInspection, State},
};

/// All responses
pub(crate) type AllResponses = response! {
    204: NoContent,
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET /health/inspection
///
/// Inspection settings endpoint.
///
///
/// ## Responses
///
/// * 204 No Content - Service is Started and can  serve requests.
/// * 400 API Validation Error
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service has not started, do not send other requests.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    state: Data<&Arc<State>>, log_level: Option<LogLevel>,
    query_inspection: Option<DeepQueryInspection>,
) -> AllResponses {
    if let Some(level) = log_level {
        let inspection_settings = state.inspection_settings();
        let settings = inspection_settings.read().await;
        match settings.modify_logger_level(level) {
            Ok(()) => debug!("successfully set log level to: {:?}", level),
            Err(_) => {
                error!("failed to set log level: {:?}", level);
            },
        }
    }

    if let Some(inspection_mode) = query_inspection {
        let event_db = state.event_db();
        event_db.modify_deep_query(inspection_mode).await;
        debug!(
            "successfully set deep query inspection mode to: {:?}",
            inspection_mode
        );
    }
    // otherwise everything seems to be A-OK
    T204(NoContent)
}
