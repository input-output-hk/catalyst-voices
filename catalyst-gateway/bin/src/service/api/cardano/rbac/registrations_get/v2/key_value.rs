//! A key value for role data.

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef, Registry},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};
use poem_openapi_derive::Union;

use crate::service::{
    api::cardano::rbac::registrations_get::{pem::Pem, v2::c509::HexEncodedC509},
    common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
};

/// A key value for role data.
#[derive(Union, Debug, Clone)]
#[oai(one_of)]
pub enum KeyValue {
    /// A public key.
    Pubkey(Ed25519HexEncodedPublicKey),
    /// A X509 certificate.
    X509(Pem),
    /// A C509 certificate.
    C509(HexEncodedC509),
}

/// A key value for role data.
#[derive(Debug, Clone)]
pub struct KeyValueWrapper(pub KeyValue);

impl Type for KeyValueWrapper {
    type RawElementValueType = <KeyValue as Type>::RawElementValueType;
    type RawValueType = <KeyValue as Type>::RawValueType;

    const IS_REQUIRED: bool = <KeyValue as Type>::IS_REQUIRED;

    fn name() -> std::borrow::Cow<'static, str> {
        KeyValue::name()
    }

    fn schema_ref() -> MetaSchemaRef {
        // adding missing example
        KeyValue::schema_ref().merge(MetaSchema {
            example: Self::example().to_json(),
            ..MetaSchema::ANY
        })
    }

    fn register(registry: &mut Registry) {
        KeyValue::register(registry);
        registry
            .schemas
            .entry(Self::name().into_owned())
            .and_modify(|schema| {
                // reset "type" field, because its wrongly set to "object" type by
                // `poem_openapi::Union` derive macro
                schema.ty = "";
            });
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        self.0.as_raw_value()
    }

    fn raw_element_iter<'a>(
        &'a self
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        self.0.raw_element_iter()
    }

    fn is_empty(&self) -> bool {
        self.0.is_empty()
    }

    fn is_none(&self) -> bool {
        self.0.is_none()
    }
}

impl ParseFromJSON for KeyValueWrapper {
    fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
        KeyValue::parse_from_json(value)
            .map(Self)
            .map_err(ParseError::propagate)
    }
}

impl ToJSON for KeyValueWrapper {
    fn to_json(&self) -> Option<serde_json::Value> {
        self.0.to_json()
    }
}

impl Example for KeyValueWrapper {
    fn example() -> Self {
        Self(KeyValue::Pubkey(Ed25519HexEncodedPublicKey::example()))
    }
}
