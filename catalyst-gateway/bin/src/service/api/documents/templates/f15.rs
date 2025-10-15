//! F15 Document templates hardcoded data.

use super::SignedDocData;

/// Fund 15 Campaign ID.
const CAMPAIGN_ID: &str = "0199802c-21b4-7d91-986d-0e913cd81391";

/// An empty JSON object bytes slice
const EMPTY_JSON_OBJECT_BYTES: &[u8] = b"{}";
/// A definition of Category document hardcoded data
pub(crate) struct CategoryDocData(
    /// ID and Version
    &'static str,
    /// Campaign ID
    &'static str,
);
/// List of category documents.
#[rustfmt::skip]
pub(crate) const CATEGORY_DOCUMENTS: [CategoryDocData; 4] = [
    CategoryDocData("0199802c-21b4-721f-aa1d-5123b006879e", CAMPAIGN_ID),
    CategoryDocData("0199802c-21b4-7dc8-8537-7eae5ea4c4d3", CAMPAIGN_ID),
    CategoryDocData("0199802c-21b4-7c84-873c-f55119cdc811", CAMPAIGN_ID),
    CategoryDocData("0199802c-21b4-7161-a16e-a77af492780f", CAMPAIGN_ID),
];

impl From<CategoryDocData> for SignedDocData {
    fn from(value: CategoryDocData) -> Self {
        Self {
            id: value.0,
            ver: value.0,
            doc_type: catalyst_signed_doc::doc_types::CATEGORY_DOCUMENT_UUID_TYPE,
            content: EMPTY_JSON_OBJECT_BYTES,
            category_id: Some(value.1),
        }
    }
}

/// A definition of Proposal Template document hardcoded data
pub(crate) struct ProposalTemplateDocData(
    /// ID and Version
    &'static str,
    /// Category ID
    &'static str,
    /// Content bytes
    &'static [u8],
);

/// List of proposal templates, proposals each of which is uniquely associated with one of the predefined categories.
#[rustfmt::skip]
pub(crate) const PROPOSAL_TEMPLATES: [ProposalTemplateDocData; 4] = [
    ProposalTemplateDocData("0199802c-21b4-717d-9619-11357877f471", CATEGORY_DOCUMENTS[0].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/f15/0199802c-21b4-717d-9619-11357877f471.schema.json")),
    ProposalTemplateDocData("0199802c-21b4-7982-ba3f-ec0cd0207b11", CATEGORY_DOCUMENTS[1].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/f15/0199802c-21b4-7982-ba3f-ec0cd0207b11.schema.json")),
    ProposalTemplateDocData("0199802c-21b4-7f75-b14a-331cd1605f74", CATEGORY_DOCUMENTS[2].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/f15/0199802c-21b4-7f75-b14a-331cd1605f74.schema.json")),
    ProposalTemplateDocData("0199802c-21b4-7d6c-aacd-54aa31fe1e4c", CATEGORY_DOCUMENTS[3].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/f15/0199802c-21b4-7d6c-aacd-54aa31fe1e4c.schema.json")),
];

impl From<ProposalTemplateDocData> for SignedDocData {
    fn from(value: ProposalTemplateDocData) -> Self {
        Self {
            id: value.0,
            ver: value.0,
            doc_type: catalyst_signed_doc::doc_types::PROPOSAL_TEMPLATE_UUID_TYPE,
            content: value.2,
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
/// List of comment templates, comments each of which is uniquely associated with one of the predefined categories.
#[rustfmt::skip]
pub(crate) const COMMENT_TEMPLATES: [CommentTemplateDocData; 4] = [
    CommentTemplateDocData("0199802c-21b4-7b2c-aafd-0af557e8408c", CATEGORY_DOCUMENTS[0].0),
    CommentTemplateDocData("0199802c-21b4-78d8-a1df-2e4bd2e73507", CATEGORY_DOCUMENTS[1].0),
    CommentTemplateDocData("0199802c-21b4-76da-9384-4dc1e2dc3d51", CATEGORY_DOCUMENTS[2].0),
    CommentTemplateDocData("0199802c-21b4-7884-84cb-0bdf6c08e690", CATEGORY_DOCUMENTS[3].0),
];

impl From<CommentTemplateDocData> for SignedDocData {
    fn from(value: CommentTemplateDocData) -> Self {
        Self {
            id: value.0,
            ver: value.0,
            doc_type: catalyst_signed_doc::doc_types::COMMENT_TEMPLATE_UUID_TYPE,
            content: include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/comments/f15/53224f27-5ad0-4a0b-a0af-7e04e4c14622.schema.json"),
            category_id: Some(value.1),
        }
    }
}
