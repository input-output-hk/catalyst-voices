//! Signed Documents API endpoints

use anyhow::anyhow;
use poem_openapi::{
    param::{Path, Query},
    OpenApi,
};

use crate::service::{
    common::{auth::none_or_rbac::NoneOrRBAC, tags::ApiTags, types::generic::uuidv7::UUIDv7},
    utilities::middleware::schema_validation::schema_version_validation,
};

mod get_document;

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
}
