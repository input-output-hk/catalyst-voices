//! Signed Document Version
//!
//! `UUIDv7` Encoded Document Version.

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
const TITLE: &str = "Signed Document Version";
/// Description.
const DESCRIPTION: &str = "Unique [Document Version](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver).  

UUIDv7 Formatted 128bit value.";
/// Example.
const EXAMPLE: &str = "01944e87-e68c-7f22-9df1-816863cfa5ff";
/// Example - Range min.
const EXAMPLE_MAX: &str = "01944e87-e68c-7f22-9df1-000000000000";
/// Example - Ranged max
const EXAMPLE_MIN: &str = "01944e87-e68c-7f22-9df1-ffffffffffff";
/// External Documentation URI
const URI: &str =
    "https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver";
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

impl_string_types!(
    DocumentVer,
    "string",
    FORMAT,
    Some(SCHEMA.clone()),
    is_valid
);

impl DocumentVer {
    /// Creates a new `DocumentVer` instance without validation.
    /// **NOTE** could produce an invalid instance, be sure that passing `String` is a
    /// valid `DocumentVer`
    pub(crate) fn new_unchecked(uuid: String) -> Self {
        Self(uuid)
    }
}

impl Example for DocumentVer {
    /// An example.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl DocumentVer {
    /// An example of a minimum Document ID when specifying ranges
    fn example_min() -> Self {
        Self(EXAMPLE_MIN.to_owned())
    }

    /// An example of a maximum Document ID when specifying ranges
    fn example_max() -> Self {
        Self(EXAMPLE_MAX.to_owned())
    }
}

impl TryFrom<&str> for DocumentVer {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for DocumentVer {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        if !is_valid(&value) {
            bail!("Invalid DocumentVer '{value}', must be a valid UUIDv7")
        }
        Ok(Self(value))
    }
}

impl From<uuidv7::UUIDv7> for DocumentVer {
    fn from(value: uuidv7::UUIDv7) -> Self {
        Self(value.to_string())
    }
}

impl From<UuidV7> for DocumentVer {
    fn from(value: UuidV7) -> Self {
        Self(value.to_string())
    }
}

impl_array_types!(
    DocumentVerList,
    DocumentVer,
    Some(MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(DocumentVer::schema_ref())),
        ..MetaSchema::ANY
    })
);

impl Example for DocumentVerList {
    fn example() -> Self {
        Self(vec![DocumentVer::example()])
    }
}

impl PartialEq for DocumentVerList {
    fn eq(
        &self,
        other: &Self,
    ) -> bool {
        self.0.eq(&other.0)
    }
}

#[derive(Object, Debug, Clone, PartialEq)]
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

#[derive(Object, Debug, Clone, PartialEq)]
#[oai(example = true)]
/// A single Document IDs.
pub(crate) struct VerEq {
    /// The exact Document ID to match against.
    eq: DocumentVer,
}

impl Example for VerEq {
    fn example() -> Self {
        Self {
            eq: DocumentVer::example(),
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
#[derive(NewType, Debug, Clone, PartialEq)]
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

/// Document versions from the list.
#[derive(Object, Debug, Clone, PartialEq)]
#[oai(example = true)]
pub(crate) struct VerIn {
    /// Matching any document versions from the list.
    r#in: DocumentVerList,
}

impl Example for VerIn {
    fn example() -> Self {
        Self {
            r#in: DocumentVerList::example(),
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
/// Document versions from the list.
///
/// A range of [Document Versions]().
pub(crate) struct VerInDocumented(VerIn);

impl Example for VerInDocumented {
    fn example() -> Self {
        Self(VerIn::example())
    }
}

#[derive(Union, Debug, Clone, PartialEq)]
#[oai(one_of)]
/// Document or Range of Documents
///
/// Either a Single Document Version, or a Range of Document Versions
pub(crate) enum VerSelector {
    /// This exact Document ID
    Eq(VerEqDocumented),
    /// Document Versions in this range
    Range(VerRangeDocumented),
    /// Document versions in the list.
    In(VerInDocumented),
}

impl Example for VerSelector {
    fn example() -> Self {
        Self::Range(VerRangeDocumented::example())
    }
}

impl TryFrom<VerSelector> for UuidSelector {
    type Error = anyhow::Error;

    fn try_from(value: VerSelector) -> Result<Self, Self::Error> {
        match value {
            VerSelector::Eq(id) => Ok(Self::Eq(id.0.eq.parse()?)),
            VerSelector::Range(range) => {
                Ok(Self::Range {
                    min: range.0.min.parse()?,
                    max: range.0.max.parse()?,
                })
            },
            VerSelector::In(vers) => {
                Ok(Self::In(
                    Vec::<_>::from(vers.0.r#in)
                        .into_iter()
                        .map(|v| v.0.parse::<uuid::Uuid>())
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
/// Document Version Selector
///
/// Either a absolute single Document Version or a range of Document Versions
pub(crate) struct VerSelectorDocumented(pub(crate) VerSelector);

impl Example for VerSelectorDocumented {
    fn example() -> Self {
        Self(VerSelector::example())
    }
}

impl TryFrom<VerSelectorDocumented> for Option<UuidSelector> {
    type Error = anyhow::Error;

    fn try_from(value: VerSelectorDocumented) -> Result<Self, Self::Error> {
        match value.0 {
            VerSelector::Eq(ver) => Ok(Some(UuidSelector::Eq(ver.0.eq.parse()?))),
            VerSelector::Range(range) => {
                Ok(Some(UuidSelector::Range {
                    min: range.0.min.parse()?,
                    max: range.0.max.parse()?,
                }))
            },
            VerSelector::In(vers) if !vers.0.r#in.is_empty() => {
                Ok(Some(UuidSelector::In(
                    Vec::<_>::from(vers.0.r#in)
                        .into_iter()
                        .map(|v| v.0.parse())
                        .collect::<Result<Vec<_>, _>>()?
                        .into(),
                )))
            },
            VerSelector::In(_) => Ok(None),
        }
    }
}
