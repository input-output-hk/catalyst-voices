//! A module for placing common structs, functions, and variables across the `document`
//! endpoint module not specified to a specific endpoint.

use catalyst_signed_doc::CatalystSignedDocument;
use catalyst_types::id_uri::key_rotation::KeyRotation;
use rbac_registration::cardano::cip509::RoleNumber;

use super::templates::get_doc_static_template;
use crate::{
    db::event::{error::NotFoundError, signed_docs::FullSignedDoc},
    service::common::auth::rbac::{scheme, token::CatalystRBACTokenV1},
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
pub(crate) struct VerifyingKeyProvider((ed25519_dalek::VerifyingKey, usize));

impl catalyst_signed_doc::providers::VerifyingKeyProvider for VerifyingKeyProvider {
    async fn try_get_key(
        &self, kid: &catalyst_signed_doc::IdUri,
    ) -> anyhow::Result<Option<ed25519_dalek::VerifyingKey>> {
        // check if the doc is using the latest kid
        if kid.role_and_rotation().1 == KeyRotation::from(self.0 .1 as u16) {
            return Err(anyhow::anyhow!(
                "Failed to validate the document: not using the latest key"
            ));
        }

        Ok(Some(self.0 .0))
    }
}

impl VerifyingKeyProvider {
    /// Gets the latest public key for the proposer role for the given `catid` from the token.
    pub(crate) async fn try_from_token(token: CatalystRBACTokenV1) -> anyhow::Result<Self> {
        let cat_id = token.catalyst_id();

        let reg_quuries = scheme::indexed_registrations(cat_id).await?;

        if reg_quuries.is_empty() {
            return Err(anyhow::anyhow!(
                "Unable to find registrations for {cat_id} Catalyst ID"
            ));
        }

        let reg_chain = scheme::build_reg_chain(token.network(), &reg_quuries)
            .await
            .map_err(|e| {
                anyhow::anyhow!(
                    "Failed to build a registration chain for {cat_id} Catalyst ID: {e:?}"
                )
            })?;

        let (latest_pk, rotation) = reg_chain
            .get_latest_signing_pk_for_role(&RoleNumber::from(2))
            .ok_or_else(|| {
                anyhow::anyhow!(
                    "Failed to get last signing key for the proposer role for {cat_id} Catalyst ID"
                )
            })?;

        Ok(Self((latest_pk, rotation)))
    }
}
