//! Document Index Query V1 endpoint request objects.

use poem_openapi::{
    NewType, Object,
    types::{Example, ToJSON},
};

use crate::{
    db::event::signed_docs::DocsQueryFilter,
    service::common::types::{
        array_types::impl_array_types,
        document::{
            doc_type::DocumentType, id::IdSelectorDocumented,
            id_and_ver_ref::IdAndVerRefDocumented, ver::VerSelectorDocumented,
        },
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
pub(crate) struct DocumentIndexQueryFilterV2 {
    /// ## Signed Document Type.  
    ///
    /// The document type must match one of the
    /// [Registered Document Types](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/)
    ///
    /// UUIDv4 Formatted 128bit value.
    #[oai(rename = "type", skip_serializing_if_is_none)]
    doc_type: Option<DocumentTypeList>,
    /// ## Document ID
    ///
    /// Either an absolute single Document ID or a range of
    /// [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
    #[oai(skip_serializing_if_is_none)]
    id: Option<IdSelectorDocumented>,
    /// ## Document Version
    ///
    /// Either an absolute single Document Version or a range of
    /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
    #[oai(skip_serializing_if_is_none)]
    ver: Option<VerSelectorDocumented>,
    /// ## Document Reference
    ///
    /// A [reference](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ref)
    /// to another signed document.  This fields can match any reference that matches the
    /// defined [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
    /// and/or
    /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
    ///
    /// The kind of document that the reference refers to is defined by the
    /// [Document Type](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/)
    #[oai(rename = "ref", skip_serializing_if_is_none)]
    doc_ref: Option<IdAndVerRefDocumented>,
    /// ## Document Template
    ///
    /// Documents that are created based on a template include the
    /// [template reference](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#template)
    /// to another signed document.  This fields can match any template reference that
    /// matches the defined [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
    /// and/or
    /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
    ///
    /// The kind of document that the reference refers to is defined by the
    /// [Document Type](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/)
    /// however, it will always be a template type document that matches the document
    /// itself.
    #[oai(skip_serializing_if_is_none)]
    template: Option<IdAndVerRefDocumented>,
    /// ## Document Reply
    ///
    /// This is a
    /// [reply reference](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#reply)
    /// which links one document to another, when acting as a reply to it.
    /// Replies typically reference the same kind of document.
    /// This fields can match any reply reference that matches the defined
    /// [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
    /// and/or
    /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
    ///
    /// The kind of document that the reference refers to is defined by the
    /// [Document Type](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/).
    #[oai(skip_serializing_if_is_none)]
    reply: Option<IdAndVerRefDocumented>,
    /// ## Document Parameters
    ///
    /// This is a
    /// [parameters reference](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#parameters).
    /// Reference to a configuration document.
    /// This fields can match any reference that matches the defined
    /// [Document IDs](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#id)
    /// and/or
    /// [Document Versions](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/metadata/#ver)
    ///
    /// Whether a Document Type has a brand, campaign, category etc. reference is defined
    /// by its [Document Type](https://docs.dev.projectcatalyst.io/libs/main/architecture/08_concepts/signed_doc/types/).
    #[oai(skip_serializing_if_is_none, rename = "doc_parameters")]
    // renaming to 'doc_parameters' because of the openapi linter, which cannot process
    // 'parameters' name for the property of the object
    parameters: Option<IdAndVerRefDocumented>,
}

impl Example for DocumentIndexQueryFilterV2 {
    fn example() -> Self {
        Self {
            doc_type: Some(Example::example()),
            id: Some(Example::example()),
            ver: Some(Example::example()),
            doc_ref: Some(Example::example()),
            template: Some(Example::example()),
            reply: Some(Example::example()),
            parameters: Some(Example::example()),
        }
    }
}

impl_array_types!(
    DocumentTypeList,
    DocumentType,
    Some(poem_openapi::registry::MetaSchema {
        example: Self::example().to_json(),
        max_items: Some(10),
        items: Some(Box::new(DocumentType::schema_ref())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

impl Example for DocumentTypeList {
    fn example() -> Self {
        Self(vec![DocumentType::example()])
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
/// Document Index Query Filter
///
/// A Query Filter which causes documents whose metadata matches the provided
/// fields to be returned in the index list response.
///
/// Fields which are not set, are not used to filter documents based on those metadata
/// fields. This is equivalent to returning documents where those metadata fields either
/// do not exist, or do exist, but have any value.
pub(crate) struct DocumentIndexQueryFilterBodyV2(pub(crate) DocumentIndexQueryFilterV2);

impl TryFrom<DocumentIndexQueryFilterV2> for DocsQueryFilter {
    type Error = anyhow::Error;

    fn try_from(value: DocumentIndexQueryFilterV2) -> Result<Self, Self::Error> {
        let mut db_filter = DocsQueryFilter::all();
        if let Some(doc_type) = value.doc_type {
            db_filter = db_filter.with_type(
                doc_type
                    .0
                    .into_iter()
                    .map(|doc_type| doc_type.parse())
                    .collect::<Result<Vec<_>, _>>()?,
            );
        }
        if let Some(id) = value.id
            && let Some(id) = id.try_into()?
        {
            db_filter = db_filter.with_id(id);
        }
        if let Some(version) = value.ver
            && let Some(version) = version.try_into()?
        {
            db_filter = db_filter.with_ver(version);
        }
        if let Some(doc_ref) = value.doc_ref {
            db_filter = db_filter.with_ref(doc_ref.try_into()?);
        }
        if let Some(template) = value.template {
            db_filter = db_filter.with_template(template.try_into()?);
        }
        if let Some(reply) = value.reply {
            db_filter = db_filter.with_reply(reply.try_into()?);
        }
        if let Some(parameters) = value.parameters {
            db_filter = db_filter.with_parameters(parameters.try_into()?);
        }

        Ok(db_filter)
    }
}

impl Example for DocumentIndexQueryFilterBodyV2 {
    fn example() -> Self {
        Self(DocumentIndexQueryFilterV2::example())
    }
}
