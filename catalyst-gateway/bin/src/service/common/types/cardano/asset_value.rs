//! Value of a Cardano Native Asset.

use std::sync::LazyLock;

use anyhow::bail;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// Title.
const TITLE: &str = "Cardano native Asset Value";
/// Description.
const DESCRIPTION: &str = "This is a non-zero signed integer.";
/// Example.
const EXAMPLE: i128 = 1_234_567;
/// Minimum.
/// From: <https://github.com/IntersectMBO/cardano-ledger/blob/78b32d585fd4a0340fb2b184959fb0d46f32c8d2/eras/conway/impl/cddl-files/conway.cddl#L568>
/// This is NOT `i128::MIN`.
const MINIMUM: i128 = -9_223_372_036_854_775_808;
/// Maximum.
/// From: <https://github.com/IntersectMBO/cardano-ledger/blob/78b32d585fd4a0340fb2b184959fb0d46f32c8d2/eras/conway/impl/cddl-files/conway.cddl#L569>
/// This is NOT `i128::MAX`.
const MAXIMUM: i128 = 9_223_372_036_854_775_808;

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

/// Value of a Cardano Native Asset (may not be zero)
#[derive(Debug, Clone, Eq, PartialEq, Hash)]
pub(crate) struct AssetValue(i128);

/// Is the `AssetValue` valid?
fn is_valid(value: i128) -> bool {
    value != 0 && (MINIMUM..=MAXIMUM).contains(&value)
}

impl Type for AssetValue {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "integer(i128)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("integer", "i128")));
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

impl ParseFromJSON for AssetValue {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        if let Value::Number(value) = value {
            let value = value.as_i128().unwrap_or_default();
            if !is_valid(value) {
                return Err("invalid AssetValue".into());
            }
            Ok(Self(value))
        } else {
            Err(ParseError::expected_type(value))
        }
    }
}

impl ToJSON for AssetValue {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl TryFrom<num_bigint::BigInt> for AssetValue {
    type Error = anyhow::Error;

    fn try_from(value: num_bigint::BigInt) -> Result<Self, Self::Error> {
        let value: i128 = value.try_into()?;
        if !is_valid(value) {
            bail!("Invalid Asset Value");
        }
        Ok(Self(value))
    }
}

impl Example for AssetValue {
    fn example() -> Self {
        Self(EXAMPLE)
    }
}
