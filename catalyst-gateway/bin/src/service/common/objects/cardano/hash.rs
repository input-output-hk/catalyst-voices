//! Defines API schema of Cardano hash type.

use core::fmt;
use std::str::FromStr;

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};

use crate::service::utilities::as_hex_string;

/// Cardano Blake2b256 hash encoded in hex.
#[derive(Debug, Clone)]
pub(crate) struct Hash256([u8; Hash256::BYTE_LEN]);

impl Hash256 {
    /// The byte size for this hash.
    const BYTE_LEN: usize = 32;
    /// The hex-encoded hash length of this hash type.
    const HASH_LEN: usize = Self::BYTE_LEN * 2;

    /// Creates a `Hash256` schema definition.
    fn schema() -> MetaSchema {
        let mut schema = MetaSchema::new("string");
        schema.title = Some(format!("Cardano {}-bit Hash", Self::BYTE_LEN * 8));
        schema.description = Some("Cardano Blake2b256 hash encoded in hex.");
        schema.example = Some(Self::example().to_string().into());
        schema.min_length = Some(Self::HASH_LEN + 2);
        schema.max_length = Some(Self::HASH_LEN + 2);
        schema.pattern = Some("^0x[0-9a-f]{64}$".to_string());
        schema
    }
}

impl Type for Hash256 {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "CardanoHash256".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(Self::schema()))
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

impl Example for Hash256 {
    fn example() -> Self {
        // 0xff561c1ce6becf136a5d3063f50d78b8db50b8a1d4c03b18d41a8e98a6a18aed
        Self([
            255, 86, 28, 28, 230, 190, 207, 19, 106, 93, 48, 99, 245, 13, 120, 184, 219, 80, 184,
            161, 212, 192, 59, 24, 212, 26, 142, 152, 166, 161, 138, 237,
        ])
    }
}

impl TryFrom<Vec<u8>> for Hash256 {
    type Error = anyhow::Error;

    fn try_from(value: Vec<u8>) -> Result<Self, Self::Error> {
        value
            .try_into()
            .map_err(|_| anyhow::anyhow!("Invalid {}-bit Cardano hash length.", Self::BYTE_LEN * 8))
            .map(Self)
    }
}

impl FromStr for Hash256 {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let hash = s.strip_prefix("0x").ok_or(anyhow::anyhow!(
            "Invalid Cardano hash. Hex string must start with `0x`.",
        ))?;

        hex::decode(hash)
            .map_err(|_| anyhow::anyhow!("Invalid Cardano hash. Must be hex string."))?
            .try_into()
    }
}

impl AsRef<[u8]> for Hash256 {
    fn as_ref(&self) -> &[u8] {
        &self.0
    }
}

impl ParseFromParameter for Hash256 {
    fn parse_from_parameter(param: &str) -> ParseResult<Self> {
        Self::from_str(param).map_err(ParseError::custom)
    }
}

impl ParseFromJSON for Hash256 {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        String::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(|v| Self::from_str(&v))?
            .map_err(ParseError::custom)
    }
}

impl ToJSON for Hash256 {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(self.to_string().into())
    }
}

impl fmt::Display for Hash256 {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        as_hex_string(&self.0).fmt(f)
    }
}

/// Cardano Blake2b128 hash encoded in hex.
#[derive(Debug, Clone)]
pub(crate) struct Hash128([u8; Hash128::BYTE_LEN]);

impl Hash128 {
    /// The byte size for this hash.
    const BYTE_LEN: usize = 16;
    /// The hex-encoded hash length of this hash type.
    const HASH_LEN: usize = Self::BYTE_LEN * 2;

    /// Creates a `Hash128` schema definition.
    fn schema() -> MetaSchema {
        let mut schema = MetaSchema::new("string");
        schema.title = Some(format!("Cardano {}-bit Hash", Self::BYTE_LEN * 8));
        schema.description = Some("Cardano Blake2b128 hash encoded in hex.");
        schema.example = Some(Self::example().to_string().into());
        schema.min_length = Some(Self::HASH_LEN + 2);
        schema.max_length = Some(Self::HASH_LEN + 2);
        schema.pattern = Some("^0x[0-9a-f]{32}$".to_string());
        schema
    }
}

impl Type for Hash128 {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "CardanoHash128".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(Self::schema()))
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

impl Example for Hash128 {
    fn example() -> Self {
        // 0xdb50b8a1d4c03b18d41a8e98a6a18aed
        Self([
            219, 80, 184, 161, 212, 192, 59, 24, 212, 26, 142, 152, 166, 161, 138, 237,
        ])
    }
}

impl TryFrom<Vec<u8>> for Hash128 {
    type Error = anyhow::Error;

    fn try_from(value: Vec<u8>) -> Result<Self, Self::Error> {
        value
            .try_into()
            .map_err(|_| anyhow::anyhow!("Invalid {}-bit Cardano hash length.", Self::BYTE_LEN * 8))
            .map(Self)
    }
}

impl FromStr for Hash128 {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let hash = s.strip_prefix("0x").ok_or(anyhow::anyhow!(
            "Invalid Cardano hash. Hex string must start with `0x`.",
        ))?;

        hex::decode(hash)
            .map_err(|_| anyhow::anyhow!("Invalid Cardano hash. Must be hex string."))?
            .try_into()
    }
}

impl AsRef<[u8]> for Hash128 {
    fn as_ref(&self) -> &[u8] {
        &self.0
    }
}

impl ParseFromParameter for Hash128 {
    fn parse_from_parameter(param: &str) -> ParseResult<Self> {
        Self::from_str(param).map_err(ParseError::custom)
    }
}

impl ParseFromJSON for Hash128 {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        String::parse_from_json(value)
            .map_err(ParseError::propagate)
            .map(|v| Self::from_str(&v))?
            .map_err(ParseError::custom)
    }
}

impl ToJSON for Hash128 {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(self.to_string().into())
    }
}

impl fmt::Display for Hash128 {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        as_hex_string(&self.0).fmt(f)
    }
}
