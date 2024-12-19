//! Generic Error Messages

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use const_format::concatcp;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Title.
const TITLE: &str = "Error Message";
/// Description.
const DESCRIPTION: &str = "This is an error message.";
/// Example.
const EXAMPLE: &str = "An error has occurred, the details of the error are ...";
/// Max Length
const MAX_LENGTH: usize = 256;
/// Min Length
const MIN_LENGTH: usize = 1;
/// Validation Regex Pattern
const PATTERN: &str = concatcp!("^(.){", MIN_LENGTH, ",", MAX_LENGTH, "}$");

/// Schema
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        max_length: Some(MAX_LENGTH),
        min_length: Some(MIN_LENGTH),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

/// Check if we match the regex.
fn is_valid(msg: &str) -> bool {
    /// Validation pattern
    #[allow(clippy::unwrap_used)] // Safe because the Regex is constant.  Can never panic in prod.
    static RE: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

    RE.is_match(msg)
}

impl_string_types!(
    ErrorMessage,
    "string",
    "error",
    Some(SCHEMA.clone()),
    is_valid
);

impl Example for ErrorMessage {
    /// An example 32 bytes ED25519 Public Key.
    fn example() -> Self {
        Self(EXAMPLE.to_owned())
    }
}

impl From<String> for ErrorMessage {
    fn from(val: String) -> Self {
        Self(val)
    }
}

impl From<&str> for ErrorMessage {
    fn from(val: &str) -> Self {
        Self(val.to_owned())
    }
}
