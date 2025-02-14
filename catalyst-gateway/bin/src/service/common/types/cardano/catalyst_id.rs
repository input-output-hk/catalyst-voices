//! A Catalyst short identifier.

// cSpell:ignoreRegExp cardano/Fftx

use std::{borrow::Cow, sync::LazyLock};

use catalyst_types::id_uri::IdUri;
use ed25519_dalek::SigningKey;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some("Catalyst short ID".into()),
        description: Some("Catalyst short identifier in string format"),
        example: Some("cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE".into()),
        ..MetaSchema::ANY
    }
});

/// A Catalyst short identifier.
#[derive(Debug, Clone, PartialEq, Hash)]
pub(crate) struct CatalystId(IdUri);

impl Type for CatalystId {
    type RawElementValueType = IdUri;
    type RawValueType = IdUri;

    const IS_REQUIRED: bool = true;

    fn name() -> Cow<'static, str> {
        "string(<network>/<public key>)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format(
            "string",
            "<network>/<public key>",
        )))
        .merge(SCHEMA.clone())
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(&self.0)
    }

    fn raw_element_iter<'a>(
        &'a self,
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }
}

impl From<IdUri> for CatalystId {
    fn from(value: IdUri) -> Self {
        Self(value.as_short_id())
    }
}

impl From<CatalystId> for IdUri {
    fn from(value: CatalystId) -> Self {
        value.0
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
        let id: IdUri = match value.parse() {
            Ok(v) => v,
            Err(e) => return Err(format!("Invalid Catalyst ID: {e:?}").into()),
        };
        Ok(Self(id.as_short_id()))
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
            157, 097, 177, 157, 239, 253, 090, 096, 186, 132, 074, 244, 146, 236, 044, 196, 068,
            073, 197, 105, 123, 050, 105, 025, 112, 059, 172, 003, 028, 174, 127, 096,
        ];
        let signing_key = &SigningKey::from_bytes(&secret_key_bytes);
        IdUri::new("cardano", None, signing_key.into()).into()
    }
}
