//! `UUIDv7` Type.
//!
//! String Encoded `UUIDv7`

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use anyhow::bail;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Title.
const TITLE: &str = "UUIDv4";
/// Description.
const DESCRIPTION: &str = "128 Bit UUID Version 4 - Random";
/// Example.
const EXAMPLE: &str = "c9993e54-1ee1-41f7-ab99-3fdec865c744 ";
/// Length of the hex encoded string
pub(crate) const ENCODED_LENGTH: usize = EXAMPLE.len();
/// Validation Regex Pattern
pub(crate) const PATTERN: &str =
    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA0F]{3}-[0-9a-fA-F]{12}$";
/// Format
pub(crate) const FORMAT: &str = "uuid";

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

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(uuidv4: &str) -> bool {
    // Just check the string can be safely converted into the type.
    // All the necessary validation is done in that process.
    if let Ok(uuid) = uuid::Uuid::parse_str(uuidv4) {
        uuid.get_version() == Some(uuid::Version::Random)
    } else {
        false
    }
}

impl_string_types!(UUIDv4, "string", FORMAT, Some(SCHEMA.clone()), is_valid);

impl Example for UUIDv4 {
    /// An example `UUIDv4`
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl TryFrom<&str> for UUIDv4 {
    type Error = anyhow::Error;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        value.to_string().try_into()
    }
}

impl TryFrom<String> for UUIDv4 {
    type Error = anyhow::Error;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        if !is_valid(&value) {
            bail!("Invalid UUIDv4")
        }
        Ok(Self(value))
    }
}

impl TryInto<uuid::Uuid> for UUIDv4 {
    type Error = uuid::Error;

    fn try_into(self) -> Result<uuid::Uuid, Self::Error> {
        uuid::Uuid::parse_str(&self.0)
    }
}
