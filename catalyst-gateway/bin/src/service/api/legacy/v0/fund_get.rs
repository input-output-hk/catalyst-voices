//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    #[oai(status = 200)]
    Ok(Json<dto::FundDto>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    Responses::Ok(Json(dto::FundDto::default())).into()
}

pub(crate) mod dto {
    use poem_openapi::Object;

    #[derive(Object, Default)]
    pub(crate) struct FundDto {
        id: String,
    }
}
