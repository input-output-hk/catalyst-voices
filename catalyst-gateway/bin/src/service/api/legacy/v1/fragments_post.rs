//! Implementation of the GET /fragments endpoint

use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::{
    objects::legacy::{
        fragments_batch::FragmentsBatch, fragments_processing_summary::FragmentsProcessingSummary,
    },
    responses::WithErrorResponses,
};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## Ok
    /// 
    /// Fragments processing summary.
    #[oai(status = 200)]
    Ok(Json<FragmentsProcessingSummary>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET /fragments
///
/// Process a fragments batch.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_fragments_batch: FragmentsBatch) -> AllResponses {
    Responses::Ok(Json(FragmentsProcessingSummary::default())).into()
}
