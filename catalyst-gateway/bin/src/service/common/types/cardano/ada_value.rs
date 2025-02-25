//! ADA coins value on the blockchain.

use std::{fmt::Display, ops::Deref, sync::LazyLock};

use anyhow::bail;
use num_bigint::BigInt;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// Title.
const TITLE: &str = "Cardano Blockchain ADA coins value";
/// Description.
const DESCRIPTION: &str = "The ADA coins value of a Cardano Block on the chain.";
/// Example.
pub(crate) const EXAMPLE: u64 = 1_234_567;
/// Minimum.
const MINIMUM: u64 = 0;
/// Maximum.
const MAXIMUM: u64 = u64::MAX;

/// Schema.
#[allow(clippy::cast_precision_loss)]
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(EXAMPLE.into()),
        maximum: Some(MAXIMUM as f64),
        minimum: Some(MINIMUM as f64),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Slot number
#[derive(Debug, Eq, PartialEq, Hash, Clone, Copy, PartialOrd, Ord, Default)]

pub(crate) struct AdaValue(u64);

impl Deref for AdaValue {
    type Target = u64;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl Display for AdaValue {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

/// Is the Slot Number valid?
fn is_valid(_value: u64) -> bool {
    true
}

impl Type for AdaValue {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "integer(u64)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("integer", "u64")));
        schema_ref.merge(SCHEMA.clone())
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

impl ParseFromParameter for AdaValue {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let slot: u64 = value.parse()?;
        Ok(Self(slot))
    }
}

impl ParseFromJSON for AdaValue {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        if let Value::Number(value) = value {
            let value = value
                .as_u64()
                .ok_or(ParseError::from("invalid ada value"))?;
            if !is_valid(value) {
                return Err("invalid ada value".into());
            }
            Ok(Self(value))
        } else {
            Err(ParseError::expected_type(value))
        }
    }
}

impl From<AdaValue> for BigInt {
    fn from(val: AdaValue) -> Self {
        BigInt::from(val.0)
    }
}

impl ToJSON for AdaValue {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl TryFrom<i64> for AdaValue {
    type Error = anyhow::Error;

    fn try_from(value: i64) -> Result<Self, Self::Error> {
        let value: u64 = value.try_into()?;
        if !is_valid(value) {
            bail!("Invalid ADA Value");
        }
        Ok(Self(value))
    }
}

impl From<u64> for AdaValue {
    fn from(value: u64) -> Self {
        Self(value)
    }
}

impl From<AdaValue> for u64 {
    fn from(value: AdaValue) -> Self {
        value.0
    }
}

impl Example for AdaValue {
    fn example() -> Self {
        Self(EXAMPLE)
    }
}
