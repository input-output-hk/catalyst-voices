//! Signed Document Type
//!
//! List of `UUIDv4`.

use poem_openapi::{
    registry::{MetaExternalDocument, MetaSchema},
    types::{Example, ToJSON},
};

use self::generic::uuidv4;
use crate::service::common::types::{
    array_types::impl_array_types,
    generic::{self, uuidv4::UUIDv4},
};

/// Title.
const TITLE: &str = "Signed Document Type";
/// Description.
const DESCRIPTION: &str = "Document Type. List UUIDv4 Formatted 128bit value.";
/// External Documentation URI
const URI: &str =
    "https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/";
/// Description of the URI
const URI_DESCRIPTION: &str = "Specification";
/// Maximum length
const MAX_LENGTH: usize = usize::MAX;
/// Minimum length
const MIN_LENGTH: usize = 1;

impl_array_types!(
    /// Document type - list of `UUIDv4`
    DocumentType,
    UUIDv4,
    Some( MetaSchema {
        title: Some(TITLE.into()),
        description: Some(DESCRIPTION),
        max_items: Some(MAX_LENGTH),
        min_items: Some(MIN_LENGTH),
        items: Some(Box::new(UUIDv4::schema_ref())),
        external_docs: Some(MetaExternalDocument {
            url: URI.to_owned(),
            description: Some(URI_DESCRIPTION.to_owned()),
        }),
        example: Self::example().to_json(),
        ..MetaSchema::ANY
    })
);

impl DocumentType {
    /// Convert to sql format used for filter '{"uuid", "uuid"}'
    pub(crate) fn to_sql_array(&self) -> String {
        format!(
            "{{{}}}",
            self.0
                .iter()
                .map(|uuid| uuid.to_string())
                .collect::<Vec<String>>()
                .join(",")
        )
    }
}

impl Example for DocumentType {
    fn example() -> Self {
        Self(vec![uuidv4::UUIDv4::example(), uuidv4::UUIDv4::example()])
    }
}

impl From<Vec<uuid::Uuid>> for DocumentType {
    fn from(value: Vec<uuid::Uuid>) -> Self {
        Self(value.into_iter().map(UUIDv4::from).collect())
    }
}
