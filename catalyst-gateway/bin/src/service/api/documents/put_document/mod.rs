//! Implementation of the PUT `/document` endpoint

use bad_put_request::PutDocumentBadRequest;
use bytes::Bytes;
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::responses::WithErrorResponses;

pub(crate) mod bad_put_request;

/// Maximum size of a Signed Document (1MB)
pub(crate) const MAXIMUM_DOCUMENT_SIZE: usize = 1_048_576;

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// The Document was stored OK for the first time.
    #[oai(status = 201)]
    Created,
    /// The Document was already stored, and has not changed.
    #[oai(status = 204)]
    NoContent,
    /// Error Response
    ///
    /// The document submitted is invalid.
    #[oai(status = 400)]
    BadRequest(Json<PutDocumentBadRequest>),
    /// Payload Too Large
    ///
    /// The document exceeds the maximum size of a legitimate single document.
    #[oai(status = 413)]
    PayloadTooLarge,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # PUT `/document`
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(document: Bytes) -> AllResponses {
    let _doc = document;

    Responses::BadRequest(Json(PutDocumentBadRequest::new("unimplemented"))).into()
}
