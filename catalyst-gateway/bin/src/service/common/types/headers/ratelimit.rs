//! `RateLimit` Header type.
//!
//! This is a passive type, produced automatically by the CORS middleware.

use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
    sync::LazyLock,
};

use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Tite for the header in documentation.
const TITLE: &str = "RateLimit HTTP header.";

/// Description for the header in documentation.
const DESCRIPTION: &str = "Allows this server to advertise its quota policies and the current
service limits, thereby allowing clients to avoid being throttled.";

/// Example for the header in documentation.
const EXAMPLE: &str = r#""default";q=100;w=10"#;

/// External documentation for the header
static EXTERNAL_DOCS: LazyLock<MetaExternalDocument> = LazyLock::new(|| {
    MetaExternalDocument {
        url: "https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/".to_owned(),
        description: Some("IETF Draft - RateLimit header fields for HTTP".to_owned()),
    }
});

/// `OpenAPI` schema for the header in documentation.
static SCHEMA: LazyLock<MetaSchema> = LazyLock::new(|| {
    MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        example: Some(Value::String(EXAMPLE.to_string())),
        external_docs: Some(EXTERNAL_DOCS.clone()),
        ..poem_openapi::registry::MetaSchema::ANY
    }
});

// Access-Control-Allow-Origin Header String Type
impl_string_types!(
    RateLimitHeader,
    "string",
    "rate-limit",
    Some(SCHEMA.clone())
);
