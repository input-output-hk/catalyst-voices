//! Implementation of the PUT `/document` endpoint

use std::str::FromStr;

use poem_openapi::{payload::Json, ApiResponse};
use unprocessable_content_request::PutDocumentUnprocessableContent;

use super::common::{DocProvider, VerifyingKeyProvider};
use crate::{
    db::event::{
        error,
        signed_docs::{FullSignedDoc, SignedDocBody, StoreError},
    },
    service::common::{auth::rbac::token::CatalystRBACTokenV1, responses::WithErrorResponses},
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
pub(crate) async fn endpoint(doc_bytes: Vec<u8>, token: CatalystRBACTokenV1) -> AllResponses {
    let Ok(doc): Result<catalyst_signed_doc::CatalystSignedDocument, _> =
        doc_bytes.as_slice().try_into()
    else {
        return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
            "Invalid CBOR bytes, cannot decode Catalyst Signed Document",
            None,
        )))
        .into();
    };

    // validate rbac token and document KIDs (ignoring the role/rotation)
    if doc
        .kids()
        .iter()
        .any(|kid| kid.as_short_id() != token.catalyst_id().as_short_id())
    {
        return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
            "RBAC Token CatID does not match with the providing document KIDs",
            None,
        )))
        .into();
    }

    // validate document integrity
    match catalyst_signed_doc::validator::validate(&doc, &DocProvider).await {
        Ok(true) => (),
        Ok(false) => {
            return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                "Failed validating document integrity",
                serde_json::to_value(doc.problem_report()).ok(),
            )))
            .into();
        },
        Err(e) => {
            // means that something happened inside the `DocProvider`, some db error.
            return AllResponses::handle_error(&e);
        },
    }

    // validate document signatures
    let verifying_key_provider =
        match VerifyingKeyProvider::try_from_kids(token.network(), &doc.kids()).await {
            Ok(value) => value,
            Err(e) => return AllResponses::handle_error(&e),
        };
    match catalyst_signed_doc::validator::validate_signatures(&doc, &verifying_key_provider).await {
        Ok(true) => (),
        Ok(false) => {
            return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                "Failed validating document signatures",
                serde_json::to_value(doc.problem_report()).ok(),
            )))
            .into();
        },
        Err(e) => {
            return AllResponses::handle_error(&e);
        },
    };

    if doc.problem_report().is_problematic() {
        return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
            "Invalid Catalyst Signed Document",
            serde_json::to_value(doc.problem_report()).ok(),
        )))
        .into();
    }

    // check if the incoming doc and the current latest doc are the same ver/id
    let (Ok(doc_id), Ok(doc_ver)) = (doc.doc_id(), doc.doc_ver()) else {
        return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
            "Invalid Catalyst Signed Document",
            serde_json::to_value(doc.problem_report()).ok(),
        )))
        .into();
    };
    let original_doc = match FullSignedDoc::retrieve(&doc_id.uuid(), None).await {
        Ok(doc) => Some(doc),
        Err(e) if e.is::<error::NotFoundError>() => None,
        Err(_) => {
            // FIXME: should be internal error
            return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                "Database error",
                None,
            )))
            .into();
        },
    };
    if let Some(original_doc) = original_doc {
        if original_doc.id() != &doc_id.uuid() && original_doc.ver() != &doc_ver.uuid() {
            let Ok(original_authors) = original_doc
                .body()
                .authors()
                .into_iter()
                .map(|author| catalyst_signed_doc::IdUri::from_str(&author))
                .collect::<Result<Vec<_>, _>>()
            else {
                // FIXME: should be internal error
                return Responses::UnprocessableContent(Json(
                    PutDocumentUnprocessableContent::new("Parsing db document error", None),
                ))
                .into();
            };

            let result = original_authors.iter().all(|original_author| {
                let found = doc.kids().into_iter().find(|incoming_author| {
                    incoming_author.as_short_id() == original_author.as_short_id()
                });

                found.is_some_and(|incoming_author| {
                    incoming_author.role_and_rotation().0 == original_author.role_and_rotation().0
                })
            });

            if !result {
                return Responses::UnprocessableContent(Json(
                    PutDocumentUnprocessableContent::new("Failed validating document: catalyst-id or role does not match the current version.", None),
                ))
                .into();
            }
        }
    }

    // update the document storing in the db
    match store_document_in_db(&doc, doc_bytes).await {
        Ok(true) => Responses::Created.into(),
        Ok(false) => Responses::NoContent.into(),
        Err(err) if err.is::<StoreError>() => {
            Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                "Document with the same `id` and `ver` already exists",
                serde_json::to_value(doc.problem_report()).ok(),
            )))
            .into()
        },
        Err(err) => AllResponses::handle_error(&err),
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
