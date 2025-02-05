//! Catalyst Signed Document Endpoint Response Objects.
use poem_openapi::{types::Example, NewType, Object};

use super::SignedDocBody;
use crate::service::common::{
    self,
    types::document::{
        doc_ref::DocumentReference, doc_type::DocumentType, id::DocumentId, ver::DocumentVer,
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
    #[oai(validator(max_items = "100"))]
    pub docs: Vec<IndexedDocumentDocumented>,
    /// Current Page
    pub page: Option<common::objects::generic::pagination::CurrentPage>,
}

impl Example for DocumentIndexList {
    fn example() -> Self {
        Self {
            docs: vec![IndexedDocumentDocumented::example()],
            page: Some(common::objects::generic::pagination::CurrentPage::example()),
        }
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
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct IndexedDocument {
    /// Document ID that matches the filter
    #[oai(rename = "id")]
    pub doc_id: DocumentId,
    /// List of matching versions of the document.
    ///
    /// Versions are listed in ascending order.
    #[oai(validator(max_items = "100"))]
    pub ver: Vec<IndexedDocumentVersionDocumented>,
}

impl Example for IndexedDocument {
    fn example() -> Self {
        Self {
            doc_id: DocumentId::example(),
            ver: vec![IndexedDocumentVersionDocumented::example()],
        }
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
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct IndexedDocumentVersion {
    /// Document Version that matches the filter
    pub ver: DocumentVer,
    /// Document Type that matches the filter
    #[oai(rename = "type")]
    pub doc_type: DocumentType,
    /// Document Reference that matches the filter
    #[oai(rename = "ref", skip_serializing_if_is_none)]
    pub doc_ref: Option<DocumentReference>,
    /// Document Reply Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub reply: Option<DocumentReference>,
    /// Document Template Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub template: Option<DocumentReference>,
    /// Document Brand Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub brand: Option<DocumentReference>,
    /// Document Campaign Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub campaign: Option<DocumentReference>,
    /// Document Category Reference that matches the filter
    #[oai(skip_serializing_if_is_none)]
    pub category: Option<DocumentReference>,
}

impl Example for IndexedDocumentVersion {
    fn example() -> Self {
        Self {
            ver: DocumentVer::example(),
            doc_type: DocumentType::example(),
            doc_ref: Some(DocumentReference::example()),
            reply: None,
            template: None,
            brand: None,
            campaign: None,
            category: None,
        }
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
