//! Signed Documents API endpoints

use anyhow::anyhow;
use poem::{error::ReadBodyError, Body};
use poem_openapi::{
    param::{Path, Query},
    payload::Json,
    OpenApi,
};
use post_document_index_query::query_filter::DocumentIndexQueryFilterBody;
use put_document::{bad_put_request::PutDocumentBadRequest, MAXIMUM_DOCUMENT_SIZE};

use crate::service::{
    common::{
        auth::none_or_rbac::NoneOrRBAC,
        tags::ApiTags,
        types::{
            generic::{
                query::pagination::{Limit, Page},
                uuidv7::UUIDv7,
            },
            payload::cbor::Cbor,
        },
    },
    utilities::middleware::schema_validation::schema_version_validation,
};

mod get_document;
mod post_document_index_query;
mod put_document;

/// Cardano Follower API Endpoints
pub(crate) struct DocumentApi;

#[OpenApi(tag = "ApiTags::Documents")]
impl DocumentApi {
    /// Get A Signed Document.
    ///
    /// This endpoint returns either a specific or latest version of a registered signed
    /// document.
    #[oai(
        path = "/draft/document/:document_id",
        method = "get",
        operation_id = "getDocument",
        transform = "schema_version_validation"
    )]
    async fn get_document(
        &self, /// UUIDv7 Document ID to retrieve
        document_id: Path<UUIDv7>,
        /// UUIDv7 Version of the Document to retrieve, if omitted, returns the latest
        /// version.
        version: Query<Option<UUIDv7>>,
        /// No Authorization required, but Token permitted.
        _auth: NoneOrRBAC,
    ) -> get_document::AllResponses {
        let Ok(doc_id) = document_id.0.try_into() else {
            let err = anyhow!("Invalid UUIDv7"); // Should not happen as UUIDv7 is validating.
            return get_document::AllResponses::internal_error(&err);
        };
        let Ok(ver_id) = version.0.map(std::convert::TryInto::try_into).transpose() else {
            let err = anyhow!("Invalid UUIDv7"); // Should not happen as UUIDv7 is validating.
            return get_document::AllResponses::internal_error(&err);
        };
        get_document::endpoint(doc_id, ver_id).await
    }

    /// Put A Signed Document.
    ///
    /// This endpoint returns OK if the document is valid, able to be put by the
    /// submitter, and if it already exists, is identical to the existing document.
    #[oai(
        path = "/draft/document",
        method = "put",
        operation_id = "putDocument",
        transform = "schema_version_validation"
    )]
    async fn put_document(
        &self, /// The document to PUT
        document: Cbor<Body>,
        /// Authorization required.
        _auth: NoneOrRBAC,
    ) -> put_document::AllResponses {
        match document.0.into_bytes_limit(MAXIMUM_DOCUMENT_SIZE).await {
            Ok(doc_bytes) => put_document::endpoint(doc_bytes.to_vec()).await,
            Err(ReadBodyError::PayloadTooLarge) => put_document::Responses::PayloadTooLarge.into(),
            Err(_) => {
                put_document::Responses::BadRequest(Json(PutDocumentBadRequest::new(
                    "Failed to read document from the request",
                )))
                .into()
            },
        }
    }

    /// Post A Signed Document Index Query.
    ///
    /// This endpoint produces a summary of signed documents that meet the criteria
    /// defined in the request body.
    ///
    /// It does not return the actual documents, just an index of the document identifiers
    /// which allows the documents to be retrieved by the `GET document` endpoint.
    #[oai(
        path = "/draft/document/index",
        method = "post",
        operation_id = "postDocument",
        transform = "schema_version_validation"
    )]
    async fn post_document(
        &self, /// The Query Filter Specification
        query: Json<DocumentIndexQueryFilterBody>,
        page: Query<Option<Page>>, limit: Query<Option<Limit>>,
        /// Authorization required.
        _auth: NoneOrRBAC,
    ) -> post_document_index_query::AllResponses {
        post_document_index_query::endpoint(query.0 .0, page.0, limit.0).await
    }
}
