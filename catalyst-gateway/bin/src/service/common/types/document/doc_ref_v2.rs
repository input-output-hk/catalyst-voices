//! Signed Document Reference V2 for Signed Docs v0.04
//!
//! A Reference is used by the `ref` metadata, and any other reference to another
//! document.

use poem_openapi::{
    types::{Example, ToJSON},
    Object,
};

use super::{id::DocumentId, locator::DocumentLocator, ver::DocumentVer};
use crate::service::common::types::array_types::impl_array_types;

#[derive(Object, Debug, Clone, PartialEq)]
#[oai(example = true)]
/// A Reference to another Signed Document
pub(crate) struct DocumentReferenceV2 {
    /// Document ID Reference
    #[oai(rename = "id")]
    doc_id: DocumentId,
    /// Document Version
    #[oai(skip_serializing_if_is_none)]
    ver: DocumentVer,
    /// Document Locator
    #[oai(skip_serializing_if_is_none)]
    cid: Option<DocumentLocator>,
}

impl Example for DocumentReferenceV2 {
    fn example() -> Self {
        Self {
            doc_id: DocumentId::example(),
            ver: DocumentVer::example(),
            cid: Some(DocumentLocator::example()),
        }
    }
}

impl From<catalyst_signed_doc::DocumentRef> for DocumentReferenceV2 {
    fn from(value: catalyst_signed_doc::DocumentRef) -> Self {
        Self {
            doc_id: (*value.id()).into(),
            ver: (*value.ver()).into(),
            cid: if value.doc_locator().is_empty() {
                None
            } else {
                Some(value.doc_locator().clone().into())
            },
        }
    }
}

impl_array_types!(
    DocumentReferenceListV2,
    DocumentReferenceV2,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(10),
        items: Some(Box::new(DocumentReferenceV2::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for DocumentReferenceListV2 {
    fn example() -> Self {
        Self(vec![DocumentReferenceV2::example()])
    }
}

impl From<catalyst_signed_doc::DocumentRefs> for DocumentReferenceListV2 {
    fn from(value: catalyst_signed_doc::DocumentRefs) -> Self {
        let doc_refs = value
            .doc_refs()
            .iter()
            .cloned()
            .map(DocumentReferenceV2::from)
            .collect();

        Self(doc_refs)
    }
}
