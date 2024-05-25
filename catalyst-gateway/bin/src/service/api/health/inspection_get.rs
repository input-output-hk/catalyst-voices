//! Implementation of the GET /health/inspection endpoint

use std::sync::Arc;

use poem::web::Data;
use poem_openapi::ApiResponse;
use tracing::debug;

use crate::{
    event_db::DeepQueryInspectionFlag, logger::LogLevel,
    service::common::responses::WithErrorResponses, state::State,
};

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
        match state.modify_logger_level(level) {
            Ok(()) => debug!("successfully set log level to: {:?}", level),
            Err(err) => return AllResponses::handle_error(&err),
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
    Responses::NoContent.into()
}
