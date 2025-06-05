//! Document templates hardcoded data.

use super::SignedDocData;

/// An empty JSON object bytes slice
const EMPTY_JSON_OBJECT_BYTES: &[u8] = b"{}";
/// A definition of Category document hardcoded data
pub(crate) struct CategoryDocData(
    /// ID and Version
    &'static str,
    /// Content bytes
    &'static [u8],
);
/// List of category documents, 12 categories for Fund 14.
// TODO: Fix Content once it is added
#[rustfmt::skip]
pub(crate) const CATEGORY_DOCUMENTS: [CategoryDocData; 12] = [
    CategoryDocData("0194d490-30bf-7473-81c8-a0eaef369619", include_bytes!("./docs/category/f14_partner_product.schema.json")),
    CategoryDocData("0194d490-30bf-7043-8c5c-f0e09f8a6d8c", include_bytes!("./docs/category/f14_concepts.schema.json")),
    CategoryDocData("0194d490-30bf-7e75-95c1-a6cf0e8086d9", include_bytes!("./docs/category/f14_developers.schema.json")),
    CategoryDocData("0194d490-30bf-7703-a1c0-83a916b001e7", include_bytes!("./docs/category/f14_ecosystem.schema.json")),
    CategoryDocData("0194d490-30bf-79d1-9a0f-84943123ef38", EMPTY_JSON_OBJECT_BYTES),
    CategoryDocData("0194d490-30bf-706d-91c6-0d4707f74cdf", EMPTY_JSON_OBJECT_BYTES),
    CategoryDocData("0194d490-30bf-759e-b729-304306fbaa5e", EMPTY_JSON_OBJECT_BYTES),
    CategoryDocData("0194d490-30bf-7e27-b5fd-de3133b54bf6", EMPTY_JSON_OBJECT_BYTES),
    CategoryDocData("0194d490-30bf-7f9e-8a5d-91fb67c078f2", EMPTY_JSON_OBJECT_BYTES),
    CategoryDocData("0194d490-30bf-7676-9658-36c0b67e656e", EMPTY_JSON_OBJECT_BYTES),
    CategoryDocData("0194d490-30bf-7978-b031-7aa2ccc5e3fd", EMPTY_JSON_OBJECT_BYTES),
    CategoryDocData("0194d490-30bf-7d34-bba9-8498094bd627", EMPTY_JSON_OBJECT_BYTES),
];

impl From<CategoryDocData> for SignedDocData {
    fn from(value: CategoryDocData) -> Self {
        Self {
            id: value.0,
            ver: value.0,
            doc_type: catalyst_signed_doc::doc_types::CATEGORY_DOCUMENT_UUID_TYPE,
            content: value.1,
            category_id: None,
        }
    }
}

/// A definition of Proposal Template document hardcoded data
pub(crate) struct ProposalTemplateDocData(
    /// ID and Version
    &'static str,
    /// Category ID
    &'static str,
);
/// List of proposal templates, 12 proposals each of which is uniquely associated with one of the predefined categories.
#[rustfmt::skip]
pub(crate) const PROPOSAL_TEMPLATES: [ProposalTemplateDocData; 12] = [
    ProposalTemplateDocData("0194d492-1daa-75b5-b4a4-5cf331cd8d1a", CATEGORY_DOCUMENTS[0].0),
    ProposalTemplateDocData("0194d492-1daa-7371-8bd3-c15811b2b063", CATEGORY_DOCUMENTS[1].0),
    ProposalTemplateDocData("0194d492-1daa-79c7-a222-2c3b581443a8", CATEGORY_DOCUMENTS[2].0),
    ProposalTemplateDocData("0194d492-1daa-716f-a04e-f422f08a99dc", CATEGORY_DOCUMENTS[3].0),
    ProposalTemplateDocData("0194d492-1daa-78fc-818a-bf20fc3e9b87", CATEGORY_DOCUMENTS[4].0),
    ProposalTemplateDocData("0194d492-1daa-7d98-a3aa-c57d99121f78", CATEGORY_DOCUMENTS[5].0),
    ProposalTemplateDocData("0194d492-1daa-77be-a1a5-c238fe25fe4f", CATEGORY_DOCUMENTS[6].0),
    ProposalTemplateDocData("0194d492-1daa-7254-a512-30a4cdecfb90", CATEGORY_DOCUMENTS[7].0),
    ProposalTemplateDocData("0194d492-1daa-7de9-b535-1a0b0474ed4e", CATEGORY_DOCUMENTS[8].0),
    ProposalTemplateDocData("0194d492-1daa-7fce-84ee-b872a4661075", CATEGORY_DOCUMENTS[9].0),
    ProposalTemplateDocData("0194d492-1daa-7878-9bcc-2c79fef0fc13", CATEGORY_DOCUMENTS[10].0),
    ProposalTemplateDocData("0194d492-1daa-722f-94f4-687f2c068a5d", CATEGORY_DOCUMENTS[11].0),
];

