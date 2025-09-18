//! Signed Document ID
//!
//! `UUIDv7` Encoded Document ID.

mod document_id;

pub(crate) use document_id::{DocumentId, DocumentIds};
use poem_openapi::{types::Example, NewType, Object, Union};

use crate::db::event::common::eq_or_ranged_uuid::EqOrRangedUuid;

#[derive(Object, Debug, PartialEq)]
#[oai(example = true)]
/// A range of Document IDs.
pub(crate) struct IdRange {
    /// Minimum Document ID to find (inclusive)
    min: DocumentId,
    /// Maximum Document ID to find (inclusive)
    max: DocumentId,
}

impl Example for IdRange {
    fn example() -> Self {
        Self {
            min: DocumentId::example_min(),
            max: DocumentId::example_max(),
        }
    }
}

#[derive(Union, Debug, PartialEq)]
#[oai(one_of)]
/// Either a Single Document ID, or a list of Document IDs
pub(crate) enum IdSignleOrList {
    /// The single DocumentId
    Signle(DocumentId),
    /// List of DocumentIds
    List(DocumentIds),
}

#[derive(Object, Debug, PartialEq)]
#[oai(example = true)]
/// A single Document IDs.
pub(crate) struct IdEq {
    /// The exact Document ID to match against.
    eq: IdSignleOrList,
}

impl Example for IdEq {
    fn example() -> Self {
        Self {
            eq: IdSignleOrList::Signle(DocumentId::example()),
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
/// ID Equals
///
/// A specific single
/// [Document ID](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
pub(crate) struct IdEqDocumented(IdEq);
impl Example for IdEqDocumented {
    fn example() -> Self {
        Self(IdEq::example())
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
/// ID Range
///
/// A range of
/// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
pub(crate) struct IdRangeDocumented(IdRange);
impl Example for IdRangeDocumented {
    fn example() -> Self {
        Self(IdRange::example())
    }
}

#[derive(Union, Debug, PartialEq)]
#[oai(one_of)]
/// Either a Single Document ID, or a Range of Document IDs
pub(crate) enum EqOrRangedId {
    /// This exact Document ID
    Eq(IdEqDocumented),
    /// Document IDs in this range
    Range(IdRangeDocumented),
}

impl Example for EqOrRangedId {
    fn example() -> Self {
        Self::Eq(IdEqDocumented::example())
    }
}

#[derive(NewType, Debug, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document ID Selector
///
/// Either a absolute single Document ID or a range of Document IDs
pub(crate) struct EqOrRangedIdDocumented(pub(crate) EqOrRangedId);

impl Example for EqOrRangedIdDocumented {
    fn example() -> Self {
        Self(EqOrRangedId::example())
    }
}

impl TryFrom<EqOrRangedIdDocumented> for EqOrRangedUuid {
    type Error = anyhow::Error;

    fn try_from(value: EqOrRangedIdDocumented) -> Result<Self, Self::Error> {
        match value.0 {
            EqOrRangedId::Eq(id) => {
                match id.0.eq {
                    IdSignleOrList::Signle(id) => Ok(Self::Eq(vec![id.parse()?])),
                    IdSignleOrList::List(ids) => {
                        Ok(Self::Eq(
                            ids.iter()
                                .map(|id| -> Result<uuid::Uuid, _> { id.parse() })
                                .collect::<Result<_, _>>()?,
                        ))
                    },
                }
            },
            EqOrRangedId::Range(range) => {
                Ok(Self::Range {
                    min: range.0.min.parse()?,
                    max: range.0.max.parse()?,
                })
            },
        }
    }
}
