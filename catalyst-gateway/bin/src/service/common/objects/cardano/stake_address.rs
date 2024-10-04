//! Defines API schemas of Cardano address types.

use std::ops::Deref;

use pallas::ledger::addresses::{Address, StakeAddress as StakeAddressPallas};
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef, Registry},
    types::{ParseError, ParseFromParameter, ParseResult, Type},
};

/// Cardano stake address of the user.
/// Should a valid Bech32 encoded stake address followed by the `https://cips.cardano.org/cip/CIP-19/#stake-addresses.`
#[derive(Debug, Clone)]
pub(crate) struct StakeAddress(StakeAddressPallas);

impl StakeAddress {
    /// Creates a `CardanoStakeAddress` schema definition.
    fn schema() -> MetaSchema {
        let mut schema = MetaSchema::new("string");
        schema.title = Some(Self::name().to_string());
        schema.description = Some("The stake address of the user. Should a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.");
        schema.example = Some(serde_json::Value::String(
            // cspell: disable
            "stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw".to_string(),
            // cspell: enable
        ));
        schema.max_length = Some(64);
        schema.pattern = Some("(stake|stake_test)1[a,c-h,j-n,p-z,0,2-9]{53}".to_string());
        schema
    }
}

impl Deref for StakeAddress {
    type Target = StakeAddressPallas;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl Type for StakeAddress {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "CardanoStakeAddress".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        MetaSchemaRef::Reference(Self::name().to_string())
    }

    fn register(registry: &mut Registry) {
        registry.create_schema::<Self, _>(Self::name().to_string(), |_| Self::schema());
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

impl ParseFromParameter for StakeAddress {
    fn parse_from_parameter(param: &str) -> ParseResult<Self> {
        // prefix checks
        if !param.starts_with("stake") && !param.starts_with("stake_test") {
            return Err(ParseError::custom(
                "Invalid Cardano stake address. Should start with 'stake' or 'stake_test' prefix.",
            ));
        }
        let address = Address::from_bech32(param).map_err(|e| ParseError::custom(e.to_string()))?;
        match address {
            Address::Stake(stake_address) => Ok(Self(stake_address)),
            Address::Shelley(_) => {
                Err(ParseError::custom(
                    "Invalid Cardano stake address. Provided a Shelley address.",
                ))
            },
            Address::Byron(_) => {
                Err(ParseError::custom(
                    "Invalid Cardano stake address. Provided a Byron address.",
                ))
            },
        }
    }
}
