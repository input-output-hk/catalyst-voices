//! Defines API schema of Cardano hash type.

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef, Registry},
    types::{ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};

use crate::service::utilities::as_hex_string;

/// Cardano Blake2b256 hash encoded in hex.
#[derive(Debug)]
pub(crate) struct Hash(Vec<u8>);

impl From<Vec<u8>> for Hash {
    fn from(hash: Vec<u8>) -> Self {
        Self(hash)
    }
}

impl Hash {
    /// Creates a `CardanoStakeAddress` schema definition.
    fn schema() -> MetaSchema {
        let mut schema = MetaSchema::new("string");
        schema.title = Some(Self::name().to_string());
        schema.description = Some("Cardano Blake2b256 hash encoded in hex.");
        schema.example = Some(serde_json::Value::String(
            // cspell: disable
            "0x0000000000000000000000000000000000000000000000000000000000000000".to_string(),
            // cspell: enable
        ));
        schema.max_length = Some(66);
        schema.pattern = Some("0x[0-9a-f]{64}".to_string());
        schema
    }
}

impl Type for Hash {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "CardanoHash".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Reference(Self::name().to_string())
    }

    fn register(registry: &mut Registry) {
        registry.create_schema::<Self, _>(Self::name().to_string(), |_| Self::schema());
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

impl ParseFromParameter for Hash {
    fn parse_from_parameter(param: &str) -> ParseResult<Self> {
        hex::decode(param.strip_prefix("0x").ok_or(ParseError::custom(
            "Invalid Cardano hash. hex string should start with `0x`.",
        ))?)
        .map_err(|_| ParseError::custom("Invalid Cardano hash. Should be hex string."))
        .map(Self)
    }
}

impl ParseFromJSON for Hash {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        let value = value.ok_or(ParseError::custom(
            "Invalid Cardano hash. Null or missing value.",
        ))?;
        let str = value.as_str().ok_or(ParseError::custom(
            "Invalid Cardano hash. Should be string.",
        ))?;
        hex::decode(str.strip_prefix("0x").ok_or(ParseError::custom(
            "Invalid Cardano hash. hex string should start with `0x`.",
        ))?)
        .map_err(|_| ParseError::custom("Invalid Cardano hash. Should be hex string."))
        .map(Self)
    }
}

impl ToJSON for Hash {
    fn to_json(&self) -> Option<serde_json::Value> {
        Some(serde_json::Value::String(as_hex_string(&self.0)))
    }
}
