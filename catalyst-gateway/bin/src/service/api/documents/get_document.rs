//! Implementation of the GET `/document` endpoint

use poem_openapi::ApiResponse;

use crate::{
    db::event::{error::NotFoundError, signed_docs::FullSignedDoc},
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
pub(crate) async fn endpoint(
    document_id: uuid::Uuid,
    version: Option<uuid::Uuid>,
) -> AllResponses {
    match FullSignedDoc::retrieve(&document_id, version.as_ref()).await {
        Ok(doc_cbor_bytes) => Responses::Ok(Cbor(doc_cbor_bytes.raw().to_vec())).into(),
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
}
