//! A Catalyst identifier.

// cSpell:ignoreRegExp cardano/Fftx

use std::{borrow::Cow, sync::LazyLock};

use anyhow::Context;
use catalyst_types::catalyst_id::CatalystId as CatalystIdInner;
use ed25519_dalek::SigningKey;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// Catalyst Id String Format
pub(crate) const FORMAT: &str = "catalyst_id";

/// Minimum format for Catalyst Id. (<`text`/`public_key_base64_url`>)
pub(crate) const PATTERN: &str = r".+\/[A-Za-z0-9_-]{43}";

/// A schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    let example = Some(CatalystId::example().0.to_string().into());
    MetaSchema {
        title: Some("Catalyst ID".into()),
        description: Some("Catalyst identifier in string format"),
        example,
        pattern: Some(PATTERN.into()),
        ..MetaSchema::ANY
    }
});

/// A Catalyst identifier.
#[derive(Debug, Clone, PartialEq, Hash)]
pub(crate) struct CatalystId(CatalystIdInner);

impl Type for CatalystId {
    type RawElementValueType = CatalystIdInner;
    type RawValueType = CatalystIdInner;

    const IS_REQUIRED: bool = true;

    fn name() -> Cow<'static, str> {
        format!("string({FORMAT})").into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("string", FORMAT)))
            .merge(SCHEMA.clone())
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(&self.0)
    }

    fn raw_element_iter<'a>(
        &'a self
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }
}

impl From<CatalystIdInner> for CatalystId {
    fn from(value: CatalystIdInner) -> Self {
        Self(value.as_short_id())
    }
}

impl From<CatalystId> for CatalystIdInner {
    fn from(value: CatalystId) -> Self {
        value.0
    }
}

impl TryFrom<&str> for CatalystId {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value
            .parse()
            .context("Invalid Catalyst ID")
            .map(|id: CatalystIdInner| Self(id.as_short_id()))
    }
}

impl ParseFromJSON for CatalystId {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        if let Value::String(value) = value {
            CatalystId::parse_from_parameter(&value)
        } else {
            Err(ParseError::expected_type(value))
        }
    }
}

impl ParseFromParameter for CatalystId {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        Ok(value.try_into()?)
    }
}

impl ToJSON for CatalystId {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.as_short_id().to_string().into())
    }
}

impl Example for CatalystId {
    fn example() -> Self {
        let secret_key_bytes = [
            157, 97, 177, 157, 239, 253, 90, 96, 186, 132, 74, 244, 146, 236, 44, 196, 68, 73, 197,
            105, 123, 50, 105, 25, 112, 59, 172, 3, 28, 174, 127, 96,
        ];
        let signing_key = &SigningKey::from_bytes(&secret_key_bytes);
        CatalystIdInner::new("cardano", Some("preprod"), signing_key.into())
            .as_id()
            .into()
    }
}
