//! Implementation of /challenges endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{
    objects::legacy::challenges::{BadRequest, Challenge},
    responses::WithErrorResponses,
};

/// Challenges Get endpoint responses
#[derive(ApiResponse)]
pub(crate) enum ChallengesResponses {
    /// Valid response.
    #[oai(status = 200)]
    Ok(Json<Challenge>),
    /// The requested challenge was not found.
    #[oai(status = 400)]
    #[allow(dead_code)]
    BadRequest(Json<BadRequest>),
}

/// Challenge Get all responses
pub(crate) type SearchAllResponses = WithErrorResponses<ChallengesResponses>;

/// GET /challenges
///
/// Get all available challenges.
#[allow(clippy::unused_async)]
pub(crate) async fn challenges_get(body: Json<Challenge>) -> SearchAllResponses {
    ChallengesResponses::Ok(body).into()
}

pub(crate) async fn challenges_id_get(id: i32) -> SearchAllResponses {
   
}