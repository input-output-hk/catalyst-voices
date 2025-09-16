//! A module for placing common structs, functions, and variables across the `document`
//! endpoint module not specified to a specific endpoint.

use std::collections::HashMap;

use catalyst_signed_doc::CatalystSignedDocument;

use crate::{
    db::event::{error::NotFoundError, signed_docs::FullSignedDoc},
    service::common::auth::rbac::token::CatalystRBACTokenV1,
    settings::Settings,
};

/// Get document cbor bytes from the database
pub(crate) async fn get_document_cbor_bytes(
    document_id: &uuid::Uuid,
    version: Option<&uuid::Uuid>,
) -> anyhow::Result<Vec<u8>> {
    // If doesn't exist in the static templates, try to find it in the database
    let db_doc = FullSignedDoc::retrieve(document_id, version).await?;
    Ok(db_doc.raw().to_vec())
}

/// A wrapper struct to unify both implementations of `CatalystSignedDocumentProvider` and
/// `VerifyingKeyProvider`.
pub(crate) struct ValidationProvider {
    /// Document provider.
    doc_provider: DocProvider,
    /// Verifying key provider.
    verifying_key_provider: VerifyingKeyProvider,
}

impl ValidationProvider {
    /// Creates a unified provider from the existing `CatalystSignedDocumentProvider` and
    /// `VerifyingKeyProvider` individually.
    pub(crate) fn new(
        doc_provider: DocProvider,
        verifying_key_provider: VerifyingKeyProvider,
    ) -> Self {
        Self {
            doc_provider,
            verifying_key_provider,
        }
    }
}

impl catalyst_signed_doc::providers::CatalystSignedDocumentProvider for ValidationProvider {
    async fn try_get_doc(
        &self,
        doc_ref: &catalyst_signed_doc::DocumentRef,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        self.doc_provider.try_get_doc(doc_ref).await
    }

    async fn try_get_last_doc(
        &self,
        id: catalyst_signed_doc::UuidV7,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        self.doc_provider.try_get_last_doc(id).await
    }

    fn future_threshold(&self) -> Option<std::time::Duration> {
        self.doc_provider.future_threshold()
    }

    fn past_threshold(&self) -> Option<std::time::Duration> {
        self.doc_provider.past_threshold()
    }
}

impl catalyst_signed_doc::providers::VerifyingKeyProvider for ValidationProvider {
    async fn try_get_key(
        &self,
        kid: &catalyst_signed_doc::CatalystId,
    ) -> anyhow::Result<Option<ed25519_dalek::VerifyingKey>> {
        self.verifying_key_provider.try_get_key(kid).await
    }
}

/// A struct which implements a
/// `catalyst_signed_doc::providers::CatalystSignedDocumentProvider` trait
pub(crate) struct DocProvider;

impl catalyst_signed_doc::providers::CatalystSignedDocumentProvider for DocProvider {
    async fn try_get_doc(
        &self,
        doc_ref: &catalyst_signed_doc::DocumentRef,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        let id = doc_ref.id().uuid();
        let ver = doc_ref.ver().uuid();
        match get_document_cbor_bytes(&id, Some(&ver)).await {
            Ok(doc_cbor_bytes) => Ok(Some(doc_cbor_bytes.as_slice().try_into()?)),
            Err(err) if err.is::<NotFoundError>() => Ok(None),
            Err(err) => Err(err),
        }
    }

    async fn try_get_last_doc(
        &self,
        id: catalyst_signed_doc::UuidV7,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        match FullSignedDoc::retrieve(&id.uuid(), None).await {
            Ok(doc) => Ok(Some(doc.raw().to_vec().as_slice().try_into()?)),
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

impl catalyst_signed_doc_v1::providers::CatalystSignedDocumentProvider for DocProvider {
    async fn try_get_doc(
        &self,
        doc_ref: &catalyst_signed_doc_v1::DocumentRef,
    ) -> anyhow::Result<Option<catalyst_signed_doc_v1::CatalystSignedDocument>> {
        let id = doc_ref.id.uuid();
        let ver = doc_ref.ver.uuid();
        match get_document_cbor_bytes(&id, Some(&ver)).await {
            Ok(doc_cbor_bytes) => Ok(Some(doc_cbor_bytes.as_slice().try_into()?)),
            Err(err) if err.is::<NotFoundError>() => Ok(None),
            Err(err) => Err(err),
        }
    }

    fn future_threshold(&self) -> Option<std::time::Duration> {
        <Self as catalyst_signed_doc::providers::CatalystSignedDocumentProvider>::future_threshold(
            self,
        )
    }

    fn past_threshold(&self) -> Option<std::time::Duration> {
        <Self as catalyst_signed_doc::providers::CatalystSignedDocumentProvider>::past_threshold(
            self,
        )
    }
}

// TODO: make the struct to support multi sigs validation
/// A struct which implements a
/// `catalyst_signed_doc::providers::CatalystSignedDocumentProvider` trait
pub(crate) struct VerifyingKeyProvider(
    HashMap<catalyst_signed_doc::CatalystId, ed25519_dalek::VerifyingKey>,
);

impl catalyst_signed_doc::providers::VerifyingKeyProvider for VerifyingKeyProvider {
    async fn try_get_key(
        &self,
        kid: &catalyst_signed_doc::CatalystId,
    ) -> anyhow::Result<Option<ed25519_dalek::VerifyingKey>> {
        Ok(self.0.get(kid).copied())
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
    pub(crate) async fn try_from_kids(
        token: &mut CatalystRBACTokenV1,
        kids: &[catalyst_signed_doc::CatalystId],
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

        let Some(reg_chain) = token.reg_chain().await? else {
            anyhow::bail!("Failed to retrieve a registration from corresponding Catalyst ID");
        };

        let result = kids.iter().map(|kid| {
            if !kid.is_signature_key() {
                anyhow::bail!("Invalid KID {kid}: KID must be a signing key not an encryption key");
            }

            let (kid_role_index, kid_rotation) = kid.role_and_rotation();
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
