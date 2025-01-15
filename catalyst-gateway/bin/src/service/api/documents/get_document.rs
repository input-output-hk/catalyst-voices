//! Implementation of the GET `/document` endpoint

use poem::Body;
use poem_openapi::ApiResponse;

use crate::service::common::{responses::WithErrorResponses, types::payload::cbor::Cbor};

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// ## OK
    ///
    /// The Document that was requested.
    #[oai(status = 200)]
    Ok(Cbor<Body>),
    /// ## Not Found
    ///
    /// The document could not be found.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET `/document`
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(document_id: uuid::Uuid, version: Option<uuid::Uuid>) -> AllResponses {
    let _doc = document_id;
    let _ver = version;

    Responses::NotFound.into()
}
