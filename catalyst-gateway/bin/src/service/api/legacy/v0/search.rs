//! Implementation of /search endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{
    objects::legacy::{
        search::{BadRequest, SearchQuery},
        vote_plan::VotePlan,
    },
    responses::WithErrorResponses,
};

/// Search Post endpoint responses
#[derive(ApiResponse)]
pub(crate) enum SearchResponses {
    /// JSON array with the list of vote plans with their respective data.
    #[oai(status = 200)]
    Ok(Json<Vec<VotePlan>>),
    ///  Invalid combination of table/column (e.g. using funds column on challenges table)
    #[oai(status = 400)]
    #[allow(dead_code)]
    BadRequest(Json<BadRequest>),
}

/// Search post all responses
pub(crate) type SearchAllResponses = WithErrorResponses<SearchResponses>;

/// Search count Post endpoint responses
#[derive(ApiResponse)]
pub(crate) enum SearchCountResponses {
    /// Count of the result set.
    #[oai(status = 200)]
    Ok(Json<i32>),
    ///  Invalid combination of table/column (e.g. using funds column on challenges table)
    #[oai(status = 400)]
    #[allow(dead_code)]
    BadRequest(Json<BadRequest>),
}

/// Search count post all responses
pub(crate) type SearchCountAllResponses = WithErrorResponses<SearchCountResponses>;

/// POST /search
///
/// Search resources.
#[allow(clippy::unused_async)]
pub(crate) async fn search_post(_body: Json<SearchQuery>) -> SearchAllResponses {
    SearchResponses::Ok(Json(Vec::new())).into()
}

/// POST /api/v0/search_count
///
/// Search count.
#[allow(clippy::unused_async)]
pub(crate) async fn search_count_post(_body: Json<i32>) -> SearchCountAllResponses {
    SearchCountResponses::Ok(Json(0)).into()
}
