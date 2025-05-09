//! Cardano address types.
//!
//! More information can be found in [CIP-19](https://cips.cardano.org/cip/CIP-19)

use std::sync::LazyLock;

use catalyst_types::hashes::BLAKE_2B224_SIZE;
use const_format::concatcp;
use pallas::ledger::addresses::{Address, ShelleyAddress};
use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Title
const TITLE: &str = "Cardano Payment Address";
/// Description
const DESCRIPTION: &str = "Cardano Shelley Payment Address (CIP-19 Formatted).";
/// Example
// cSpell:disable
const EXAMPLE: &str = "addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3n0d3vllmyqwsx5wktcd8cc3sq835lu7drv2xwl2wywfgs68faae";
// cSpell:enable
/// Production Address Identifier
const PROD: &str = "addr";
/// Test Address Identifier
const TEST: &str = "addr_test";
/// Bech32 Match Pattern
const BECH32: &str = "[a,c-h,j-n,p-z,0,2-9]";
/// Length of the encoded address (for type 0 - 3).
const ENCODED_STAKED_ADDR_LEN: usize = 98;
/// Length of the encoded address (for type 6 - 7).
const ENCODED_UNSTAKED_ADDR_LEN: usize = 53;
/// Regex Pattern
const PATTERN: &str = concatcp!(
    "(",
    PROD,
    "|",
    TEST,
    ")1(",
    BECH32,
    "{",
    ENCODED_UNSTAKED_ADDR_LEN,
    "}|",
    BECH32,
    "{",
    ENCODED_STAKED_ADDR_LEN,
    "})$"
);

/// Header length
const HEADER_LEN: usize = 1;
/// Length of the decoded address.
const DECODED_UNSTAKED_ADDR_LEN: usize = BLAKE_2B224_SIZE;
/// Length of the decoded address.
const DECODED_STAKED_ADDR_LEN: usize = DECODED_UNSTAKED_ADDR_LEN * 2;
/// Minimum length
const MIN_LENGTH: usize = PROD.len() + 1 + ENCODED_UNSTAKED_ADDR_LEN;
/// Minimum length
const MAX_LENGTH: usize = TEST.len() + 1 + ENCODED_STAKED_ADDR_LEN;

/// External document for Cardano addresses.
static EXTERNAL_DOCS: LazyLock<MetaExternalDocument> = LazyLock::new(|| {
    MetaExternalDocument {
        url: "https://cips.cardano.org/cip/CIP-19".to_owned(),
        description: Some("CIP-19 - Cardano Addresses".to_owned()),
    }
});

/// Schema.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
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
fn is_valid(addr: &str) -> bool {
    // Just check the string can be safely converted into the type.
    if let Ok((hrp, addr)) = bech32::decode(addr) {
        let hrp = hrp.as_str();
        (addr.len() == (DECODED_UNSTAKED_ADDR_LEN + HEADER_LEN) || addr.len() == (DECODED_STAKED_ADDR_LEN + HEADER_LEN))
            && (hrp == PROD || hrp == TEST)
    } else {
        false
    }
}

impl_string_types!(
    Cip19ShelleyAddress,
    "string",
    "cardano:cip19-address",
    Some(SCHEMA.clone()),
    is_valid
);

impl TryFrom<Vec<u8>> for Cip19ShelleyAddress {
    type Error = anyhow::Error;

    fn try_from(bytes: Vec<u8>) -> Result<Self, Self::Error> {
        let addr = Address::from_bytes(&bytes)?;
        let Address::Shelley(addr) = addr else {
            return Err(anyhow::anyhow!("Not a Shelley address: {addr}"));
        };
        addr.try_into()
    }
}

impl TryFrom<ShelleyAddress> for Cip19ShelleyAddress {
    type Error = anyhow::Error;

    fn try_from(addr: ShelleyAddress) -> Result<Self, Self::Error> {
        let addr_str = addr
            .to_bech32()
            .map_err(|e| anyhow::anyhow!(format!("Invalid Shelley address {e}")))?;
        Ok(Self(addr_str))
    }
}

impl TryInto<ShelleyAddress> for Cip19ShelleyAddress {
    type Error = anyhow::Error;

    fn try_into(self) -> Result<ShelleyAddress, Self::Error> {
        let address_str = &self.0;
        let address = Address::from_bech32(address_str)?;
        match address {
            Address::Shelley(address) => Ok(address),
            _ => Err(anyhow::anyhow!("Invalid Shelley address")),
        }
    }
}

impl Example for Cip19ShelleyAddress {
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

#[cfg(test)]
mod tests {
    use regex::Regex;
    use super::*;

    #[test]
    fn test_cip19_shelley_address() {
        let regex = Regex::new(PATTERN).unwrap();

        // Test Vector: <https://cips.cardano.org/cip/CIP-19>
        // cspell: disable
        let valid = [
            EXAMPLE,
            "addr1qx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3n0d3vllmyqwsx5wktcd8cc3sq835lu7drv2xwl2wywfgse35a3x", 
            "addr1z8phkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gten0d3vllmyqwsx5wktcd8cc3sq835lu7drv2xwl2wywfgs9yc0hh", 
            "addr1yx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzerkr0vd4msrxnuwnccdxlhdjar77j6lg0wypcc9uar5d2shs2z78ve",
            "addr1x8phkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gt7r0vd4msrxnuwnccdxlhdjar77j6lg0wypcc9uar5d2shskhj42g",
            "addr1vx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzers66hrl8",
            "addr1w8phkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcyjy7wx",
            "addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3n0d3vllmyqwsx5wktcd8cc3sq835lu7drv2xwl2wywfgs68faae",
            "addr_test1zrphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gten0d3vllmyqwsx5wktcd8cc3sq835lu7drv2xwl2wywfgsxj90mg",
            "addr_test1yz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzerkr0vd4msrxnuwnccdxlhdjar77j6lg0wypcc9uar5d2shsf5r8qx",
            "addr_test1xrphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gt7r0vd4msrxnuwnccdxlhdjar77j6lg0wypcc9uar5d2shs4p04xh",
            "addr_test1vz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzerspjrlsz",
            "addr_test1wrphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcl6szpr",
        ];

        let invalid = [
            "addr1gx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer5pnz75xxcrzqf96k",
            "addr128phkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtupnz75xxcrtw79hu",
            "stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw",
            "stake178phkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcccycj5",
            "addr_test1gz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer5pnz75xxcrdw5vky",
            "addr_test12rphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtupnz75xxcryqrvmw",
            "stake_test1uqehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gssrtvn",
            "stake_test17rphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcljw6kf",
            "",
        ];
        // cspell: enable

        for v in valid {
            assert!(regex.is_match(v));
            assert!(Cip19ShelleyAddress::parse_from_parameter(v).is_ok());
        }
        for v in invalid {
            assert!(!regex.is_match(v));
            assert!(Cip19ShelleyAddress::parse_from_parameter(v).is_err());
        }
    }
}
