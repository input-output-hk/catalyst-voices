//! Query Parameter that can take a CIP-19 stake address, or a hex encoded vote public
//! key.
//!
//! Allows us to have one parameter that can represent two things, uniformly.

use std::{
    cmp::{max, min},
    sync::LazyLock,
};

use anyhow::{bail, Result};
use const_format::concatcp;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{ParseFromParameter, ParseResult, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::common::{
    self,
    types::{
        cardano::cip19_stake_address::Cip19StakeAddress,
        generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
    },
};

/// A Query Parameter that can take a CIP-19 stake address, or a public key.
/// Defining these are mutually exclusive, as a single parameter is required to be used.
#[derive(Clone)]
pub(crate) enum StakeOrVoter {
    /// A CIP-19 stake address
    Address(common::types::cardano::cip19_stake_address::Cip19StakeAddress),
    /// A Ed25519 Public Key
    PublicKey(common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey),
    /// Special value that means we try to fetch all possible results.  Must be protected
    /// with an `APIKey`.
    All,
}

impl TryFrom<&str> for StakeOrVoter {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> std::result::Result<Self, Self::Error> {
        // First check it is the special "ALL" parameter.
        if value == "ALL" {
            Ok(Self::All)
        } else if let Ok(pub_key) = Ed25519HexEncodedPublicKey::try_from(value) {
            Ok(Self::PublicKey(pub_key))
        } else if let Ok(stake_addr) = Cip19StakeAddress::try_from(value) {
            Ok(Self::Address(stake_addr))
        } else {
            bail!("Not a valid \"Stake address, Voter public key, or ALL\" parameter.")
        }
    }
}

/// Title.
const TITLE: &str = "Stake Address, Voting Key, or ALL.";
/// Description.
const DESCRIPTION: &str = "Restrict the query to this Stake address, Voters Public Key,
or ALL (including both stake address and voter public key).
If neither are defined, the stake address(es) from the auth tokens role0 registration are used.";
/// Example
const EXAMPLE: &str = common::types::cardano::cip19_stake_address::EXAMPLE;
/// Validation Regex Pattern
const PATTERN: &str = concatcp!(
    "^(",
    common::types::cardano::cip19_stake_address::PATTERN,
    ")|(",
    common::types::generic::ed25519_public_key::PATTERN,
    ")|(",
    "ALL",
    ")$"
);
/// Minimum parameter length
static MIN_LENGTH: LazyLock<usize> = LazyLock::new(|| {
    min(
        common::types::cardano::cip19_stake_address::MIN_LENGTH,
        common::types::generic::ed25519_public_key::ENCODED_LENGTH,
    )
});
/// Maximum parameter length
static MAX_LENGTH: LazyLock<usize> = LazyLock::new(|| {
    max(
        common::types::cardano::cip19_stake_address::MAX_LENGTH,
        common::types::generic::ed25519_public_key::ENCODED_LENGTH,
    )
});

/// Format
const FORMAT: &str = concatcp!(
    common::types::cardano::cip19_stake_address::FORMAT,
    "|",
    common::types::generic::ed25519_public_key::FORMAT,
    "|",
    "ALL"
);

/// Schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        max_length: Some(*MAX_LENGTH),
        min_length: Some(*MIN_LENGTH),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

impl Type for StakeOrVoter {
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

impl ParseFromParameter for StakeOrVoter {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        /// Regex to validate `StakeOrVoter`
        #[allow(clippy::unwrap_used)] // Safe because the Regex is constant
        static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

        if !RE.is_match(value) {
            return Err(anyhow::anyhow!(
                "Invalid \"Stake address, Voter public key, or ALL\" parameter format."
            )
            .into());
        }
        Ok(value.try_into()?)
    }
}

impl TryInto<Cip19StakeAddress> for StakeOrVoter {
    type Error = anyhow::Error;

    fn try_into(self) -> Result<Cip19StakeAddress, Self::Error> {
        match self {
            Self::Address(addr) => Ok(addr),
            _ => bail!("Not a Stake Address"),
        }
    }
}

impl TryInto<common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey>
    for StakeOrVoter
{
    type Error = anyhow::Error;

    fn try_into(
        self,
    ) -> Result<common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey, Self::Error>
    {
        match self {
            Self::PublicKey(key) => Ok(key),
            _ => bail!("Not a Stake Address"),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_stake_or_voter() {
        // Test data
        // <https://github.com/cardano-foundation/CIPs/blob/master/CIP-0036/test-vector.md>
        // <https://cips.cardano.org/cip/CIP-19>
        // cspell: disable
        let valid = [
            EXAMPLE,
            "ALL",
            "0xe3cd2404c84de65f96918f18d5b445bcb933a7cda18eeded7945dd191e432369",
            "stake_test1uqehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gssrtvn",
            "stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw",
        ];
        // cspell: enable
        for v in valid {
            assert!(StakeOrVoter::parse_from_parameter(v).is_ok());
        }

        let invalid = [
            "0x",
            "",
            "stake1234",
            "0xe3cd2404c84de65f96918f18d5b445bcb933a7cda18eeded7945dd191e4323619",
        ];
        for v in invalid {
            assert!(StakeOrVoter::parse_from_parameter(v).is_err());
        }
    }
}
