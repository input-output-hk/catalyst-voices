//! Test validation in a GET endpoint

use std::sync::Arc;

use poem_extensions::{
    response,
    UniResponse::{T204, T503},
};
use tracing::{error, info, warn};

use crate::{
    service::common::responses::{
        resp_2xx::NoContent,
        resp_4xx::ApiValidationError,
        resp_5xx::{ServerError, ServiceUnavailable},
    },
    state::State,
};

/// # All Responses
pub(crate) type AllResponses = response! {
    204: NoContent,
    400: ApiValidationError,
    500: ServerError,
    503: ServiceUnavailable,
};

#[derive(::poem_openapi::Enum, Debug, Eq, PartialEq, Hash, Clone)]
/// A query parameter that is one of these animals.
pub(crate) enum Animals {
    /// Preferred pet is dogs
    Dogs,
    /// Preferred pet is cats
    Cats,
    /// Preferred pet is rabbits
    Rabbits,
}

/// # GET /test/test
///
/// Just a test endpoint.
///
/// Always logs at info level.
/// If the id parameter is 10, it will log at warn level.
/// If the id parameter is 15, it will log at error level, and return a 503.
/// If the id parameter is 20, it will panic.
///
/// ## Responses
///
/// * 204 No Content - Service is OK and can keep running.
/// * 400 API Validation Error
/// * 500 Server Error - If anything within this function fails unexpectedly. (Possible
///   but unlikely)
/// * 503 Service Unavailable - Service is possibly not running reliably.
#[allow(clippy::unused_async, clippy::panic)]
pub(crate) async fn endpoint(
    _state: Arc<State>, id: i32, action: &String, pet: &Option<Vec<Animals>>,
) -> AllResponses {
    info!("id: {id:?}, action: {action:?} pet: {pet:?}");
    let response: AllResponses = match id {
        10 => {
            warn!("id: {id:?}, action: {action:?}");
            T204(NoContent)
        },
        15 => {
            error!("id: {id:?}, action: {action:?}");
            T503(ServiceUnavailable)
        },
        20 => {
            // Intentional panic for testing purposes - Allowed above.
            panic!("id: {id:?}, action: {action:?}");
        },
        _ => T204(NoContent),
    };

    response
}
