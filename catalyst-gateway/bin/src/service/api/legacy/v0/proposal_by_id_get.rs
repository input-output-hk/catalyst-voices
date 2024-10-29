//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use super::proposals_get;
use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success resposne.
    #[oai(status = 200)]
    Ok(Json<proposals_get::dto::Proposal>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_id: String) -> AllResponses {
    Responses::Ok(Json(proposals_get::dto::Proposal::default())).into()
}
