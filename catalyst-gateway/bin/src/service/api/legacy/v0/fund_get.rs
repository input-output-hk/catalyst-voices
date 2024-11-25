//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{objects::legacy::fund::Fund, responses::WithErrorResponses};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success response.
    #[oai(status = 200)]
    Ok(Json<Fund>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    Responses::Ok(Json(Fund::default())).into()
}
