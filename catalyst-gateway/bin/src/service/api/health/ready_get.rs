//! Implementation of the GET /health/ready endpoint

use std::sync::Arc;

use poem::web::Data;
use poem_extensions::{
    response,
    UniResponse::{T204, T503},
};

use crate::{
    event_db::schema_check::MismatchedSchemaError,
    service::common::responses::{
        resp_2xx::NoContent,
        resp_4xx::ApiValidationError,
        resp_5xx::{handle_5xx_response, ServerError, ServiceUnavailable},
    },
    state::State,
};

/// All responses
pub(crate) type AllResponses = response! {
    204: NoContent,
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

/// # GET /health/ready
///
/// Readiness endpoint.
///
/// Kubernetes (and others) use this endpoint to determine if the service is
/// able to service requests.
///
/// In this service, readiness is guaranteed if this endpoint is reachable.
/// So, it will always just return 204.
///
/// In theory it can also return 503 if for some reason a temporary circumstance
/// is preventing this service from properly serving request.
///
/// An example could be the service has started a long and cpu intensive task
/// and is not able to properly service requests while it is occurring.
/// This would let the load balancer shift traffic to other instances of this
/// service that are ready.
///
/// ## Responses
///
/// * 204 No Content - Service is Ready to serve requests.
/// * 400 API Validation Error
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service is not ready, do not send other requests.
pub(crate) async fn endpoint(state: Data<&Arc<State>>) -> AllResponses {
    match state.event_db().schema_version_check().await {
        Ok(_) => {
            tracing::debug!("DB schema version status ok");
            T204(NoContent)
        },
        Err(err) if err.is::<MismatchedSchemaError>() => {
            tracing::error!("{err}");
            T503(ServiceUnavailable)
        },
        Err(err) => handle_5xx_response!(err),
    }
}
