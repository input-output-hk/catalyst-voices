//! Implementation of the GET `/document` endpoint

use poem_openapi::ApiResponse;

use crate::{
    db::event::signed_docs::FullSignedDoc,
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
    match FullSignedDoc::retrieve_one(&document_id, version.as_ref()).await {
        Ok(Some(doc)) => Responses::Ok(Cbor(doc.raw().to_vec())).into(),
        Ok(None) => Responses::NotFound.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
}
