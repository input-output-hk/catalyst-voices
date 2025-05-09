//! Transaction ID.

use std::sync::LazyLock;

use cardano_blockchain_types::TransactionId;
use catalyst_types::hashes::BLAKE_2B256_SIZE;
use const_format::concatcp;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::{common::types::string_types::impl_string_types, utilities::as_hex_string};

/// Title.
const TITLE: &str = "Transaction Id/Hash";
/// Description.
const DESCRIPTION: &str = "The Blake2b-256 hash of the transaction.";
/// Example.
const EXAMPLE: &str = "0x27d0350039fb3d068cccfae902bf2e72583fc553e0aafb960bd9d76d5bff777b";
/// Length of the hex encoded string;
const ENCODED_LENGTH: usize = EXAMPLE.len();
/// Length of the hash itself;
const HASH_LENGTH: usize = BLAKE_2B256_SIZE;
/// Validation Regex Pattern
const PATTERN: &str = concatcp!("^0x", "[A-Fa-f0-9]{", HASH_LENGTH * 2, "}$");

/// Schema.
#[allow(clippy::cast_lossless)]
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(EXAMPLE.into()),
        max_length: Some(ENCODED_LENGTH),
        min_length: Some(ENCODED_LENGTH),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(hash: &str) -> bool {
    if hash.len() == ENCODED_LENGTH && hash.starts_with("0x") {
        #[allow(clippy::string_slice)] // 100% safe due to the above checks.
        let hash = &hash[2..];
        hex::decode(hash).is_ok()
    } else {
        false
    }
}

impl_string_types!(
    TxnId,
    "string",
    "hex:hash(32)",
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for TxnId {
    fn example() -> Self {
        Self(EXAMPLE.to_string())
    }
}

impl TryFrom<Vec<u8>> for TxnId {
    type Error = anyhow::Error;

    fn try_from(value: Vec<u8>) -> Result<Self, Self::Error> {
        if value.len() != HASH_LENGTH {
            anyhow::bail!("Hash Length Invalid.")
        }
        Ok(Self(as_hex_string(&value)))
    }
}

impl From<TransactionId> for TxnId {
    fn from(value: TransactionId) -> Self {
        Self(value.to_string())
    }
}

#[cfg(test)]
mod tests {
    use regex::Regex;

    use super::*;

    #[test]
    fn test_txn_id() {
        let regex = Regex::new(PATTERN).unwrap();
        assert!(regex.is_match(EXAMPLE));
        assert!(TxnId::parse_from_parameter(EXAMPLE).is_ok());

        let invalid = [
            "0x27d0350039fb3d068cccfae902bf2e72583fc5",
            "0x27d0350039fb3d068cccfae902bf2e72583fc553e0aafb960bd9d76d5bff777b0",
        ];
        for v in &invalid {
            assert!(!regex.is_match(v));
            assert!(TxnId::parse_from_parameter(v).is_err());
        }
    }
}