impl From<ProposalTemplateDocData> for SignedDocData {
    fn from(value: ProposalTemplateDocData) -> Self {
        Self {
            id: value.0,
            ver: value.0,
            doc_type: catalyst_signed_doc::doc_types::PROPOSAL_TEMPLATE_UUID_TYPE,
            content: include_bytes!("./docs/f14_proposal_template.schema.json"),
            category_id: Some(value.1),
        }
    }
}

/// A definition of Comment Template document hardcoded data
pub(crate) struct CommentTemplateDocData(
    /// ID and Version
    &'static str,
    /// Category ID
    &'static str,
);
/// List of comment templates, 12 comments each of which is uniquely associated with one of the predefined categories.
#[rustfmt::skip]
pub(crate) const COMMENT_TEMPLATES: [CommentTemplateDocData; 12] = [
    CommentTemplateDocData("0194d494-4402-7e0e-b8d6-171f8fea18b0", CATEGORY_DOCUMENTS[0].0),
    CommentTemplateDocData("0194d494-4402-7444-9058-9030815eb029", CATEGORY_DOCUMENTS[1].0),
    CommentTemplateDocData("0194d494-4402-7351-b4f7-24938dc2c12e", CATEGORY_DOCUMENTS[2].0),
    CommentTemplateDocData("0194d494-4402-79ad-93ba-4d7a0b65d563", CATEGORY_DOCUMENTS[3].0),
    CommentTemplateDocData("0194d494-4402-7cee-a5a6-5739839b3b8a", CATEGORY_DOCUMENTS[4].0),
    CommentTemplateDocData("0194d494-4402-7aee-8b24-b5300c976846", CATEGORY_DOCUMENTS[5].0),
    CommentTemplateDocData("0194d494-4402-7d75-be7f-1c4f3471a53c", CATEGORY_DOCUMENTS[6].0),
    CommentTemplateDocData("0194d494-4402-7a2c-8971-1b4c255c826d", CATEGORY_DOCUMENTS[7].0),
    CommentTemplateDocData("0194d494-4402-7074-86ac-3efd097ba9b0", CATEGORY_DOCUMENTS[8].0),
    CommentTemplateDocData("0194d494-4402-7202-8ebb-8c4c47c286d8", CATEGORY_DOCUMENTS[9].0),
    CommentTemplateDocData("0194d494-4402-7fb5-b680-c23fe4beb088", CATEGORY_DOCUMENTS[10].0),
    CommentTemplateDocData("0194d494-4402-7aa5-9dbc-5fe886e60ebc", CATEGORY_DOCUMENTS[11].0),
];

impl From<CommentTemplateDocData> for SignedDocData {
    fn from(value: CommentTemplateDocData) -> Self {
        Self {
            id: value.0,
            ver: value.0,
            doc_type: catalyst_signed_doc::doc_types::COMMENT_TEMPLATE_UUID_TYPE,
            content: include_bytes!("./docs/f14_comment_template.schema.json"),
            category_id: Some(value.1),
        }
    }
}
