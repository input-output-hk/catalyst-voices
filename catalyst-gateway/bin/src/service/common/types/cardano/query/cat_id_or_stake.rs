//! Query Parameter that can take a CIP-19 stake address or a Catalyst Id.
//!
//! Allows us to have one parameter that can represent two things, uniformly.

// cSpell:ignoreRegExp cardano/Fftx

use std::sync::LazyLock;

use const_format::concatcp;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{ParseFromParameter, ParseResult, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::common::types::cardano::{
    catalyst_id::{self, CatalystId},
    cip19_stake_address::{self, Cip19StakeAddress},
};

/// A Query Parameter that can take a CIP-19 stake address, or a Catalyst Id
/// identifier. Defining these are mutually exclusive, as a single parameter is required
/// to be used.
#[derive(Clone)]
#[allow(clippy::large_enum_variant, dead_code)]
pub(crate) enum CatIdOrStake {
    /// A CIP-19 stake address
    Address(Cip19StakeAddress),
    /// A catalyst id
    CatId(CatalystId),
}

impl TryFrom<&str> for CatIdOrStake {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> std::result::Result<Self, Self::Error> {
        if let Ok(cat_id) = CatalystId::try_from(value) {
            Ok(Self::CatId(cat_id))
        } else if let Ok(stake_addr) = Cip19StakeAddress::try_from(value) {
            Ok(Self::Address(stake_addr))
        } else {
            anyhow::bail!("Not a valid \"Catalyst Id or Stake Address\" parameter.");
        }
    }
}

/// Title.
const TITLE: &str = "Catalyst Id or Stake Address.";
/// Description.
const DESCRIPTION: &str = "Restrict the query to this Catalyst Id or Stake Address. If neither are defined, the auth token is used.";
/// Example
const EXAMPLE: &str = cip19_stake_address::EXAMPLE;
/// Validation Regex Pattern
const PATTERN: &str = concatcp!(
    "^(",
    catalyst_id::PATTERN,
    ")|(",
    cip19_stake_address::PATTERN,
    ")$"
);
/// Format
const FORMAT: &str = concatcp!(catalyst_id::FORMAT, "|", cip19_stake_address::FORMAT);

/// Schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

impl Type for CatIdOrStake {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        format!("string({FORMAT})").into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("string", FORMAT)));
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

impl ParseFromParameter for CatIdOrStake {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        /// Regex to validate `CatIdOrStake`
        #[allow(clippy::unwrap_used)] // Safe because the Regex is constant
        static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

        if !RE.is_match(value) {
            return Err(anyhow::anyhow!(
                "Invalid \"Catalyst Id or Stake Address\" parameter format."
            )
            .into());
        }
        Ok(value.try_into()?)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_cat_id_or_stake() {
        // Test data
        // <https://cips.cardano.org/cip/CIP-19>
        // cspell: disable
        let valid = [
            EXAMPLE,
            "stake_test1uqehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gssrtvn",
            "stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw",
            "cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE",
        ];
        // cspell: enable

        // cspell: disable
        let invalid = [
            "invalidFftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE",
            "",
            "stake_2345",
        ];
        // cspell: enable

        for v in valid {
            assert!(CatIdOrStake::parse_from_parameter(v).is_ok());
        }
        for v in invalid {
            assert!(CatIdOrStake::parse_from_parameter(v).is_err());
        }
    }
}
