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
use poem::http::HeaderMap;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{ParseFromParameter, ParseResult, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::common::{
    self,
    auth::api_key::check_api_key,
    types::{
        cardano::cip19_stake_address::Cip19StakeAddress,
        generic::ed25519_public_key::Ed25519HexEncodedPublicKey,
    },
};

/// A Query Parameter that can take a CIP-19 stake address, or a public key.
/// Defining these are mutually exclusive, as a single parameter is required to be used.
#[derive(Clone)]
pub(crate) enum StakeAddressOrPublicKey {
    /// A CIP-19 stake address
    Address(common::types::cardano::cip19_stake_address::Cip19StakeAddress),
    /// A Ed25519 Public Key
    PublicKey(common::types::generic::ed25519_public_key::Ed25519HexEncodedPublicKey),
    /// Special value that means we try to fetch all possible results.  Must be protected
    /// with an  `APIKey`.
    All,
}

impl From<StakeOrVoter> for StakeAddressOrPublicKey {
    fn from(value: StakeOrVoter) -> Self {
        value.0 .1
    }
}

impl TryFrom<&str> for StakeAddressOrPublicKey {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> std::result::Result<Self, Self::Error> {
        /// Regex to parse the parameter
        #[allow(clippy::unwrap_used)] // Safe because the Regex is constant.  Can never panic in prod.
        static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

        // First check it is the special "ALL" parameter.
        if value == "ALL" {
            return Ok(Self::All);
        }

        if let Ok(pub_key) = Ed25519HexEncodedPublicKey::try_from(value) {
            Ok(Self::PublicKey(pub_key))
        } else if let Ok(stake_addr) = Cip19StakeAddress::try_from(value) {
            Ok(Self::Address(stake_addr))
        } else {
            bail!("Not a valid \"Stake or Public Key\" parameter.");
        }
    }
}

/// Title.
const TITLE: &str = "Stake Address or Voting Key.";
/// Description.
const DESCRIPTION: &str = "Restrict the query to this Stake address, or Voters Public Key.
If neither are defined, the stake address(es) from the auth tokens role0 registration are used.";
/// Example
const EXAMPLE: &str = common::types::cardano::cip19_stake_address::EXAMPLE;
/// Stake Address Pattern
const STAKE_PATTERN: &str = common::types::cardano::cip19_stake_address::PATTERN;
/// Voting Key Pattern
const VOTING_KEY_PATTERN: &str = common::types::generic::ed25519_public_key::PATTERN;
/// Validation Regex Pattern
const PATTERN: &str = concatcp!("^(", STAKE_PATTERN, ")|(", VOTING_KEY_PATTERN, ")$");
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
    common::types::generic::ed25519_public_key::FORMAT
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

/// Either a Stake Address or a ED25519 Public key.
#[derive(Clone)]
pub(crate) struct StakeOrVoter((String, StakeAddressOrPublicKey));

impl TryFrom<&str> for StakeOrVoter {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> std::result::Result<Self, Self::Error> {
        Ok(Self((value.to_string(), value.try_into()?)))
    }
}

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
        Ok(Self((value.to_string(), value.try_into()?)))
    }
}

impl StakeOrVoter {
    /// Is this for ALL results?
    pub(crate) fn is_all(&self, headers: &HeaderMap) -> Result<bool> {
        match self.0 .1 {
            StakeAddressOrPublicKey::All => {
                check_api_key(headers)?;
                Ok(true)
            },
            _ => Ok(false),
        }
    }
}

impl TryInto<common::types::cardano::cip19_stake_address::Cip19StakeAddress> for StakeOrVoter {
    type Error = anyhow::Error;

    fn try_into(
        self,
    ) -> Result<common::types::cardano::cip19_stake_address::Cip19StakeAddress, Self::Error> {
        match self.0 .1 {
            StakeAddressOrPublicKey::Address(addr) => Ok(addr),
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
        match self.0 .1 {
            StakeAddressOrPublicKey::PublicKey(key) => Ok(key),
            _ => bail!("Not a Stake Address"),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::StakeAddressOrPublicKey;

    #[test]
    fn hex_to_stake_or_voter() {
        assert!(StakeAddressOrPublicKey::try_from(
            "stake1u94ullc9nj9gawc08990nx8hwgw80l9zpmr8re44kydqy9cdjq6rq",
        )
        .is_ok());

        assert!(StakeAddressOrPublicKey::try_from(
            "0x83B3B55589797EF953E24F4F0DBEE4D50B6363BCF041D15F6DBD33E014E54711",
        )
        .is_ok());
    }
}
