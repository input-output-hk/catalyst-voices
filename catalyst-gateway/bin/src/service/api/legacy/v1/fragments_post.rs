//! Implementation of the GET /fragments endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::objects::legacy::{
    fragments_batch::FragmentsBatch, fragments_processing_summary::FragmentsProcessingSummary,
};

/// All responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// Fragments processing summary
    #[oai(status = 200)]
    Ok(Json<FragmentsProcessingSummary>),
}

/// # GET /fragments
///
/// Process a fragments batch.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_fragments_batch: FragmentsBatch) -> AllResponses {
    AllResponses::Ok(Json(FragmentsProcessingSummary::default()))
}
