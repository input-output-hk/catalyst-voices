//! Signed Document Version
//!
//! `UUIDv7` Encoded Document Version.

mod document_ver;

pub(crate) use document_ver::{DocumentVer, DocumentVers};
use poem_openapi::{types::Example, NewType, Object, Union};

use crate::db::event::common::eq_or_ranged_uuid::EqOrRangedUuid;

#[derive(Object, Debug, PartialEq)]
#[oai(example = true)]
/// Version Range
///
/// A Range of document versions from minimum to maximum inclusive.
pub(crate) struct VerRange {
    /// Minimum Document Version to find (inclusive)
    min: DocumentVer,
    /// Maximum Document Version to find (inclusive)
    max: DocumentVer,
}

impl Example for VerRange {
    fn example() -> Self {
        Self {
            min: DocumentVer::example_min(),
            max: DocumentVer::example_max(),
        }
    }
}

#[derive(Union, Debug, PartialEq)]
#[oai(one_of)]
/// Either a Single Document Ver, or a list of Document Versions
pub(crate) enum VerSignleOrList {
    /// The single DocumentVer
    Signle(DocumentVer),
    /// List of DocumentVers
    List(DocumentVers),
}

#[derive(Object, Debug, PartialEq)]
#[oai(example = true)]
/// A single Document IDs.
pub(crate) struct VerEq {
    /// The exact Document Ver to match against.
    eq: VerSignleOrList,
}

impl Example for VerEq {
    fn example() -> Self {
        Self {
            eq: VerSignleOrList::Signle(DocumentVer::example()),
        }
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Version Equals
///
/// A specific single
/// [Document Version](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver).
pub(crate) struct VerEqDocumented(VerEq);

impl Example for VerEqDocumented {
    fn example() -> Self {
        Self(VerEq::example())
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Version Range
///
/// A range of [Document Versions]().
pub(crate) struct VerRangeDocumented(VerRange);

impl Example for VerRangeDocumented {
    fn example() -> Self {
        Self(VerRange::example())
    }
}

#[derive(Union, Debug, PartialEq)]
#[oai(one_of)]
/// Document or Range of Documents
///
/// Either a Single Document Version, or a Range of Document Versions
pub(crate) enum EqOrRangedVer {
    /// This exact Document ID
    Eq(VerEqDocumented),
    /// Document Versions in this range
    Range(VerRangeDocumented),
}

impl Example for EqOrRangedVer {
    fn example() -> Self {
        Self::Range(VerRangeDocumented::example())
    }
}

#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document Version Selector
///
/// Either a absolute single Document Version or a range of Document Versions
pub(crate) struct EqOrRangedVerDocumented(pub(crate) EqOrRangedVer);

impl Example for EqOrRangedVerDocumented {
    fn example() -> Self {
        Self(EqOrRangedVer::example())
    }
}

impl TryFrom<EqOrRangedVerDocumented> for EqOrRangedUuid {
    type Error = anyhow::Error;

    fn try_from(value: EqOrRangedVerDocumented) -> Result<Self, Self::Error> {
        match value.0 {
            EqOrRangedVer::Eq(ver) => {
                match ver.0.eq {
                    VerSignleOrList::Signle(id) => Ok(Self::Eq(vec![id.parse()?])),
                    VerSignleOrList::List(ids) => {
                        Ok(Self::Eq(
                            ids.iter()
                                .map(|id| -> Result<uuid::Uuid, _> { id.parse() })
                                .collect::<Result<_, _>>()?,
                        ))
                    },
                }
            },
            EqOrRangedVer::Range(range) => {
                Ok(Self::Range {
                    min: range.0.min.parse()?,
                    max: range.0.max.parse()?,
                })
            },
        }
    }
}
