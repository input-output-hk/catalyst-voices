//! Implementation of the GET `/document` endpoint

use catalyst_signed_doc::CatalystSignedDocument;
use poem_openapi::ApiResponse;

use super::templates::get_doc_static_template;
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
pub(crate) async fn endpoint(document_id: uuid::Uuid, version: Option<uuid::Uuid>) -> AllResponses {
    match get_document(&document_id, version.as_ref()).await {
        Ok(doc) => {
            match minicbor::to_vec(&doc) {
                Ok(doc_cbor_bytes) => Responses::Ok(Cbor(doc_cbor_bytes)).into(),
                Err(err) => AllResponses::handle_error(&err.into()),
            }
        },
        Err(err) if err.is::<NotFoundError>() => Responses::NotFound.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
}

/// Get document from the database
pub(crate) async fn get_document(
    document_id: &uuid::Uuid, version: Option<&uuid::Uuid>,
) -> anyhow::Result<CatalystSignedDocument> {
    // Find the doc in the static templates first
    if let Some(doc) = get_doc_static_template(document_id) {
        return Ok(doc);
    }

    // If doesn't exist in the static templates, try to find it in the database
    let db_doc = FullSignedDoc::retrieve(document_id, version).await?;
    let doc = minicbor::decode(db_doc.raw())?;
    Ok(doc)
}

/// A struct which implements a
/// `catalyst_signed_doc::providers::CatalystSignedDocumentProvider` trait
pub(crate) struct DocProvider;

impl catalyst_signed_doc::providers::CatalystSignedDocumentProvider for DocProvider {
    async fn try_get_doc(
        &self, doc_ref: &catalyst_signed_doc::DocumentRef,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        let id = doc_ref.id.uuid();
        let ver = doc_ref.ver.map(|uuid| uuid.uuid());
        match get_document(&id, ver.as_ref()).await {
            Ok(doc) => Ok(Some(doc)),
            Err(err) if err.is::<NotFoundError>() => Ok(None),
            Err(err) => Err(err),
        }
    }
}
