//! Cardano address types.
//!
//! More information can be found in [CIP-19](https://cips.cardano.org/cip/CIP-19)

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use pallas::ledger::addresses::{Address, StakeAddress};
use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Stake address title.
const STAKE_TITLE: &str = "Cardano stake address";
/// Stake address description.
const STAKE_DESCRIPTION: &str = "Cardano stake address, also known as a reward address.";
/// Stake address example.
// cSpell:disable
const STAKE_EXAMPLE: &str = "stake_vk1px4j0r2fk7ux5p23shz8f3y5y2qam7s954rgf3lg5merqcj6aetsft99wu";
// cSpell:enable


/// External document for Cardano addresses.
static EXTERNAL_DOCS: LazyLock<MetaExternalDocument> = LazyLock::new(|| MetaExternalDocument {
    url: "https://cips.cardano.org/cip/CIP-19".to_owned(),
    description: Some("CIP-19 - Cardano Addresses".to_owned()),
});

/// Schema for `StakeAddress`.
static STAKE_SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| MetaSchema {
    title: Some(STAKE_TITLE.to_owned()),
    description: Some(STAKE_DESCRIPTION),
    example: Some(Value::String(STAKE_EXAMPLE.to_string())),
    external_docs: Some(EXTERNAL_DOCS.clone()),
    max_length: Some(64),
    pattern: Some("(stake|stake_test)1[a,c-h,j-n,p-z,0,2-9]{53}".to_string()),
    ..poem_openapi::registry::MetaSchema::ANY
});

impl_string_types!(
    Cip19StakeAddress,
    "string",
    "cardano:cip19-address",
    Some(STAKE_SCHEMA.clone())
);

impl Cip19StakeAddress {
    /// Create a new `StakeAddress`.
    #[allow(dead_code)]
    pub fn new(address: String) -> Self {
        Cip19StakeAddress(address)
    }

    /// Convert a `StakeAddress` string to a `StakeAddress`.
    pub fn to_stake_address(&self) -> anyhow::Result<StakeAddress> {
        let address_str = &self.0;
        let address = Address::from_bech32(address_str)?;
        match address {
            Address::Stake(stake_address) => Ok(stake_address),
            _ => Err(anyhow::anyhow!("Invalid stake address")),
        }
    }

    /// Convert a `StakeAddress` to a `StakeAddress` string.
    #[allow(dead_code)]
    pub fn from_stake_address(addr: &StakeAddress) -> anyhow::Result<Self> {
        let addr_str = addr
            .to_bech32()
            .map_err(|e| anyhow::anyhow!(format!("Invalid stake address {e}")))?;
        Ok(Self(addr_str))
    }
}
