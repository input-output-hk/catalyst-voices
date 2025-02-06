//! Nonce

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use super::slot_no;

/// Title.
const TITLE: &str = "Nonce";
/// Description.
const DESCRIPTION: &str = "The current slot at the time a transaction was posted.
Used to ensure out of order inclusion on-chain can be detected.

*Note: Because a Nonce should never be greater than the slot of the transaction it is found in, 
excessively large nonces are capped to the transactions slot number.*";
/// Example.
pub(crate) const EXAMPLE: u64 = slot_no::EXAMPLE;
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

/// Value of a Nonce.
#[derive(Debug, Eq, PartialEq, Hash, Clone)]
pub(crate) struct Nonce(u64);

/// Is the Nonce valid?
fn is_valid(value: u64) -> bool {
    (MINIMUM..=MAXIMUM).contains(&value)
}

impl Type for Nonce {
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

impl ParseFromParameter for Nonce {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let nonce: u64 = value.parse()?;
        Ok(Self(nonce))
    }
}

impl ParseFromJSON for Nonce {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        match value {
            Value::Number(num) => {
                let nonce = num
                    .as_u64()
                    .ok_or(ParseError::from("nonce must be a positive integer"))?;
                if !is_valid(nonce) {
                    return Err(ParseError::from("nonce out of valid range"));
                }
                Ok(Self(nonce))
            },
            _ => Err(ParseError::expected_type(value)),
        }
    }
}

impl ToJSON for Nonce {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl From<u64> for Nonce {
    fn from(value: u64) -> Self {
        Self(value)
    }
}

impl Example for Nonce {
    fn example() -> Self {
        Self(EXAMPLE)
    }
}
