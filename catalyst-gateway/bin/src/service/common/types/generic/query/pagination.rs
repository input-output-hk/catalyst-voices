//! Consistent Pagination Types
//!
//! These types are paired and must be used together.
//!
//! Page - The Page we wish to request, defaults to 0.
//! Limit - The Limit we wish to request, defaults to 100.

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

//***** PAGE */
/// Page Title.
const PAGE_TITLE: &str = "Page";
/// Description.
macro_rules! page_description {
    () => {
        "The page number of items to start with.
The size of each page is determined by the `limit` parameter."
    };
}
pub(crate) use page_description;
/// Description
pub(crate) const PAGE_DESCRIPTION: &str = page_description!();
/// Example.
const PAGE_EXAMPLE: u64 = 5;
/// Default
const PAGE_DEFAULT: u64 = 0;
/// Page Minimum.
const PAGE_MINIMUM: u64 = 0;
/// Page Maximum.
const PAGE_MAXIMUM: u64 = u64::MAX;

/// Schema.
#[allow(clippy::cast_precision_loss)]
static PAGE_SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(PAGE_TITLE.to_owned()),
        description: Some(PAGE_DESCRIPTION),
        example: Some(PAGE_EXAMPLE.into()),
        default: Page(PAGE_DEFAULT).to_json(),
        maximum: Some(PAGE_MAXIMUM as f64),
        minimum: Some(PAGE_MINIMUM as f64),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Page to be returned in the response.
#[derive(Debug, Eq, PartialEq, Hash)]
pub(crate) struct Page(u64);

impl Default for Page {
    fn default() -> Self {
        Self(PAGE_DEFAULT)
    }
}

/// Is the `Page` valid?
fn is_valid_page(value: u64) -> bool {
    (PAGE_MINIMUM..=PAGE_MAXIMUM).contains(&value)
}

impl Type for Page {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "integer(u64)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("integer", "u64")));
        schema_ref.merge(PAGE_SCHEMA.clone())
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(self)
    }

    fn raw_element_iter<'a>(
        &'a self,
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }
}

impl ParseFromParameter for Page {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let page: u64 = value.parse()?;
        Ok(Page(page))
    }
}

impl ParseFromJSON for Page {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        if let Value::Number(value) = value {
            let value = value.as_u64().unwrap_or_default();
            if !is_valid_page(value) {
                return Err("invalid Page".into());
            }
            Ok(Self(value))
        } else {
            Err(ParseError::expected_type(value))
        }
    }
}

impl ToJSON for Page {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl From<u64> for Page {
    fn from(value: u64) -> Self {
        Self(value)
    }
}

impl Example for Page {
    fn example() -> Self {
        Self(PAGE_EXAMPLE)
    }
}

//***** LIMIT */
/// Title.
const LIMIT_TITLE: &str = "Limit";
/// Description.
pub(crate) const LIMIT_DESCRIPTION: &str = "The size `limit` of each `page` of results.
Determines the maximum amount of data that can be returned in a valid response.
The actual maximum `limit` may be restricted by the responses upper limits.
In this case, the lower limit will apply, it is not an error.

This `limit` of records of data will always be returned unless there is less data to return 
than allowed for by the `limit` and `page`.

*Exceeding the `page` or `limit` of available records will not return `404`, it will return an 
empty response.*";
/// Example.
const LIMIT_EXAMPLE: u64 = 10;
/// Default Limit (Should be used by paged responses to set the maximum size of the
/// response).
pub(crate) const LIMIT_DEFAULT: u64 = 100;
/// Minimum.
const LIMIT_MINIMUM: u64 = 1;
/// Maximum.
const LIMIT_MAXIMUM: u64 = u64::MAX;

/// Schema.
#[allow(clippy::cast_precision_loss)]
static LIMIT_SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(LIMIT_TITLE.to_owned()),
        description: Some(LIMIT_DESCRIPTION),
        example: Some(LIMIT_EXAMPLE.into()),
        default: Page(LIMIT_DEFAULT).to_json(),
        maximum: Some(LIMIT_MAXIMUM as f64),
        minimum: Some(LIMIT_MINIMUM as f64),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Limit of items to be returned in a page of data.
#[derive(Debug, Eq, PartialEq, Hash)]
pub(crate) struct Limit(u64);

impl Default for Limit {
    fn default() -> Self {
        Self(LIMIT_DEFAULT)
    }
}

/// Is the `Page` valid?
fn is_valid_limit(value: u64) -> bool {
    (LIMIT_MINIMUM..=LIMIT_MAXIMUM).contains(&value)
}

impl Type for Limit {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "integer(u64)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("integer", "u64")));
        schema_ref.merge(LIMIT_SCHEMA.clone())
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(self)
    }

    fn raw_element_iter<'a>(
        &'a self,
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }
}

impl ParseFromParameter for Limit {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let limit: u64 = value.parse()?;
        Ok(Limit(limit))
    }
}

impl ParseFromJSON for Limit {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        if let Value::Number(value) = value {
            let value = value.as_u64().unwrap_or_default();
            if !is_valid_limit(value) {
                return Err("invalid Limit".into());
            }
            Ok(Self(value))
        } else {
            Err(ParseError::expected_type(value))
        }
    }
}

impl ToJSON for Limit {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl From<u64> for Limit {
    fn from(value: u64) -> Self {
        Self(value)
    }
}

impl Example for Limit {
    fn example() -> Self {
        Self(LIMIT_EXAMPLE)
    }
}
