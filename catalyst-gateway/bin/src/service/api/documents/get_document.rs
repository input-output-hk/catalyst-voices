//! Implementation of the GET `/document` endpoint

use poem_openapi::ApiResponse;

use crate::{
    db::event::{error::NotFoundError, signed_docs::FullSignedDoc},
    service::common::{responses::WithErrorResponses, types::payload::cbor::Cbor},
};

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
    match FullSignedDoc::retrieve(&document_id, version.as_ref()).await {
        Ok(doc) => Responses::Ok(doc.raw().clone().into()).into(),
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
}
