//! Catalyst Singed Document Request Filter Query Object

use poem_openapi::{types::Example, NewType, Object};

use crate::{
    db::event::signed_docs::DocsQueryFilter,
    service::common::types::document::{
        doc_ref::IdAndVerRefDocumented, doc_type::DocumentType, id::EqOrRangedIdDocumented,
        ver::EqOrRangedVerDocumented,
    },
};

/// Query Filter for the generation of a signed document index.
///
/// The Query works as a filter which acts like a sieve to filter out documents
/// which do not strictly match the metadata or payload fields included in the query
/// itself.
#[allow(clippy::doc_markdown)]
#[derive(Object, Default)]
#[oai(example = true)]
pub(crate) struct DocumentIndexQueryFilter {
    /// ## Signed Document Type.  
    ///
    /// The document type must match one of the
    /// [Registered Document Types](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/)
    ///
    /// UUIDv4 Formatted 128bit value.
    #[oai(rename = "type", skip_serializing_if_is_none)]
    doc_type: Option<DocumentType>,
    /// ## Document ID
    ///
    /// Either an absolute single Document ID or a range of
    /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
    #[oai(skip_serializing_if_is_none)]
    id: Option<EqOrRangedIdDocumented>,
    /// ## Document Version
    ///
    /// Either an absolute single Document Version or a range of
    /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
    #[oai(skip_serializing_if_is_none)]
    ver: Option<EqOrRangedVerDocumented>,
    /// ## Document Reference
    ///
    /// A [reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#ref-document-reference)
    /// to another signed document.  This fields can match any reference that matches the
    /// defined [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
    /// and/or
    /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
    ///
    /// The kind of document that the reference refers to is defined by the
    /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/)
    #[oai(rename = "ref", skip_serializing_if_is_none)]
    doc_ref: Option<IdAndVerRefDocumented>,
    /// ## Document Template
    ///
    /// Documents that are created based on a template include the
    /// [template reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#template-template-reference)
    /// to another signed document.  This fields can match any template reference that
    /// matches the defined [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
    /// and/or
    /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
    ///
    /// The kind of document that the reference refers to is defined by the
    /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/)
    /// however, it will always be a template type document that matches the document
    /// itself.
    #[oai(skip_serializing_if_is_none)]
    template: Option<IdAndVerRefDocumented>,
    /// ## Document Reply
    ///
    /// This is a
    /// [reply reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#reply-reply-reference)
    /// which links one document to another, when acting as a reply to it.
    /// Replies typically reference the same kind of document.  
    /// This fields can match any reply reference that matches the defined
    /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
    /// and/or
    /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
    ///
    /// The kind of document that the reference refers to is defined by the
    /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/).
    #[oai(skip_serializing_if_is_none)]
    reply: Option<IdAndVerRefDocumented>,
    /// ## Brand
    ///
    /// This is a
    /// [brand reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#brand_id)
    /// to a brand document which defines the brand the document falls under.
    /// This fields can match any brand reference that matches the defined
    /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
    /// and/or
    /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
    ///
    /// Whether a Document Type has a brand reference is defined by its
    /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/).
    #[oai(skip_serializing_if_is_none)]
    brand: Option<IdAndVerRefDocumented>,
    /// ## Campaign
    ///
    /// This is a
    /// [campaign reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#campaign_id)
    /// to a campaign document which defines the campaign the document falls under.
    /// This fields can match any campaign reference that matches the defined
    /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
    /// and/or
    /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
    ///
    /// Whether a Document Type has a campaign reference is defined by its
    /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/).
    #[oai(skip_serializing_if_is_none)]
    campaign: Option<IdAndVerRefDocumented>,
    /// ## Category
    ///
    /// This is a
    /// [category reference](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/meta/#category_id)
    /// to a category document which defines the category the document falls under.
    /// This fields can match any category reference that matches the defined
    /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id)
    /// and/or
    /// [Document Versions](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver)
    ///
    /// Whether a Document Type has a category reference is defined by its
    /// [Document Type](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/types/).
    #[oai(skip_serializing_if_is_none)]
    category: Option<IdAndVerRefDocumented>,
}

impl Example for DocumentIndexQueryFilter {
    fn example() -> Self {
        Self {
            doc_type: Some(DocumentType::example()),
            id: Some(EqOrRangedIdDocumented::example()),
            ver: Some(EqOrRangedVerDocumented::example()),
            doc_ref: Some(IdAndVerRefDocumented::example_id_ref()),
            template: Some(IdAndVerRefDocumented::example_id_and_ver_ref()),
            reply: Some(IdAndVerRefDocumented::example()),
            ..Default::default()
        }
    }
}

// Note: We need to do this, because POEM doesn't give us a way to set `"title"` for the
// openapi docs on an object.
#[derive(NewType)]
#[oai(from_multipart = false, from_parameter = false, to_header = false)]
/// Document Index Query Filter
///
/// A Query Filter which causes documents whose metadata matches the provided
/// fields to be returned in the index list response.
///
/// Fields which are not set, are not used to filter documents based on those metadata
/// fields. This is equivalent to returning documents where those metadata fields either
/// do not exist, or do exist, but have any value.
pub(crate) struct DocumentIndexQueryFilterBody(pub(crate) DocumentIndexQueryFilter);

impl TryFrom<DocumentIndexQueryFilter> for DocsQueryFilter {
    type Error = anyhow::Error;

    fn try_from(value: DocumentIndexQueryFilter) -> Result<Self, Self::Error> {
        let mut db_filter = DocsQueryFilter::all();
        if let Some(doc_type) = value.doc_type {
            db_filter = db_filter.with_type(doc_type.parse()?);
        }
        if let Some(id) = value.id {
            db_filter = db_filter.with_id(id.0.try_into()?);
        }
        if let Some(ver) = value.ver {
            db_filter = db_filter.with_ver(ver.0.try_into()?);
        }
        // TODO process also the rest of the fields like `ref`, `template` etc.
        Ok(db_filter)
    }
}
