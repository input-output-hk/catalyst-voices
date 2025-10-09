//! A PEM (Privacy-Enhanced Mail) data.

use std::sync::LazyLock;

use anyhow::Context;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseResult, ToJSON, Type},
};
use serde_json::Value;
use x509_cert::{
    certificate::Certificate,
    der::{pem::LineEnding, DecodePem, EncodePem},
};

/// A title.
const TITLE: &str = "PEM data";
/// A description.
const DESCRIPTION: &str = "A PEM (Privacy-Enhanced Mail) data";

/// A schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Pem::example().to_json(),
        ..MetaSchema::ANY
    }
});

/// A PEM (Privacy-Enhanced Mail) data.
#[derive(Debug, Clone)]
pub struct Pem(String);

impl TryFrom<&Certificate> for Pem {
    type Error = anyhow::Error;

    fn try_from(cert: &Certificate) -> Result<Self, Self::Error> {
        Ok(Self(
            cert.to_pem(LineEnding::LF)
                .context("Failed to encode X509 certificate as PEM")?,
        ))
    }
}

impl Type for Pem {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "Pem".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("string", "pem")));
        schema_ref.merge(SCHEMA.clone())
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(self)
    }

    fn raw_element_iter<'a>(
        &'a self
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }

    fn is_empty(&self) -> bool {
        self.0.is_empty()
    }
}

impl ToJSON for Pem {
    fn to_json(&self) -> Option<Value> {
        Some(Value::String(self.0.clone()))
    }
}

impl ParseFromJSON for Pem {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        let Value::String(value) = value else {
            return Err(ParseError::expected_type(value));
        };
        Certificate::from_pem(value.as_bytes())?;
        Ok(Self(value))
    }
}

impl Example for Pem {
    fn example() -> Self {
        Self("-----BEGIN CERTIFICATE-----\nMIIB/DCCAa6gAwIBAgIFAOWtXb8wBQYDK2VwMEIxCTAHBgNVBAYTADEJMAcGA1UE\nCBMAMQkwBwYDVQQHEwAxCTAHBgNVBAoTADEJMAcGA1UECxMAMQkwBwYDVQQDEwAw\nHhcNMjUwMTI0MDI1NzQyWhcNOTkxMjMxMjM1OTU5WjBCMQkwBwYDVQQGEwAxCTAH\nBgNVBAgTADEJMAcGA1UEBxMAMQkwBwYDVQQKEwAxCTAHBgNVBAsTADEJMAcGA1UE\nAxMAMEowBQYDK2VwA0EAbkL45YmnbrsT7yed94Qe/Ol48Qa+4Zbw48/TR7sxouiO\nNnDJ/I+OMmL3x9OWMWLZsnv7kae52bG3y5zEMmsk0KOBpDCBoTCBngYDVR0RBIGW\nMIGTggxteWRvbWFpbi5jb22CEHd3dy5teWRvbWFpbi5jb22CC2V4YW1wbGUuY29t\ngg93d3cuZXhhbXBsZS5jb22GU3dlYitjYXJkYW5vOi8vYWRkci9zdGFrZV90ZXN0\nMXVyczh0MHNzYTN3OXdoOTBsZDV0cHJwM2d1cnhkNDg3cnRoMnFscWs2ZXJuanFj\nZWY0dWdyMAUGAytlcANBAEmuoa4m8PuT4flyPVz438xOsSgrybJ1m9o/1/02wiT2\nb2UCDRiIYbyIA6TMHn9gNsO36FfiGLgVPTisyM1Ktwc=\n-----END CERTIFICATE-----\n".into())
    }
}
