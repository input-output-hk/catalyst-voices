//! Access-Control-Allow-Origin Header type.
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
const TITLE: &str = "Access-Control-Allow-Origin header.";

/// Description for the header in documentation.
const DESCRIPTION: &str = "Valid formats:

* `Access-Control-Allow-Origin: *`
* `Access-Control-Allow-Origin: <origin>`
* `Access-Control-Allow-Origin: null`
";

/// Example for the header in documentation.
const EXAMPLE: &str = "*";

/// External documentation for the header
static EXTERNAL_DOCS: LazyLock<MetaExternalDocument> = LazyLock::new(|| {
    MetaExternalDocument {
        url:
            "https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin"
                .to_owned(),
        description: Some("MDB Web Docs - Access-Control-Allow-Origin".to_owned()),
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
    AccessControlAllowOriginHeader,
    "string",
    "origin",
    Some(SCHEMA.clone())
);
