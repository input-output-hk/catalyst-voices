//! Implementation of the PUT `/document` endpoint

use poem_openapi::{ApiResponse, payload::Json};
use unprocessable_content_request::PutDocumentUnprocessableContent;

use super::common::{DocProvider, VerifyingKeyProvider};
use crate::{
    db::{
        event::{error::NotFoundError, signed_docs::FullSignedDoc},
        index::session::CassandraSessionError,
    },
    service::{
        api::documents::common::ValidationProvider,
        common::{
            auth::rbac::token::CatalystRBACTokenV1, responses::WithErrorResponses,
            types::headers::retry_after::RetryAfterOption,
        },
    },
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
#[allow(clippy::too_many_lines)]
pub(crate) async fn endpoint(
    doc_bytes: Vec<u8>,
    mut token: CatalystRBACTokenV1,
) -> AllResponses {
    let Ok(doc): Result<catalyst_signed_doc::CatalystSignedDocument, _> =
        doc_bytes.as_slice().try_into()
    else {
        return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
            "Invalid CBOR bytes, cannot decode Catalyst Signed Document",
            None,
        )))
        .into();
    };

    let db_doc = match FullSignedDoc::try_from(&doc) {
        Ok(doc) => doc,
        Err(err) => return AllResponses::handle_error(&err),
    };

    // TODO: use the `ValidationProvider::try_get_doc` method and verify the returned
    // document cid values.
    // making sure that the document was already submitted before running validation,
    // otherwise validation would fail, because of the assumption that this document wasn't
    // published yet.
    match FullSignedDoc::retrieve(db_doc.id(), Some(db_doc.ver())).await {
        Ok(retrieved) if db_doc != retrieved => {
            return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                "Document with the same `id` and `ver` already exists",
                Some(doc.report()),
            )))
            .into();
        },
        Ok(_) => return Responses::NoContent.into(),
        Err(err) if err.is::<NotFoundError>() => (),
        Err(err) => return AllResponses::handle_error(&err),
    }

    // validation provider
    let validation_provider = match VerifyingKeyProvider::try_new(&mut token, &doc.authors()).await
    {
        Ok(value) => ValidationProvider::new(DocProvider, value),
        Err(err) if err.is::<CassandraSessionError>() => {
            return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
        },
        Err(err) => {
            return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                &err, None,
            )))
            .into();
        },
    };

    match catalyst_signed_doc::validator::validate(&doc, &validation_provider).await {
        Ok(true) => (),
        Ok(false) if doc.report().is_problematic() => {
            return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
                "Failed validating document integrity",
                Some(doc.report()),
            )))
            .into();
        },
        Ok(false) => {
            return AllResponses::handle_error(&anyhow::anyhow!(
                "Document must be problematic, empty problem report."
            ));
        },
        Err(err) => {
            // means that something happened inside the `DocProvider`, some db error.
            return AllResponses::handle_error(&err);
        },
    }

    if doc.report().is_problematic() {
        return Responses::UnprocessableContent(Json(PutDocumentUnprocessableContent::new(
            "Invalid Catalyst Signed Document",
            Some(doc.report()),
        )))
        .into();
    }

    match db_doc.store().await {
        Ok(()) => Responses::Created.into(),
        Err(err) => AllResponses::handle_error(&err),
    }
}
