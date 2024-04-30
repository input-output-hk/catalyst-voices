//! Implementation of the GET /fragments/statuses endpoint

use std::collections::HashMap;

use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::objects::legacy::{
    fragment_status::FragmentStatus, fragments_processing_summary::FragmentId,
};

/// All responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// Statuses of the fragments by id.
    #[oai(status = 200)]
    Ok(Json<HashMap<String, FragmentStatus>>),
}

/// # GET /fragments/statuses
///
/// Get fragments statuses endpoint.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_fragment_ids: Vec<FragmentId>) -> AllResponses {
    AllResponses::Ok(Json(HashMap::new()))
}
