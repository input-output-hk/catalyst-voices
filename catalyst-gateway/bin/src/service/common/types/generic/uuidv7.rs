//! `UUIDv7` Type.
//!
//! String Encoded `UUIDv7`

use std::sync::LazyLock;

use anyhow::bail;
use catalyst_types::uuid::UuidV7;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Title.
const TITLE: &str = "UUIDv7";
/// Description.
const DESCRIPTION: &str = "128 Bit UUID Version 7 - Timestamp + Random";
/// Example.
const EXAMPLE: &str = "01943a32-9f35-7a14-b364-36ad693465e6";
/// Length of the hex encoded string
pub(crate) const ENCODED_LENGTH: usize = EXAMPLE.len();
/// Validation Regex Pattern
pub(crate) const PATTERN: &str =
    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-7[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$";
/// Format
pub(crate) const FORMAT: &str = "uuidv7";

/// Schema
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        max_length: Some(ENCODED_LENGTH),
        min_length: Some(ENCODED_LENGTH),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Validate `UUIDv7` This part is done separately from the `PATTERN`
fn is_valid(uuidv7: &str) -> bool {
    /// Regex to validate `UUIDv7`
    #[allow(clippy::unwrap_used)] // Safe because the Regex is constant.
    static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

    if RE.is_match(uuidv7)
        && let Ok(uuid) = uuid::Uuid::parse_str(uuidv7)
    {
        return uuid.get_version() == Some(uuid::Version::SortRand);
    }
    false
}

impl_string_types!(UUIDv7, "string", FORMAT, Some(SCHEMA.clone()), is_valid);

impl Example for UUIDv7 {
    /// An example `UUIDv7`
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl TryFrom<&str> for UUIDv7 {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for UUIDv7 {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        if !is_valid(&value) {
            bail!("Invalid UUIDv7")
        }
        Ok(Self(value))
    }
}

impl TryInto<uuid::Uuid> for UUIDv7 {
    type Error = uuid::Error;

    fn try_into(self) -> Result<uuid::Uuid, Self::Error> {
        uuid::Uuid::parse_str(&self.0)
    }
}

impl From<UuidV7> for UUIDv7 {
    fn from(value: UuidV7) -> Self {
        Self(value.to_string())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_uuidv7() {
        let valid = [EXAMPLE, "01943A32-9F35-7A14-B364-36AD693465E6"];
        for v in &valid {
            assert!(UUIDv7::parse_from_parameter(v).is_ok());
        }
        // Try UUIDv4
        let invalid = "c9993e54-1ee1-41f7-ab99-3fdec865c744";
        assert!(UUIDv7::parse_from_parameter(invalid).is_err());
    }
}
