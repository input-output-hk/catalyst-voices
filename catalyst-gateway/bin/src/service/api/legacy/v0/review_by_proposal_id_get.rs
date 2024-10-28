//! Implementation of the GET /setting endpoint
use std::collections::HashMap;

use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    #[oai(status = 200)]
    Ok(Json<HashMap<String, dto::ReviewItem>>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_id: String) -> AllResponses {
    Responses::Ok(Json(HashMap::default())).into()
}

pub(crate) mod dto {
    use poem_openapi::Object;

    #[derive(Object, Default)]
    pub(crate) struct ReviewItem {
        id: String,
        assessor: String,
        impact_alignment_note: String,
        impact_alignment_rating_given: String,
        auditability_note: String,
        auditability_rating_given: String,
        feasibility_note: String,
        feasibility_rating_given: String,
    }
}