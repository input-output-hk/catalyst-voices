//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{objects::legacy::proposal::Proposal, responses::WithErrorResponses};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success response.
    #[oai(status = 200)]
    Ok(Json<Vec<Proposal>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    Responses::Ok(Json(Default::default())).into()
}
