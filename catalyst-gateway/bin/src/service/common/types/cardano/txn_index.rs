//! Transaction Index within a block.

use std::sync::LazyLock;

use catalyst_types::conversion::from_saturating;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::db::types::DbTxnIndex;

/// Title.
const TITLE: &str = "Transaction Index";
/// Description.
const DESCRIPTION: &str = "The Index of a transaction within a block.";
/// Example.
const EXAMPLE: u16 = 7;
/// Minimum.
const MINIMUM: u16 = 0;
/// Maximum.
const MAXIMUM: u16 = u16::MAX;
/// Invalid Error Msg.
const INVALID_MSG: &str = "Invalid Transaction Index.";

/// Schema.
#[allow(clippy::cast_lossless)]
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(EXAMPLE.into()),
        maximum: Some(MAXIMUM as f64),
        minimum: Some(MINIMUM as f64),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Transaction Index within a block.
#[derive(Debug, Eq, PartialEq, Hash, Clone)]
pub(crate) struct TxnIndex(u16);

/// Is the Slot Number valid?
fn is_valid(_value: u16) -> bool {
    true
}

impl Type for TxnIndex {
    type RawElementValueType = Self;
    type RawValueType = Self;

    const IS_REQUIRED: bool = true;

    fn name() -> std::borrow::Cow<'static, str> {
        "integer(u16)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema_ref =
            MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format("integer", "u16")));
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

impl ParseFromParameter for TxnIndex {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let idx: u16 = value.parse()?;
        Ok(Self(idx))
    }
}

impl ParseFromJSON for TxnIndex {
    fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
        let value = value.unwrap_or_default();
        if let Value::Number(value) = value {
            let value = value
                .as_u64()
                .ok_or(ParseError::from(INVALID_MSG))?
                .try_into()?;
            if !is_valid(value) {
                return Err(INVALID_MSG.into());
            }
            Ok(Self(value))
        } else {
            Err(ParseError::expected_type(value))
        }
    }
}

impl ToJSON for TxnIndex {
    fn to_json(&self) -> Option<Value> {
        Some(self.0.into())
    }
}

impl From<DbTxnIndex> for TxnIndex {
    fn from(val: DbTxnIndex) -> Self {
        let txn: i16 = val.into();
        Self(from_saturating(txn))
    }
}

impl From<cardano_blockchain_types::TxnIndex> for TxnIndex {
    fn from(value: cardano_blockchain_types::TxnIndex) -> Self {
        Self(value.into())
    }
}

impl Example for TxnIndex {
    fn example() -> Self {
        Self(EXAMPLE)
    }
}
