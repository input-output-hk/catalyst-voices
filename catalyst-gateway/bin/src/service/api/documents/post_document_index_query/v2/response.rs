//! Catalyst Signed Document Endpoint Response Objects for `postDocumentV2`.

use derive_more::{From, Into};
use poem_openapi::{
    types::{Example, ToJSON},
    NewType, Object,
};

use crate::{
    db::event::signed_docs::SignedDocBody,
    service::common::{
        self,
        types::{
            array_types::impl_array_types,
            document::{
                doc_ref::DocumentReference, doc_ref_v2::DocumentReferenceListV2,
                doc_type::DocumentType, id::DocumentId, ver::DocumentVer,
            },
        },
    },
};

/// A single page of documents.
///
/// The page limit is defined by the number of document versions,
/// not the number of Document IDs.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct DocumentIndexListV2 {
    /// List of documents that matched the filter.
    ///
    /// Documents are listed in ascending order.
    pub docs: IndexedDocumentDocumentedListV2,
    /// Current Page
    pub page: DocumentIndexListPageV2,
}

impl Example for DocumentIndexListV2 {
    fn example() -> Self {
        Self {
            docs: Example::example(),
            page: Example::example(),
        }
    }
}

/// The Page of Document Index List.
#[derive(NewType, From, Into)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
pub(crate) struct DocumentIndexListPageV2(common::objects::generic::pagination::CurrentPage);

impl Example for DocumentIndexListPageV2 {
    fn example() -> Self {
        Self(Example::example())
    }
}

// List of Indexed Document Documented
impl_array_types!(
    IndexedDocumentDocumentedListV2,
    IndexedDocumentDocumentedV2,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(4_294_967_295),
        items: Some(Box::new(IndexedDocumentDocumentedV2::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for IndexedDocumentDocumentedListV2 {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Document Index List
///
/// A list of all matching documents, limited by the paging parameters.
/// Documents are listed in Ascending order.
/// The Paging limit refers to the number fo document versions, not the number
/// of unique Document IDs.
pub(crate) struct DocumentIndexListDocumentedV2(pub(crate) DocumentIndexListV2);

impl Example for DocumentIndexListDocumentedV2 {
    fn example() -> Self {
        Self(DocumentIndexListV2::example())
    }
}

/// List of Documents that matched the filter
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct IndexedDocumentV2 {
    /// Document ID that matches the filter
    #[oai(rename = "id")]
    pub doc_id: DocumentId,
    /// List of matching versions of the document.
    ///
    /// Versions are listed in ascending order.
    pub ver: IndexedDocumentVersionDocumentedListV2,
}

impl Example for IndexedDocumentV2 {
    fn example() -> Self {
        Self {
            doc_id: Example::example(),
            ver: Example::example(),
        }
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, Clone)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Individual Indexed Document
///
/// An Individual Indexed Document and its Versions.
/// Document Versions are listed in Ascending order.
pub(crate) struct IndexedDocumentDocumentedV2(pub(crate) IndexedDocumentV2);

impl Example for IndexedDocumentDocumentedV2 {
    fn example() -> Self {
        Self(IndexedDocumentV2::example())
    }
}

/// List of Documents that matched the filter
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct IndexedDocumentVersionV2 {
    /// Document Version that matches the filter
    pub ver: DocumentVer,
    /// Document Type that matches the filter
    #[oai(rename = "type")]
    pub doc_type: DocumentType,
    /// Document Reference that matches the filter
    #[oai(rename = "ref", skip_serializing_if_is_none)]
    pub doc_ref: Option<DocumentReferenceListV2>,
    /// Document Reply Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub reply: Option<DocumentReferenceListV2>,
    /// Document Template Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub template: Option<DocumentReferenceListV2>,
    /// Document Parameter Reference that matches the filter
    #[oai(rename = "doc_parameters", skip_serializing_if_is_none)]
    pub parameters: Option<DocumentReferenceListV2>,
}

impl Example for IndexedDocumentVersionV2 {
    fn example() -> Self {
        Self {
            ver: Example::example(),
            doc_type: Example::example(),
            doc_ref: Some(Example::example()),
            reply: None,
            template: None,
            parameters: None,
        }
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
pub(crate) struct FilteredDocumentReferenceV2(DocumentReference);

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

// List of Indexed Document Version Documented
impl_array_types!(
    IndexedDocumentVersionDocumentedListV2,
    IndexedDocumentVersionDocumentedV2,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(IndexedDocumentVersionDocumentedV2::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for IndexedDocumentVersionDocumentedListV2 {
    fn example() -> Self {
        Self(vec![Example::example()])
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType, Debug, Clone)]
#[oai(
    from_multipart = false,
    from_parameter = false,
    to_header = false,
    example = true
)]
/// Individual Document Version
///
/// A Matching version of the document.
///
/// Metadata fields which are not set in the document, are not included in the version
/// information. used to filter documents based on those metadata fields.
/// This is equivalent to returning documents where those metadata fields either do not
/// exist, or do exist, but have any value.
pub(crate) struct IndexedDocumentVersionDocumentedV2(pub(crate) IndexedDocumentVersionV2);

impl Example for IndexedDocumentVersionDocumentedV2 {
    fn example() -> Self {
        Self(IndexedDocumentVersionV2::example())
    }
}

impl TryFrom<SignedDocBody> for IndexedDocumentVersionDocumentedV2 {
    type Error = anyhow::Error;

    fn try_from(doc: SignedDocBody) -> Result<Self, Self::Error> {
        let mut doc_type = None;
        let mut doc_ref = None;
        let mut reply = None;
        let mut template = None;
        let mut parameters = None;
        if let Some(json_meta) = doc.metadata() {
            let meta = catalyst_signed_doc::Metadata::from_json(json_meta.clone())?;

            doc_type = Some(meta.doc_type()?).cloned();
            doc_ref = meta.doc_ref().cloned().map(Into::into);
            reply = meta.reply().cloned().map(Into::into);
            template = meta.template().cloned().map(Into::into);
            parameters = meta.parameters().cloned().map(Into::into);
        }

        if let Some(doc_type) = doc_type {
            Ok(IndexedDocumentVersionDocumentedV2(
                IndexedDocumentVersionV2 {
                    ver: DocumentVer::new_unchecked(doc.ver().to_string()),
                    doc_type: DocumentType::new_unchecked(doc_type.to_string()),
                    doc_ref,
                    reply,
                    template,
                    parameters,
                },
            ))
        } else {
            Err(anyhow::anyhow!("Missing doc type"))
        }
    }
}
