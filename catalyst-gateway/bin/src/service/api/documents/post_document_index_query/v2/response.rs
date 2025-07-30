//! Catalyst Signed Document Endpoint Response Objects.
use poem_openapi::{types::Example, NewType, Object};

use crate::{
    db::event::signed_docs::FullSignedDoc,
    service::common::types::document::{
        doc_ref_v2::DocumentReferenceListV2, doc_type::DocumentType, ver::DocumentVer
    },
};

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
        Self(Example::example())
    }
}

impl TryFrom<FullSignedDoc> for IndexedDocumentVersionDocumentedV2 {
    type Error = anyhow::Error;

    fn try_from(doc: FullSignedDoc) -> Result<Self, Self::Error> {
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
