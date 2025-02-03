//! Implementation of the POST /message endpoint

use poem_openapi::{
    payload::{Binary, Json},
    ApiResponse,
};

use crate::service::common::{
    objects::legacy::fragments_processing_summary::FragmentsProcessingSummary,
    responses::WithErrorResponses,
};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## No Content
    ///
    /// Contains information about accepted and rejected fragments.
    #[oai(status = 200)]
    Ok(Json<FragmentsProcessingSummary>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # POST /message
///
/// Message post endpoint.
///
/// When successful, returns a summary of fragments accepted and rejected.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_message: Binary<Vec<u8>>) -> AllResponses {
    // otherwise everything seems to be A-OK
    Responses::Ok(Json(FragmentsProcessingSummary::default())).into()
}
