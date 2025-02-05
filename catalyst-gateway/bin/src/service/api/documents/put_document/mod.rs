//! Implementation of the PUT `/document` endpoint

use anyhow::anyhow;
use bad_put_request::PutDocumentBadRequest;
use catalyst_signed_doc::CatalystSignedDocument;
use poem_openapi::{payload::Json, ApiResponse};

use crate::{
    db::event::signed_docs::{FullSignedDoc, SignedDocBody},
    service::common::responses::WithErrorResponses,
};

pub(crate) mod bad_put_request;

/// Maximum size of a Signed Document (1MB)
pub(crate) const MAXIMUM_DOCUMENT_SIZE: usize = 1_048_576;

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## Created
    ///
    /// The Document was stored OK for the first time.
    #[oai(status = 201)]
    Created,
    /// ## No Content
    ///
    /// The Document was already stored, and has not changed.
    #[oai(status = 204)]
    NoContent,
    /// ## Bad Request
    ///
    /// Error Response. The document submitted is invalid.
    #[oai(status = 400)]
    BadRequest(Json<PutDocumentBadRequest>),
    /// ## Content Too Large
    ///
    /// Payload Too Large. The document exceeds the maximum size of a legitimate single
    /// document.
    #[oai(status = 413)]
    PayloadTooLarge,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # PUT `/document`
#[allow(clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(doc_bytes: Vec<u8>) -> AllResponses {
    match CatalystSignedDocument::try_from(doc_bytes.as_slice()) {
        Ok(doc) => {
            let authors = doc
                .authors()
                .into_iter()
                .map(|kid| kid.to_string())
                .collect();

            let doc_meta_json = match serde_json::to_value(doc.doc_meta()) {
                Ok(json) => json,
                Err(e) => {
                    return AllResponses::internal_error(&anyhow!(
                        "Cannot decode document metadata into JSON, err: {e}"
                    ))
                },
            };

            let doc_body = SignedDocBody::new(
                doc.doc_id().into(),
                doc.doc_ver().into(),
                doc.doc_type().into(),
                authors,
                Some(doc_meta_json),
            );

            let payload = if doc.doc_content().is_json() {
                match serde_json::from_slice(doc.doc_content().decoded_bytes()) {
                    Ok(payload) => Some(payload),
                    Err(e) => {
                        return AllResponses::internal_error(&anyhow!(
                            "Invalid Document Content, not Json encoded: {e}"
                        ))
                    },
                }
            } else {
                None
            };

            match FullSignedDoc::new(doc_body, payload, doc_bytes)
                .store()
                .await
            {
                Ok(true) => Responses::Created.into(),
                Ok(false) => Responses::NoContent.into(),
                Err(err) => AllResponses::handle_error(&err),
            }
        },
        Err(e) => {
            let json_report = match serde_json::to_value(e.report()) {
                Ok(json_report) => json_report,
                Err(e) => {
                    return AllResponses::internal_error(&anyhow!(
                        "Invalid Signed Document decoding Problem Report, not Json encoded: {e}"
                    ))
                },
            };
            Responses::BadRequest(Json(PutDocumentBadRequest::new(
                "Invalid CBOR encoded document",
                Some(json_report),
            )))
            .into()
        },
    }
}
