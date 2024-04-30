//! Implementation of the POST /message endpoint

use poem_openapi::{
    payload::{Binary, Json},
    ApiResponse,
};

use crate::service::common::objects::legacy::fragments_processing_summary::FragmentsProcessingSummary;

/// All responses
#[derive(ApiResponse)]
pub(crate) enum AllResponses {
    /// Contains information about accepted and rejected fragments.
    #[oai(status = 200)]
    Ok(Json<FragmentsProcessingSummary>),
}

/// # POST /message
///
/// Message post endpoint.
///
/// When successful, returns a summary of fragments accepted and rejected.
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(_message: Binary<Vec<u8>>) -> AllResponses {
    // otherwise everything seems to be A-OK
    AllResponses::Ok(Json(FragmentsProcessingSummary::default()))
}
