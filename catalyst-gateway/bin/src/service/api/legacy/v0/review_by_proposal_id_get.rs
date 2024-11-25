//! Implementation of the GET /setting endpoint
use std::collections::HashMap;

use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{objects::legacy::review::Review, responses::WithErrorResponses};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success response.
    #[oai(status = 200)]
    Ok(Json<HashMap<String, Review>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_id: String) -> AllResponses {
    Responses::Ok(Json(HashMap::default())).into()
}
