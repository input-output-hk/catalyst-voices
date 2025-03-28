//! Implementation of the GET `/document` endpoint

use poem_openapi::ApiResponse;

use super::common;
use crate::{
    db::event::error::NotFoundError,
    service::common::{responses::WithErrorResponses, types::payload::cbor::Cbor},
};

/// Endpoint responses.
#[derive(ApiResponse)]
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
pub(crate) async fn endpoint(document_id: uuid::Uuid, version: Option<uuid::Uuid>) -> AllResponses {
    match common::get_document(&document_id, version.as_ref()).await {
        Ok(doc) => {
            match doc.try_into() {
                Ok(doc_cbor_bytes) => Responses::Ok(Cbor(doc_cbor_bytes)).into(),
                Err(err) => AllResponses::handle_error(&err),
            }
        },
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
}
