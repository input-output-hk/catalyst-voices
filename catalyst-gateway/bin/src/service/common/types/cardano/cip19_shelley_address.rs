//! Cardano address types.
//!
//! More information can be found in [CIP-19](https://cips.cardano.org/cip/CIP-19)

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

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
    "})"
);
/// Length of the decoded address.
const DECODED_UNSTAKED_ADDR_LEN: usize = 28;
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
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(addr: &str) -> bool {
    // Just check the string can be safely converted into the type.
    if let Ok((hrp, addr)) = bech32::decode(addr) {
        let hrp = hrp.as_str();
        (addr.len() == DECODED_UNSTAKED_ADDR_LEN || addr.len() == DECODED_STAKED_ADDR_LEN)
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

impl Cip19ShelleyAddress {
    /// Create a new `PaymentAddress`.
    pub fn new(address: String) -> Self {
        Cip19ShelleyAddress(address)
    }
}

impl TryFrom<ShelleyAddress> for Cip19ShelleyAddress {
    type Error = anyhow::Error;

    fn try_from(addr: ShelleyAddress) -> Result<Self, Self::Error> {
        let addr_str = addr
            .to_bech32()
            .map_err(|e| anyhow::anyhow!(format!("Invalid payment address {e}")))?;
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
            _ => Err(anyhow::anyhow!("Invalid payment address")),
        }
    }
}

impl Example for Cip19ShelleyAddress {
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}
