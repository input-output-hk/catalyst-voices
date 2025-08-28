//! Signed Document Locator for CIDv0, Base32 CIDv1, and Base36 CIDv1
//!
//! Reference: https://docs.ipfs.tech/concepts/content-addressing

// cspell: words cidv

use std::sync::LazyLock;

use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema, MetaSchemaRef},
    types::{Example, ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use regex::Regex;
use serde_json::Value;

use crate::service::common::types::string_types::impl_string_types;

/// Title.
const TITLE: &str = "Signed Document Locator";
/// Description.
const DESCRIPTION: &str = "Document Locator in the IPFS CID formats";
// cspell: disable
/// Example for CIDv1 Base32.
const EXAMPLE_CID_V1_B32: &str = "bafybeihdwdcefgh4dqkjv67uzcmw7ojee6xedzdetojuzjevtenxquvyku";
/// Example for CIDv1 Base36.
#[allow(dead_code)]
const EXAMPLE_CID_V1_B36: &str = "k2k4r8jl0yz8qjgqbmc2cdu5hkqek5rj6flgnlkyywynci20j0iuyfuj";
/// Example for CIDv0.
#[allow(dead_code)]
const EXAMPLE_CID_V0: &str = "QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR";
// cspell: enable
/// Validation Regex Pattern
const PATTERN: &str = r"^(Qm[1-9A-HJ-NP-Za-km-z]{44})|(b[a-z2-7]{58})|([kK][0-9a-zA-Z]+)$";

/// Regular expression to validate cidv0, cidv1b32, and cidv1b36.
static REGEX: LazyLock<Regex> = LazyLock::new(|| Regex::new(PATTERN).unwrap());

/// Because ALL the constraints are defined above, we do not ever need to define them in
/// the API. BUT we do need to make a validator.
/// This helps enforce uniform validation.
fn is_valid(value: &str) -> bool {
    REGEX.is_match(value)
}

impl_string_types!(
    DocumentLocator,
    "string",
    "cidv0 || cidv1b32 || cidv1b36",
    Some(MetaSchema {
        title: Some(TITLE.to_owned()),
        description: Some(DESCRIPTION),
        external_docs: Some(MetaExternalDocument {
            url: "https://docs.ipfs.tech/concepts/content-addressing".to_owned(),
            description: Some("Content Identifiers (CIDs) | IPFS Docs".to_owned()),
        }),
        example: Some(EXAMPLE_CID_V1_B32.into()),
        max_length: Some(66),
        min_length: Some(2),
        pattern: Some(PATTERN.to_string()),
        ..poem_openapi::registry::MetaSchema::ANY
    }),
    is_valid
);

impl Example for DocumentLocator {
    fn example() -> Self {
        Self(EXAMPLE_CID_V1_B32.to_owned())
    }
}

impl From<catalyst_signed_doc::DocLocator> for DocumentLocator {
    fn from(value: catalyst_signed_doc::DocLocator) -> Self {
        Self(value.to_string())
    }
}
