//! A module for placing common structs, functions, and variables across the `document`
//! endpoint module not specified to a specific endpoint.

use catalyst_signed_doc::CatalystSignedDocument;

use super::templates::get_doc_static_template;
use crate::{
    db::event::{error::NotFoundError, signed_docs::FullSignedDoc},
    service::common::auth::rbac::token::CatalystRBACTokenV1,
};

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
    db_doc.raw().try_into()
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

/// A struct which implements a
/// `catalyst_signed_doc::providers::CatalystSignedDocumentProvider` trait
pub(crate) struct VerifyingKeyProvider(
    Vec<(catalyst_signed_doc::IdUri, ed25519_dalek::VerifyingKey)>,
);

impl catalyst_signed_doc::providers::VerifyingKeyProvider for VerifyingKeyProvider {
    async fn try_get_key(
        &self, kid: &catalyst_signed_doc::IdUri,
    ) -> anyhow::Result<Option<ed25519_dalek::VerifyingKey>> {
        Ok(self.0.iter().find(|item| &(item.0) == kid).map(|v| v.1))
    }
}

impl From<CatalystRBACTokenV1> for VerifyingKeyProvider {
    fn from(value: CatalystRBACTokenV1) -> Self {
        Self(Vec::from([(
            value.catalyst_id().clone().as_uri(),
            value.catalyst_id().role0_pk(),
        )]))
    }
}
