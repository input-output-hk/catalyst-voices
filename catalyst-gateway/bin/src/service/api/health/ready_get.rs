//! Implementation of the GET /health/ready endpoint

use poem_extensions::{response, UniResponse::T204};

use crate::service::common::responses::{
    resp_2xx::NoContent,
    resp_5xx::{ServerError, ServiceUnavailable},
};
use crate::{
    service::common::responses::{
        resp_2xx::NoContent,
        resp_5xx::{server_error, ServerError, ServiceUnavailable},
    },
    state::State,
};
use poem::web::Data;
use poem_extensions::response;
use poem_extensions::UniResponse::{T204, T500, T503};
use std::sync::Arc;

/// All responses
pub(crate) type AllResponses = response! {
    204: NoContent,
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
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service is not ready, do not send other requests.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(state: Data<&Arc<State>>) -> AllResponses {
    match state.event_db.schema_version_check().await {
        Ok(_) => T204(NoContent),
        Err(crate::event_db::error::Error::TimedOut) => T503(ServiceUnavailable),
        Err(err) => T500(server_error!("{}", err.to_string())),
    }
}
