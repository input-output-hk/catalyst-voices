//! Stake amount on the blockchain.

use std::sync::LazyLock;

use anyhow::bail;
use num_bigint::BigInt;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// Title.
const TITLE: &str = "Cardano Blockchain Stake Amount";
/// Description.
const DESCRIPTION: &str = "The stake amount of a Cardano Block on the chain.";
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

/// Stake Amount
#[derive(Debug, Eq, PartialEq, Hash, Clone, PartialOrd, Ord)]

pub(crate) struct StakeAmount(u64);

impl StakeAmount {
    /// Is the Stake Amount valid?
    fn is_valid(value: u64) -> bool {
        (MINIMUM..=MAXIMUM).contains(&value)
    }
}

impl std::ops::Deref for StakeAmount {
    type Target = u64;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl std::ops::DerefMut for StakeAmount {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

impl Default for StakeAmount {
    /// Explicit default implementation of `StakeAmount` which is `0`.
    fn default() -> Self {
        Self(0)
    }
}

impl Type for StakeAmount {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "StakeAmount".into()
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

impl ParseFromParameter for StakeAmount {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let slot: u64 = value.parse()?;
        Ok(Self(slot))
    }
}

impl ParseFromJSON for StakeAmount {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        u64::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(|v| v.try_into())?
            .map_err(ParseError::custom)
            .map(Self)
    }
}

impl From<StakeAmount> for BigInt {
    fn from(val: StakeAmount) -> Self {
        BigInt::from(val.0)
    }
}

impl ToJSON for StakeAmount {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl TryFrom<u64> for StakeAmount {
    type Error = anyhow::Error;

    fn try_from(value: u64) -> Result<Self, Self::Error> {
        if !Self::is_valid(value) {
            bail!("Invalid Stake Amount");
        }
        Ok(Self(value))
    }
}

impl TryFrom<i64> for StakeAmount {
    type Error = anyhow::Error;

    fn try_from(value: i64) -> Result<Self, Self::Error> {
        Ok(Self(value.try_into()?))
    }
}

impl Example for StakeAmount {
    fn example() -> Self {
        Self(EXAMPLE)
    }
}
