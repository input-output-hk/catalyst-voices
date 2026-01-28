//! Signed Document Reference V2 for Signed Docs v0.04
//!
//! A Reference is used by the `ref` metadata, and any other reference to another
//! document.

use derive_more::{From, Into};
use poem_openapi::{
    NewType, Object,
    types::{Example, ToJSON},
};

use super::{id::DocumentId, locator::DocumentLocator, ver::DocumentVer};
use crate::service::common::types::array_types::impl_array_types;

#[derive(Object, Debug, Clone, PartialEq)]
#[oai(example)]
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
            cid: Some(value.doc_locator().clone().into()),
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
            .iter()
            .cloned()
            .map(DocumentReferenceV2::from)
            .collect();

        Self(doc_refs)
    }
}

/// Document Reference for filtered Documents.
#[derive(NewType, Debug, Clone, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct FilteredDocumentReferenceV2(DocumentReferenceV2);

impl From<catalyst_signed_doc::DocumentRef> for FilteredDocumentReferenceV2 {
    fn from(value: catalyst_signed_doc::DocumentRef) -> Self {
        Self(value.into())
    }
}

impl Example for FilteredDocumentReferenceV2 {
    fn example() -> Self {
        Self(Example::example())
    }
}
