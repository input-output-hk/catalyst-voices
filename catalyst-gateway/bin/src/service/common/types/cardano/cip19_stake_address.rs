//! Cardano address types.
//!
//! More information can be found in [CIP-19](https://cips.cardano.org/cip/CIP-19)

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use anyhow::bail;
use const_format::concatcp;
use pallas::ledger::addresses::{Address, StakeAddress};
use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::common::types::{
    cardano::hash29::HexEncodedHash29, string_types::impl_string_types,
};

/// Stake address title.
const TITLE: &str = "Cardano stake address";
/// Stake address description.
const DESCRIPTION: &str = "Cardano stake address, also known as a reward address.";
/// Stake address example.
// cSpell:disable
pub(crate) const EXAMPLE: &str = "stake_test1uqehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gssrtvn";
// cSpell:enable
/// Production Stake Address Identifier
const PROD_STAKE: &str = "stake";
/// Test Stake Address Identifier
const TEST_STAKE: &str = "stake_test";
/// Regex Pattern
pub(crate) const PATTERN: &str = concatcp!(
    "(",
    PROD_STAKE,
    "|",
    TEST_STAKE,
    ")1[a,c-h,j-n,p-z,0,2-9]{53}"
);
/// Length of the encoded address.
const ENCODED_ADDR_LEN: usize = 53;
/// Length of the decoded address.
const DECODED_ADDR_LEN: usize = 29;
/// Minimum length
pub(crate) const MIN_LENGTH: usize = PROD_STAKE.len() + 1 + ENCODED_ADDR_LEN;
/// Minimum length
pub(crate) const MAX_LENGTH: usize = TEST_STAKE.len() + 1 + ENCODED_ADDR_LEN;

/// String Format
pub(crate) const FORMAT: &str = "cardano:cip19-address";

/// External document for Cardano addresses.
static EXTERNAL_DOCS: LazyLock<MetaExternalDocument> = LazyLock::new(|| {
    MetaExternalDocument {
        url: "https://cips.cardano.org/cip/CIP-19".to_owned(),
        description: Some("CIP-19 - Cardano Addresses".to_owned()),
    }
});

/// Schema for `StakeAddress`.
static STAKE_SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        external_docs: Some(EXTERNAL_DOCS.clone()),
        min_length: Some(MIN_LENGTH),
        max_length: Some(MAX_LENGTH),
        pattern: Some(PATTERN.to_string()),
        ..MetaSchema::ANY
    }
});

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(stake_addr: &str) -> bool {
    // Just check the string can be safely converted into the type.
    if let Ok((hrp, addr)) = bech32::decode(stake_addr) {
        let hrp = hrp.as_str();
        addr.len() == DECODED_ADDR_LEN && (hrp == PROD_STAKE || hrp == TEST_STAKE)
    } else {
        false
    }
}

impl_string_types!(
    Cip19StakeAddress,
    "string",
    FORMAT,
    Some(STAKE_SCHEMA.clone()),
    is_valid
);

impl TryFrom<&str> for Cip19StakeAddress {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for Cip19StakeAddress {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        match bech32::decode(&value) {
            Ok((hrp, addr)) => {
                let hrp = hrp.as_str();
                if addr.len() == DECODED_ADDR_LEN && (hrp == PROD_STAKE || hrp == TEST_STAKE) {
                    return Ok(Cip19StakeAddress(value));
                }
                bail!("Invalid CIP-19 formatted Stake Address")
            },
            Err(err) => {
                bail!("Invalid CIP-19 formatted Stake Address : {err}");
            },
        };
    }
}

impl TryFrom<StakeAddress> for Cip19StakeAddress {
    type Error = anyhow::Error;

    fn try_from(addr: StakeAddress) -> Result<Self, Self::Error> {
        let addr_str = addr
            .to_bech32()
            .map_err(|e| anyhow::anyhow!(format!("Invalid stake address {e}")))?;
        Ok(Self(addr_str))
    }
}

impl TryInto<StakeAddress> for Cip19StakeAddress {
    type Error = anyhow::Error;

    fn try_into(self) -> Result<StakeAddress, Self::Error> {
        let address_str = &self.0;
        let address = Address::from_bech32(address_str)?;
        match address {
            Address::Stake(address) => Ok(address),
            _ => Err(anyhow::anyhow!("Invalid stake address")),
        }
    }
}

impl TryInto<HexEncodedHash29> for Cip19StakeAddress {
    type Error = anyhow::Error;

    fn try_into(self) -> Result<HexEncodedHash29, Self::Error> {
        let stake_addr: StakeAddress = self.try_into()?;
        HexEncodedHash29::try_from(stake_addr.payload().as_hash().to_vec())
    }
}

impl Example for Cip19StakeAddress {
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    // cspell: disable
    const VALID_PROD_STAKE_ADDRESS: &str =
        "stake1u94ullc9nj9gawc08990nx8hwgw80l9zpmr8re44kydqy9cdjq6rq";
    const VALID_TEST_STAKE_ADDRESS: &str =
        "stake_test1uqehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gssrtvn";
    const INVALID_STAKE_ADDRESS: &str =
        "invalid1u9nlq5nmuzthw3vhgakfpxyq4r0zl2c0p8uqy24gpyjsa6c3df4h6";
    // cspell: enable

    #[test]
    fn test_valid_stake_address_from_string() {
        let stake_address_prod = Cip19StakeAddress::try_from(VALID_PROD_STAKE_ADDRESS.to_string());
        let stake_address_test = Cip19StakeAddress::try_from(VALID_TEST_STAKE_ADDRESS.to_string());

        assert!(stake_address_prod.is_ok());
        assert!(stake_address_test.is_ok());
        assert_eq!(stake_address_prod.unwrap().0, VALID_PROD_STAKE_ADDRESS);
        assert_eq!(stake_address_test.unwrap().0, VALID_TEST_STAKE_ADDRESS);
    }

    #[test]
    fn test_invalid_stake_address_from_string() {
        let stake_address = Cip19StakeAddress::try_from(INVALID_STAKE_ADDRESS.to_string());
        assert!(stake_address.is_err());
    }

    #[test]
    fn cip19_stake_address_to_stake_address() {
        let stake_address_prod =
            Cip19StakeAddress::try_from(VALID_PROD_STAKE_ADDRESS.to_string()).unwrap();

        let stake_addr: StakeAddress = stake_address_prod.try_into().unwrap();

        assert!(stake_addr.payload().as_hash().len() == 28);
    }
}
