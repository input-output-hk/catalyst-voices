//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success response.
    #[oai(status = 200)]
    Ok(Json<dto::FundDto>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    Responses::Ok(Json(dto::FundDto::default())).into()
}

/// The data transfer objects over HTTP
pub(crate) mod dto {
    use poem_openapi::Object;

    #[allow(clippy::missing_docs_in_private_items)]
    #[derive(Object, Default)]
    pub(crate) struct FundDto {
        id: String,
    }
}
