//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    #[oai(status = 200)]
    Ok(Json<Vec<u8>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_message: Vec<u8>) -> AllResponses {
    Responses::Ok(Json(Vec::new())).into()
}