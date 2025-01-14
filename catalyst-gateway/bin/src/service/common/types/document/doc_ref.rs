//! Signed Document Reference
//!
//! A Reference is used by the `ref` metadata, and any other reference to another document.

use poem_openapi::{types::Example, NewType, Object, Union};

use super::{
    id::{DocumentId, EqOrRangedId},
    ver::{DocumentVer, EqOrRangedVer},
};

#[derive(Object, Debug, PartialEq)]
/// A Reference to a Document ID/s and their version/s.
pub(crate) struct IdRefOnly {
    /// Document ID, or range of Document IDs
    id: EqOrRangedId,
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the openapi docs on an object.
#[derive(NewType, Debug, PartialEq)]
#[oai(from_multipart = false, from_parameter = false, to_header = false)]
/// Document ID Reference
///
/// A Reference to the Document ID Only.
///
/// This will match any document that matches the defined Document ID only.
/// The Document Version is not considered, and will match any version.
pub(crate) struct IdRefOnlyDocumented(pub(crate) IdRefOnly);

#[derive(Object, Debug, PartialEq)]
/// A Reference to a Document ID/s and their version/s.
pub(crate) struct VerRefWithOptionalId {
    /// Document ID, or range of Document IDs
    #[oai(skip_serializing_if_is_none)]
    id: Option<EqOrRangedId>,
    /// Document Version, or Range of Document Versions
    ver: EqOrRangedVer,
}

impl Example for VerRefWithOptionalId {
    fn example() -> Self {
        Self {
            id: None,
            ver: EqOrRangedVer::example(),
        }
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the openapi docs on an object.
#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document Version Reference
///
/// A Reference to the Document Version, and optionally also the Document ID.
///
/// This will match any document that matches the defined Document Version and if
/// specified the Document ID.
/// If the Document ID is not specified, then all documents that match the version will be
/// returned in the index.
pub(crate) struct VerRefWithOptionalIdDocumented(pub(crate) VerRefWithOptionalId);

impl Example for VerRefWithOptionalIdDocumented {
    fn example() -> Self {
        Self(VerRefWithOptionalId::example())
    }
}

#[derive(Union, Debug, PartialEq)]
#[oai(one_of)]
/// Either a Single Document ID, or a Range of Document IDs
pub(crate) enum IdAndVerRefInner {
    /// Document ID Reference ONLY
    IdRefOnly(IdRefOnlyDocumented),
    /// Version Reference with Optional Document ID Reference
    IdAndVerRef(VerRefWithOptionalIdDocumented),
}

impl Example for IdAndVerRefInner {
    fn example() -> Self {
        Self::IdAndVerRef(VerRefWithOptionalIdDocumented::example())
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the openapi docs on an object.
#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document Reference
///
/// A Signed Documents
/// [Reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#ref-document-reference)
/// to another Documents ID and/or Version.
///
/// *Note: at least one of `id` or `ver` must be defined.*
pub(crate) struct IdAndVerRef(pub(crate) IdAndVerRefInner);

impl Example for IdAndVerRef {
    fn example() -> Self {
        Self(IdAndVerRefInner::example())
    }
}

#[derive(Object, Debug, PartialEq)]
#[oai(example = true)]
/// A Reference to another Signed Document
pub(crate) struct DocumentReference {
    /// Document ID Reference
    #[oai(rename = "id")]
    doc_id: DocumentId,
    /// Document Version
    #[oai(skip_serializing_if_is_none)]
    ver: Option<DocumentVer>,
}

impl Example for DocumentReference {
    fn example() -> Self {
        Self {
            doc_id: DocumentId::example(),
            ver: Some(DocumentVer::example()),
        }
    }
}
