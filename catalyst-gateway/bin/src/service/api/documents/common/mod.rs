//! A module for placing common structs, functions, and variables across the `document`
//! endpoint module not specified to a specific endpoint.

use catalyst_signed_doc::CatalystSignedDocument;
use rbac_registration::cardano::cip509::RoleNumber;

use super::templates::get_doc_static_template;
use crate::{
    db::event::{error::NotFoundError, signed_docs::FullSignedDoc},
    service::common::auth::rbac::token::CatalystRBACTokenV1,
    settings::Settings,
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

    fn future_threshold(&self) -> Option<std::time::Duration> {
        let signed_doc_cfg = Settings::signed_doc_cfg();
        Some(signed_doc_cfg.future_threshold())
    }

    fn past_threshold(&self) -> Option<std::time::Duration> {
        let signed_doc_cfg = Settings::signed_doc_cfg();
        Some(signed_doc_cfg.past_threshold())
    }
}

// TODO: make the struct to support multi sigs validation
/// A struct which implements a
/// `catalyst_signed_doc::providers::CatalystSignedDocumentProvider` trait
pub(crate) struct VerifyingKeyProvider(
    Vec<(catalyst_signed_doc::IdUri, ed25519_dalek::VerifyingKey)>,
);

impl catalyst_signed_doc::providers::VerifyingKeyProvider for VerifyingKeyProvider {
    async fn try_get_key(
        &self, kid: &catalyst_signed_doc::IdUri,
    ) -> anyhow::Result<Option<ed25519_dalek::VerifyingKey>> {
        let res = self.0.iter().find(|(id, ..)| id == kid).map(|item| item.1);

        Ok(res)
    }
}

impl VerifyingKeyProvider {
    /// Attempts to construct an instance of `Self` by validating and resolving a list of
    /// Catalyst Document KIDs against a provided RBAC token.
    ///
    /// This method performs the following steps:
    /// 1. Verifies that only a single KID is provided with a document (as multi-signature
    ///    is currently unsupported).
    /// 2. Verifies that **all** provided KIDs match the Catalyst ID from the RBAC token.
    /// 3. Verifies that each provided KID is actually a signing key.
    /// 4. Extracts the role index and rotation from each KID.
    /// 5. Retrieves the latest signing public key and rotation state associated with the
    ///    role for each KID from the registration chain.
    /// 6. Verifies that each provided KID uses its latest rotation.
    /// 7. Collects and returns a vector of tuples containing the KID, and its latest
    ///    signing key.
    ///
    /// # Errors
    ///
    /// Returns an `anyhow::Error` if:
    /// - Any KID's short Catalyst ID does not match the one in the token.
    /// - Indexed registration queries or chain building fail.
    /// - The KID's role index and rotation parsing fails.
    /// - The KID is not a singing key.
    /// - The latest signing key for a required role cannot be found.
    /// - The KID is not using the latest rotation.
    pub(crate) fn try_from_kids(
        token: &CatalystRBACTokenV1, kids: &[catalyst_signed_doc::IdUri],
    ) -> anyhow::Result<Self> {
        if kids.len() > 1 {
            anyhow::bail!("Multi-signature document is currently unsupported");
        }

        if kids
            .iter()
            .any(|kid| kid.as_short_id() != token.catalyst_id().as_short_id())
        {
            anyhow::bail!("RBAC Token CatID does not match with the document KIDs");
        }

        let Some(reg_chain) = token.reg_chain() else {
            anyhow::bail!("Failed to retrieve a registration from corresponding Catalyst ID");
        };

        let result: Vec<_> = kids.iter().map(|kid| {
            if !kid.is_signature_key() {
                anyhow::bail!("Invalid KID {kid}: KID must be a signing key not an encryption key");
            }

            let (kid_role_index, kid_rotation) = kid.role_and_rotation();
            let kid_role_index = RoleNumber::from(kid_role_index.to_string().parse::<u8>()?);
            let kid_rotation = kid_rotation.to_string().parse::<usize>()?;

            let (latest_pk, rotation) = reg_chain
                .get_latest_signing_pk_for_role(&kid_role_index)
                .ok_or_else(|| {
                anyhow::anyhow!(
                    "Failed to get last signing key for the proposer role for {kid} Catalyst ID"
                )
            })?;

            if rotation != kid_rotation {
                anyhow::bail!("Invalid KID {kid}: KID's rotation ({kid_rotation}) is not the latest rotation ({rotation})");
            }

            Ok((kid.clone(), latest_pk))
        })
        .collect::<Result<_, _>>()?;

        Ok(Self(result))
    }
}
