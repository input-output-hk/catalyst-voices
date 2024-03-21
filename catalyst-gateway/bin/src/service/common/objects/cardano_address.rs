//! Defines API schemas of Cardano address types.

use std::ops::Deref;

use pallas::ledger::addresses::{Address, StakeAddress};
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{ParseError, ParseFromParameter, ParseResult, Type},
};

/// Cardano stake address of the user.
/// Should a valid Bech32 encoded stake address followed by the `https://cips.cardano.org/cip/CIP-19/#stake-addresses.`
#[derive(Debug)]
pub(crate) struct CardanoStakeAddress(StakeAddress);

impl Deref for CardanoStakeAddress {
    type Target = StakeAddress;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl Type for CardanoStakeAddress {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "Cardano stake address".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format(
            "CardanoStakeAddress",
            "string",
        )))
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

impl ParseFromParameter for CardanoStakeAddress {
    fn parse_from_parameter(param: &str) -> ParseResult<Self> {
        let address = Address::from_bech32(param).map_err(|e| ParseError::custom(e.to_string()))?;
        if let Address::Stake(stake_address) = address {
            Ok(Self(stake_address))
        } else {
            Err(ParseError::custom("Invalid Cardano stake address"))
        }
    }
}
