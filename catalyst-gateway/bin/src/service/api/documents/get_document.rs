//! Implementation of the GET `/document` endpoint

use poem_openapi::ApiResponse;

use super::templates::get_doc_static_template;
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
    Ok(Cbor<Vec<u8>>),
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
    // Find the doc in the static templates first
    if let Some(doc) = get_doc_static_template(document_id, version) {
        return Responses::Ok(Cbor(doc)).into();
    }

    // If doesn't exist in the static templates, try to find it in the database
    match FullSignedDoc::retrieve(&document_id, version.as_ref()).await {
        Ok(doc) => Responses::Ok(Cbor(doc.raw().clone())).into(),
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
}
