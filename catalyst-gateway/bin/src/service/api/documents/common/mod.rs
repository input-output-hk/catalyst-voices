//! A module for placing common structs, functions, and variables across the `document`
//! endpoint module not specified to a specific endpoint.

use catalyst_signed_doc::{CatalystSignedDocument, providers::CatalystSignedDocumentSearchQuery};
use catalyst_types::{catalyst_id::CatalystId, uuid::UuidV7};
use tokio::runtime::Handle;

use crate::{
    db::event::{error::NotFoundError, signed_docs::FullSignedDoc},
    service::common::auth::rbac::token::CatalystRBACTokenV1,
    settings::Settings,
};

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
    fn try_get_doc(
        &self,
        doc_ref: &catalyst_signed_doc::DocumentRef,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        self.doc_provider.try_get_doc(doc_ref)
    }

    fn try_get_last_doc(
        &self,
        id: UuidV7,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        self.doc_provider.try_get_last_doc(id)
    }

    fn try_get_first_doc(
        &self,
        id: UuidV7,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        self.doc_provider.try_get_first_doc(id)
    }

    fn try_search_docs(
        &self,
        query: &CatalystSignedDocumentSearchQuery,
    ) -> anyhow::Result<Vec<CatalystSignedDocument>> {
        self.doc_provider.try_search_docs(query)
    }
}

impl catalyst_signed_doc::providers::TimeThresholdProvider for ValidationProvider {
    fn future_threshold(&self) -> Option<std::time::Duration> {
        self.doc_provider.future_threshold()
    }

    fn past_threshold(&self) -> Option<std::time::Duration> {
        self.doc_provider.past_threshold()
    }
}

impl catalyst_signed_doc::providers::CatalystIdProvider for ValidationProvider {
    fn try_get_registered_key(
        &self,
        kid: &CatalystId,
    ) -> anyhow::Result<Option<ed25519_dalek::VerifyingKey>> {
        self.verifying_key_provider.try_get_registered_key(kid)
    }
}

/// A struct which implements a
/// `catalyst_signed_doc::providers::CatalystSignedDocumentProvider` trait
pub(crate) struct DocProvider;

impl catalyst_signed_doc::providers::CatalystSignedDocumentProvider for DocProvider {
    fn try_get_doc(
        &self,
        doc_ref: &catalyst_signed_doc::DocumentRef,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        let id = doc_ref.id().uuid();
        let ver = doc_ref.ver().uuid();

        let handle = Handle::current();
        match handle.block_on(FullSignedDoc::retrieve(&id, Some(&ver))) {
            Ok(doc_cbor_bytes) => Ok(Some(doc_cbor_bytes.raw().try_into()?)),
            Err(err) if err.is::<NotFoundError>() => Ok(None),
            Err(err) => Err(err),
        }
    }

    fn try_get_last_doc(
        &self,
        id: UuidV7,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        let handle = Handle::current();
        match handle.block_on(FullSignedDoc::retrieve(&id.uuid(), None)) {
            Ok(doc) => Ok(Some(doc.raw().try_into()?)),
            Err(err) if err.is::<NotFoundError>() => Ok(None),
            Err(err) => Err(err),
        }
    }

    fn try_get_first_doc(
        &self,
        id: UuidV7,
    ) -> anyhow::Result<Option<CatalystSignedDocument>> {
        let handle = Handle::current();
        match handle.block_on(FullSignedDoc::retrieve(&id.uuid(), Some(&id.uuid()))) {
            Ok(doc) => Ok(Some(doc.raw().try_into()?)),
            Err(err) if err.is::<NotFoundError>() => Ok(None),
            Err(err) => Err(err),
        }
    }

    fn try_search_docs(
        &self,
        query: &CatalystSignedDocumentSearchQuery,
    ) -> anyhow::Result<Vec<CatalystSignedDocument>> {
        let handle = Handle::current();
        // let docs = handle.block_on(async {
        //     let docs = SignedDocBody::retrieve(&query.into(), &QueryLimits::ALL)
        //         .await
        //         .try_collect()?;
        //     docs
        // })?;
        // TODO: FIXME:
        todo!()
    }
}

impl catalyst_signed_doc::providers::TimeThresholdProvider for DocProvider {
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
pub(crate) struct VerifyingKeyProvider {
    /// A user's `CatalystId` from the corresponding `CatalystRBACTokenV1`
    kid: CatalystId,
    /// A corresponding `VerifyingKey` derived from the `CatalystRBACTokenV1`
    pk: ed25519_dalek::VerifyingKey,
}

impl catalyst_signed_doc::providers::CatalystIdProvider for VerifyingKeyProvider {
    fn try_get_registered_key(
        &self,
        kid: &CatalystId,
    ) -> anyhow::Result<Option<ed25519_dalek::VerifyingKey>> {
        if &self.kid == kid {
            Ok(Some(self.pk))
        } else {
            Ok(None)
        }
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
    pub(crate) async fn try_new(
        token: &mut CatalystRBACTokenV1,
        kids: &[CatalystId],
    ) -> anyhow::Result<Self> {
        use itertools::Itertools as _;

        let [kid] = kids else {
            anyhow::bail!(
                "Must have only one signature. Multi-signature document is currently unsupported. kids: [{}]",
                kids.iter().map(ToString::to_string).join(",")
            );
        };

        if kid != token.catalyst_id() {
            anyhow::bail!("RBAC Token CatID does not match with the document KIDs");
        }

        if !kid.is_signature_key() {
            anyhow::bail!("Invalid KID {kid}: KID must be a signing key not an encryption key");
        }

        let (kid_role_index, kid_rotation) = kid.role_and_rotation();
        let (latest_pk, rotation) = token
            .get_latest_signing_public_key_for_role(kid_role_index)
            .await?;

        if rotation != kid_rotation {
            anyhow::bail!(
                "Invalid KID {kid}: KID's rotation ({kid_rotation}) is not the latest rotation ({rotation})"
            );
        }

        Ok(Self {
            kid: kid.clone(),
            pk: latest_pk,
        })
    }
}
