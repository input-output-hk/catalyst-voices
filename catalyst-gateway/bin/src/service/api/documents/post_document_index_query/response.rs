//! Catalyst Signed Document Endpoint Response Objects.
use derive_more::{From, Into};
use poem_openapi::{
    types::{Example, ToJSON},
    NewType, Object,
};

use super::SignedDocBody;
use crate::service::common::{
    self,
    types::{
        array_types::impl_array_types,
        document::{
            doc_ref::DocumentReference, doc_type::DocumentType, id::DocumentId, ver::DocumentVer,
        },
    },
};

/// A single page of documents.
///
/// The page limit is defined by the number of document versions,
/// not the number of Document IDs.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct DocumentIndexList {
    /// List of documents that matched the filter.
    ///
    /// Documents are listed in ascending order.
    pub docs: IndexedDocumentDocumentedList,
    /// Current Page
    pub page: DocumentIndexListPage,
}

impl Example for DocumentIndexList {
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
pub(crate) struct DocumentIndexListPage(common::objects::generic::pagination::CurrentPage);

impl Example for DocumentIndexListPage {
    fn example() -> Self {
        Self(Example::example())
    }
}

// List of Indexed Document Documented
impl_array_types!(
    IndexedDocumentDocumentedList,
    IndexedDocumentDocumented,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(4_294_967_295),
        items: Some(Box::new(IndexedDocumentDocumented::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for IndexedDocumentDocumentedList {
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
pub(crate) struct DocumentIndexListDocumented(pub(crate) DocumentIndexList);

impl Example for DocumentIndexListDocumented {
    fn example() -> Self {
        Self(DocumentIndexList::example())
    }
}

/// List of Documents that matched the filter
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct IndexedDocument {
    /// Document ID that matches the filter
    #[oai(rename = "id")]
    pub doc_id: DocumentId,
    /// List of matching versions of the document.
    ///
    /// Versions are listed in ascending order.
    pub ver: IndexedDocumentVersionDocumentedList,
}

impl Example for IndexedDocument {
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
pub(crate) struct IndexedDocumentDocumented(pub(crate) IndexedDocument);

impl Example for IndexedDocumentDocumented {
    fn example() -> Self {
        Self(IndexedDocument::example())
    }
}

/// List of Documents that matched the filter
#[derive(Object, Debug, Clone)]
#[oai(example = true)]
pub(crate) struct IndexedDocumentVersion {
    /// Document Version that matches the filter
    pub ver: DocumentVer,
    /// Document Type that matches the filter
    #[oai(rename = "type")]
    pub doc_type: DocumentType,
    /// Document Reference that matches the filter
    #[oai(rename = "ref", skip_serializing_if_is_none)]
    pub doc_ref: Option<FilteredDocumentReference>,
    /// Document Reply Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub reply: Option<FilteredDocumentReference>,
    /// Document Template Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub template: Option<FilteredDocumentReference>,
    /// Document Brand Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub brand: Option<FilteredDocumentReference>,
    /// Document Campaign Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub campaign: Option<FilteredDocumentReference>,
    /// Document Category Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub category: Option<FilteredDocumentReference>,
}

impl Example for IndexedDocumentVersion {
    fn example() -> Self {
        Self {
            ver: DocumentVer::example(),
            doc_type: DocumentType::example(),
            doc_ref: Some(DocumentReference::example().into()),
            reply: None,
            template: None,
            brand: None,
            campaign: None,
            category: None,
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
pub(crate) struct FilteredDocumentReference(DocumentReference);

impl From<catalyst_signed_doc::DocumentRef> for FilteredDocumentReference {
    fn from(value: catalyst_signed_doc::DocumentRef) -> Self {
        Self(value.into())
    }
}

impl Example for FilteredDocumentReference {
    fn example() -> Self {
        Self(Example::example())
    }
}

// List of Indexed Document Version Documented
impl_array_types!(
    IndexedDocumentVersionDocumentedList,
    IndexedDocumentVersionDocumented,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(100),
        items: Some(Box::new(IndexedDocumentVersionDocumented::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for IndexedDocumentVersionDocumentedList {
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
pub(crate) struct IndexedDocumentVersionDocumented(pub(crate) IndexedDocumentVersion);

impl Example for IndexedDocumentVersionDocumented {
    fn example() -> Self {
        Self(IndexedDocumentVersion::example())
    }
}

impl TryFrom<SignedDocBody> for IndexedDocumentVersionDocumented {
    type Error = anyhow::Error;

    fn try_from(doc: SignedDocBody) -> Result<Self, Self::Error> {
        let mut doc_ref = None;
        let mut reply = None;
        let mut template = None;
        let mut brand = None;
        let mut campaign = None;
        let mut category = None;
        if let Some(json_meta) = doc.metadata() {
            let meta: catalyst_signed_doc::ExtraFields = serde_json::from_value(json_meta.clone())?;
            doc_ref = meta.doc_ref().map(Into::into);
            reply = meta.reply().map(Into::into);
            template = meta.template().map(Into::into);
            brand = meta.brand_id().map(Into::into);
            campaign = meta.campaign_id().map(Into::into);
            category = meta.campaign_id().map(Into::into);
        }

        Ok(IndexedDocumentVersionDocumented(IndexedDocumentVersion {
            ver: DocumentVer::new_unchecked(doc.ver().to_string()),
            doc_type: DocumentType::new_unchecked(doc.doc_type().to_string()),
            doc_ref,
            reply,
            template,
            brand,
            campaign,
            category,
        }))
    }
}
