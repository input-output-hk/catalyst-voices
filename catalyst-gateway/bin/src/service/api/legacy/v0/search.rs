//! Implementation of /search endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{objects::legacy::vote_plan::VotePlan, responses::WithErrorResponses};

/// Search Post endpoint responses
#[derive(ApiResponse)]
pub(crate) enum SearchResponses {
    /// JSON array with the list of vote plans with their respective data.
    #[oai(status = 200)]
    Ok(Json<Vec<VotePlan>>),
    ///  Invalid combination of table/column (e.g. using funds column on challenges table)
    #[oai(status = 400)]
    /// FIXME
    BadRequest(Json<BadRequest>),
}

/// All responses
pub(crate) type SearchAllResponses = WithErrorResponses<SearchResponses>;

/// POST /search
///
/// Search resources.
#[allow(clippy::unused_async)]
pub(crate) async fn search_post(body: Json<SearchQuery>) -> SearchAllResponses {
    SearchResponses::Ok(Json(Vec::new())).into()
}
