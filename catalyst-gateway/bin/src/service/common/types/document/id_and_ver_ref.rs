use poem_openapi::{types::Example, NewType, Object, Union};

use super::{id::EqOrRangedIdDocumented, ver::EqOrRangedVerDocumented};
use crate::db::event::signed_docs::DocumentRef;

#[derive(Union, Debug, Clone, PartialEq)]
/// Either a Single Document ID, or a Range of Document IDs
pub(crate) enum IdAndVerRef {
    /// Document ID Reference ONLY
    IdRefOnly(IdRefOnlyDocumented),
    /// Version Reference with Optional Document ID Reference
    IdAndVerRef(VerRefWithOptionalIdDocumented),
}

impl Example for IdAndVerRef {
    fn example() -> Self {
        Self::IdAndVerRef(VerRefWithOptionalIdDocumented::example())
    }
}

impl IdAndVerRef {
    /// Returns an example of this type that only an `id`
    #[allow(dead_code)]
    fn example_id_ref() -> Self {
        Self::IdRefOnly(IdRefOnlyDocumented::example())
    }

    /// Returns an example of this type that includes both an `id` and `ver`
    #[allow(dead_code)]
    fn example_id_and_ver_ref() -> Self {
        Self::IdAndVerRef(VerRefWithOptionalIdDocumented::example_id_and_ver_ref())
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, Clone, PartialEq)]
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
pub(crate) struct IdAndVerRefDocumented(pub(crate) IdAndVerRef);

impl Example for IdAndVerRefDocumented {
    fn example() -> Self {
        Self(IdAndVerRef::example())
    }
}

impl TryFrom<IdAndVerRefDocumented> for DocumentRef {
    type Error = anyhow::Error;

    fn try_from(value: IdAndVerRefDocumented) -> Result<Self, Self::Error> {
        match value.0 {
            IdAndVerRef::IdRefOnly(val) => {
                Ok(DocumentRef {
                    id: Some(val.0.id.try_into()?),
                    ver: None,
                })
            },
            IdAndVerRef::IdAndVerRef(val) => {
                Ok(DocumentRef {
                    id: val.0.id.map(TryInto::try_into).transpose()?,
                    ver: Some(val.0.ver.try_into()?),
                })
            },
        }
    }
}

impl IdAndVerRefDocumented {
    /// Returns an example of this type that includes only an `id`
    #[allow(dead_code)]
    pub(crate) fn example_id_ref() -> Self {
        Self(IdAndVerRef::example_id_ref())
    }

    /// Returns an example of this type that includes both an `id` and `ver`
    #[allow(dead_code)]
    pub(crate) fn example_id_and_ver_ref() -> Self {
        Self(IdAndVerRef::example_id_and_ver_ref())
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, Clone, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document ID Reference
///
/// A Reference to the Document ID Only.
///
/// This will match any document that matches the defined Document ID only.
/// The Document Version is not considered, and will match any version.
pub(crate) struct IdRefOnlyDocumented(pub(crate) IdRefOnly);

impl Example for IdRefOnlyDocumented {
    fn example() -> Self {
        Self(IdRefOnly::example())
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, Clone, PartialEq)]
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

impl VerRefWithOptionalIdDocumented {
    /// Returns an example of this type that includes both an `id` and `ver`
    #[allow(dead_code)]
    fn example_id_and_ver_ref() -> Self {
        Self(VerRefWithOptionalId::example_id_and_ver_ref())
    }
}

#[derive(Object, Debug, Clone, PartialEq)]
/// A Reference to a Document ID/s and their version/s.
pub(crate) struct VerRefWithOptionalId {
    /// Document ID, or range of Document IDs
    #[oai(skip_serializing_if_is_none)]
    id: Option<EqOrRangedIdDocumented>,
    /// Document Version, or Range of Document Versions
    ver: EqOrRangedVerDocumented,
}

impl Example for VerRefWithOptionalId {
    fn example() -> Self {
        Self {
            id: None,
            ver: EqOrRangedVerDocumented::example(),
        }
    }
}

impl VerRefWithOptionalId {
    /// Returns an example of this type that includes both an `id` and `ver`
    #[allow(dead_code)]
    fn example_id_and_ver_ref() -> Self {
        Self {
            id: Some(EqOrRangedIdDocumented::example()),
            ver: EqOrRangedVerDocumented::example(),
        }
    }
}

#[derive(Object, Debug, Clone, PartialEq)]
#[oai(example = true)]
/// A Reference to a Document ID/s and their version/s.
pub(crate) struct IdRefOnly {
    /// Document ID, or range of Document IDs
    id: EqOrRangedIdDocumented,
}

impl Example for IdRefOnly {
    fn example() -> Self {
        Self {
            id: EqOrRangedIdDocumented::example(),
        }
    }
}
