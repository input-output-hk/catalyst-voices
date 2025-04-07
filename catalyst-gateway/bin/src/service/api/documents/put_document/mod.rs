//! Implementation of the PUT `/document` endpoint

use anyhow::anyhow;
use poem_openapi::{payload::Json, ApiResponse};
use unprocessable_content_request::PutDocumentUnprocessableContent;

use super::get_document::DocProvider;
use crate::{
    db::event::signed_docs::{FullSignedDoc, SignedDocBody, StoreError},
    service::common::responses::WithErrorResponses,
};

pub(crate) mod unprocessable_content_request;

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
    /// ## Unprocessable Content
    ///
    /// Error Response. The document submitted is invalid.
    #[oai(status = 422)]
    UnprocessableContent(Json<PutDocumentUnprocessableContent>),
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
pub(crate) async fn endpoint(doc_bytes: Vec<u8>) -> AllResponses {
    match doc_bytes.as_slice().try_into() {
        Ok(doc) => {
            if let Err(e) = catalyst_signed_doc::validator::validate(&doc, &DocProvider).await {
                // means that something happened inside the `DocProvider`, some db error.
                return AllResponses::handle_error(&e);
            }

            let report = doc.problem_report();
            if report.is_problematic() {
                return return_error_report(&report);
            }

            match store_document_in_db(&doc, doc_bytes).await {
                Ok(true) => Responses::Created.into(),
                Ok(false) => Responses::NoContent.into(),
                Err(err) if err.is::<StoreError>() => {
                    Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                        "Document with the same `id` and `ver` already exists",
                        None,
                    )))
                    .into()
                },
                Err(err) => AllResponses::handle_error(&err),
            }
        },
        Err(_) => {
            Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                "Invalid CBOR bytes, cannot decode Catalyst Signed Document.",
                None,
            )))
            .into()
        },
    }
}

/// Store a provided and validated document inside the db.
/// Returns `true` if its a new document.
/// Returns `false` if the same document already exists.
async fn store_document_in_db(
    doc: &catalyst_signed_doc::CatalystSignedDocument, doc_bytes: Vec<u8>,
) -> anyhow::Result<bool> {
    let authors = doc
        .authors()
        .into_iter()
        .map(|kid| kid.to_string())
        .collect();

    let doc_meta_json = match serde_json::to_value(doc.doc_meta()) {
        Ok(json) => json,
        Err(e) => {
            anyhow::bail!("Cannot decode document metadata into JSON, err: {e}");
        },
    };

    let payload = if matches!(
        doc.doc_content_type()?,
        catalyst_signed_doc::ContentType::Json
    ) {
        match serde_json::from_slice(doc.doc_content().decoded_bytes()?) {
            Ok(payload) => Some(payload),
            Err(e) => {
                anyhow::bail!("Invalid Document Content, not Json encoded: {e}");
            },
        }
    } else {
        None
    };

    let doc_body = SignedDocBody::new(
        doc.doc_id()?.into(),
        doc.doc_ver()?.into(),
        doc.doc_type()?.into(),
        authors,
        Some(doc_meta_json),
    );

    FullSignedDoc::new(doc_body, payload, doc_bytes)
        .store()
        .await
}

/// Return a response with the full error report from `CatalystSignedDocError`
fn return_error_report(report: &catalyst_signed_doc::ProblemReport) -> AllResponses {
    let json_report = match serde_json::to_value(report) {
        Ok(json_report) => json_report,
        Err(e) => {
            return AllResponses::internal_error(&anyhow!(
                "Invalid Signed Document Problem Report, not Json encoded: {e}"
            ))
        },
    };
    Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
        "Invalid Catalyst Signed Document",
        Some(json_report),
    )))
    .into()
}
