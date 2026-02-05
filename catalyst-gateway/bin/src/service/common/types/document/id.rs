//! Signed Document ID
//!
//! `UUIDv7` Encoded Document ID.

use std::sync::LazyLock;

use anyhow::bail;
use catalyst_types::uuid::UuidV7;
use poem_openapi::{
    NewType, Object, Union,
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use self::generic::uuidv7;
use crate::{
    db::event::common::uuid_selector::UuidSelector,
    service::common::types::{
        array_types::impl_array_types, generic, string_types::impl_string_types,
    },
};

/// Title.
const TITLE: &str = "Signed Document ID";
/// Description.
const DESCRIPTION: &str = "Unique [Document ID](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).

UUIDv7 Formatted 128bit value.";
/// Example.
const EXAMPLE: &str = "01944e87-e68c-7f22-9df1-816863cfa5ff";
/// Example minimum - Timestamp retained, random value set to all `0`
const EXAMPLE_MIN: &str = "01944e87-e68c-7000-8000-000000000000";
/// Example maximum - Timestamp retained, random value set to all `f`
const EXAMPLE_MAX: &str = "01944e87-e68c-7fff-bfff-ffffffffffff";
/// External Documentation URI
const URI: &str =
    "https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id";
/// Description of the URI
const URI_DESCRIPTION: &str = "Specification";
/// Length of the hex encoded string
pub(crate) const ENCODED_LENGTH: usize = uuidv7::ENCODED_LENGTH;
/// Validation Regex Pattern
pub(crate) const PATTERN: &str = uuidv7::PATTERN;
/// Format
pub(crate) const FORMAT: &str = uuidv7::FORMAT;

/// Schema
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        max_length: Some(ENCODED_LENGTH),
        min_length: Some(ENCODED_LENGTH),
        pattern: Some(PATTERN.to_string()),
        external_docs: Some(MetaExternalDocument {
            url: URI.to_owned(),
            description: Some(URI_DESCRIPTION.to_owned()),
        }),

        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(uuid: &str) -> bool {
    uuidv7::UUIDv7::try_from(uuid).is_ok()
}

impl_string_types!(DocumentId, "string", FORMAT, Some(SCHEMA.clone()), is_valid);

impl DocumentId {
    /// Creates a new `DocumentId` instance without validation.
    /// **NOTE** could produce an invalid instance, be sure that passing `String` is a
    /// valid `DocumentId`
    pub(crate) fn new_unchecked(uuid: String) -> Self {
        Self(uuid)
    }
}

impl Example for DocumentId {
    /// An example.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl DocumentId {
    /// An example of a minimum Document ID when specifying ranges
    fn example_min() -> Self {
        Self(EXAMPLE_MIN.to_owned())
    }

    /// An example of a maximum Document ID when specifying ranges
    fn example_max() -> Self {
        Self(EXAMPLE_MAX.to_owned())
    }
}

impl TryFrom<&str> for DocumentId {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for DocumentId {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        if !is_valid(&value) {
            bail!("Invalid DocumentID '{value}', must be a valid UUIDv7")
        }
        Ok(Self(value))
    }
}

impl From<uuidv7::UUIDv7> for DocumentId {
    fn from(value: uuidv7::UUIDv7) -> Self {
        Self(value.to_string())
    }
}

impl From<UuidV7> for DocumentId {
    fn from(value: UuidV7) -> Self {
        Self(value.to_string())
    }
}

impl_array_types!(
    DocumentIdList,
    DocumentId,
    Some(MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(DocumentId::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for DocumentIdList {
    fn example() -> Self {
        Self(vec![DocumentId::example()])
    }
}

impl PartialEq for DocumentIdList {
    fn eq(
        &self,
        other: &Self,
    ) -> bool {
        self.0.eq(&other.0)
    }
}

#[derive(Object, Debug, Clone, PartialEq)]
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

#[derive(Object, Debug, Clone, PartialEq)]
#[oai(example = true)]
/// A single Document IDs.
pub(crate) struct IdEq {
    /// The exact Document ID to match against.
    eq: DocumentId,
}

impl Example for IdEq {
    fn example() -> Self {
        Self {
            eq: DocumentId::example(),
        }
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
#[derive(NewType, Debug, Clone, PartialEq)]
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

/// Document IDs from the list.
#[derive(Object, Debug, Clone, PartialEq)]
#[oai(example = true)]
pub(crate) struct IdIn {
    /// Matching any document IDs from the list.
    r#in: DocumentIdList,
}

impl Example for IdIn {
    fn example() -> Self {
        Self {
            r#in: DocumentIdList::example(),
        }
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
/// Document IDs from the list.
///
/// A list of
/// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
pub(crate) struct IdInDocumented(IdIn);
impl Example for IdInDocumented {
    fn example() -> Self {
        Self(IdIn::example())
    }
}

#[derive(Union, Debug, Clone, PartialEq)]
#[oai(one_of)]
/// Either a Single Document ID, or a Range of Document IDs
pub(crate) enum IdSelector {
    /// This exact Document ID
    Eq(IdEqDocumented),
    /// Document IDs in this range
    Range(IdRangeDocumented),
    /// Document IDs in the list
    In(IdInDocumented),
}

impl Example for IdSelector {
    fn example() -> Self {
        Self::Eq(IdEqDocumented::example())
    }
}

impl TryFrom<IdSelector> for UuidSelector {
    type Error = anyhow::Error;

    fn try_from(value: IdSelector) -> Result<Self, Self::Error> {
        match value {
            IdSelector::Eq(id) => Ok(Self::Eq(id.0.eq.parse()?)),
            IdSelector::Range(range) => {
                Ok(Self::Range {
                    min: range.0.min.parse()?,
                    max: range.0.max.parse()?,
                })
            },
            IdSelector::In(ids) => {
                Ok(Self::In(
                    Vec::from(ids.0.r#in)
                        .into_iter()
                        .map(|id| id.0.parse::<uuid::Uuid>())
                        .collect::<Result<Vec<_>, _>>()?
                        .into(),
                ))
            },
        }
    }
}

#[derive(NewType, Debug, Clone, PartialEq)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document ID Selector
///
/// Either a absolute single Document ID or a range of Document IDs
pub(crate) struct IdSelectorDocumented(pub(crate) IdSelector);

impl Example for IdSelectorDocumented {
    fn example() -> Self {
        Self(IdSelector::example())
    }
}

impl TryFrom<IdSelectorDocumented> for Option<UuidSelector> {
    type Error = anyhow::Error;

    fn try_from(value: IdSelectorDocumented) -> Result<Self, Self::Error> {
        match value.0 {
            IdSelector::Eq(id) => Ok(Some(UuidSelector::Eq(id.0.eq.parse()?))),
            IdSelector::Range(range) => {
                Ok(Some(UuidSelector::Range {
                    min: range.0.min.parse()?,
                    max: range.0.max.parse()?,
                }))
            },
            IdSelector::In(ids) if !ids.0.r#in.is_empty() => {
                Ok(Some(UuidSelector::In(
                    Vec::from(ids.0.r#in)
                        .into_iter()
                        .map(|id| id.0.parse::<uuid::Uuid>())
                        .collect::<Result<Vec<_>, _>>()?
                        .into(),
                )))
            },
            IdSelector::In(_) => Ok(None),
        }
    }
}
