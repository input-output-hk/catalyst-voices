//! Slot Number on the blockchain.

use std::sync::LazyLock;

use anyhow::bail;
use num_bigint::BigInt;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// Title.
const TITLE: &str = "Cardano Blockchain Slot Number";
/// Description.
const DESCRIPTION: &str = "The Slot Number of a Cardano Block on the chain.";
/// Example.
pub(crate) const EXAMPLE: u64 = 1_234_567;
/// Minimum.
const MINIMUM: u64 = 0;
/// Maximum.
const MAXIMUM: u64 = u64::MAX / 2;

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
#[derive(Debug, Eq, PartialEq, Hash, Clone, PartialOrd, Ord)]

pub(crate) struct SlotNo(u64);

impl SlotNo {
    /// Is the Slot Number valid?
    fn is_valid(value: u64) -> bool {
        value >= MINIMUM && value <= MAXIMUM
    }
}

impl Default for SlotNo {
    /// Explicit default implementation of `SlotNo` which is `0`.
    fn default() -> Self {
        Self(0)
    }
}

impl Type for SlotNo {
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

impl ParseFromParameter for SlotNo {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let slot: u64 = value.parse()?;
        Ok(Self(slot))
    }
}

impl ParseFromJSON for SlotNo {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        if let Value::Number(value) = value {
            let value = value
                .as_u64()
                .ok_or(ParseError::from("invalid slot number"))?;
            if !Self::is_valid(value) {
                return Err("invalid AssetValue".into());
            }
            Ok(Self(value))
        } else {
            Err(ParseError::expected_type(value))
        }
    }
}

impl From<SlotNo> for BigInt {
    fn from(val: SlotNo) -> Self {
        BigInt::from(val.0)
    }
}

impl ToJSON for SlotNo {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl TryFrom<u64> for SlotNo {
    type Error = anyhow::Error;

    fn try_from(value: u64) -> Result<Self, Self::Error> {
        if !Self::is_valid(value) {
            bail!("Invalid Slot Number");
        }
        Ok(Self(value))
    }
}

impl TryFrom<i64> for SlotNo {
    type Error = anyhow::Error;

    fn try_from(value: i64) -> Result<Self, Self::Error> {
        let value: u64 = value.try_into()?;
        if !Self::is_valid(value) {
            bail!("Invalid Slot Number");
        }
        Ok(Self(value))
    }
}

impl Into<u64> for SlotNo {
    fn into(self) -> u64 {
        // assume that the value is always valid
        self.0
    }
}

impl Into<i64> for SlotNo {
    fn into(self) -> i64 {
        // assume that the value is always valid
        i64::try_from(self.0).unwrap_or_default()
    }
}

impl SlotNo {
    /// Generic conversion of `Option<T>` to `Option<SlotNo>`.
    pub(crate) fn into_option<T: Into<SlotNo>>(value: Option<T>) -> Option<SlotNo> {
        value.map(std::convert::Into::into)
    }
}

impl Example for SlotNo {
    fn example() -> Self {
        Self(EXAMPLE)
    }
}
