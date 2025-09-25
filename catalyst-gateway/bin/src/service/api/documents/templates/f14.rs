//! F14 Document templates hardcoded data.

use super::SignedDocData;

/// Fund 14 Campaign ID.
const CAMPAIGN_ID: &str = "0194cfcf-15a2-7e32-b559-386b93d0724e";

/// An empty JSON object bytes slice
const EMPTY_JSON_OBJECT_BYTES: &[u8] = b"{}";
/// A definition of Category document hardcoded data
pub(crate) struct CategoryDocData(
    /// ID and Version
    &'static str,
    /// Campaign ID
    &'static str,
);
/// List of category documents, categories.
#[rustfmt::skip]
pub(crate) const CATEGORY_DOCUMENTS: [CategoryDocData; 4] = [
    CategoryDocData("0194d490-30bf-7473-81c8-a0eaef369619", CAMPAIGN_ID),
    CategoryDocData("0194d490-30bf-7043-8c5c-f0e09f8a6d8c", CAMPAIGN_ID),
    CategoryDocData("0194d490-30bf-7e75-95c1-a6cf0e8086d9", CAMPAIGN_ID),
    CategoryDocData("0194d490-30bf-7703-a1c0-83a916b001e7", CAMPAIGN_ID),
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
    ProposalTemplateDocData("0194d492-1daa-75b5-b4a4-5cf331cd8d1a", CATEGORY_DOCUMENTS[0].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0194d492-1daa-75b5-b4a4-5cf331cd8d1a.schema.json")),
    ProposalTemplateDocData("0194d492-1daa-7371-8bd3-c15811b2b063", CATEGORY_DOCUMENTS[1].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0194d492-1daa-7371-8bd3-c15811b2b063.schema.json")),
    ProposalTemplateDocData("0194d492-1daa-79c7-a222-2c3b581443a8", CATEGORY_DOCUMENTS[2].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0194d492-1daa-79c7-a222-2c3b581443a8.schema.json")),
    ProposalTemplateDocData("0194d492-1daa-716f-a04e-f422f08a99dc", CATEGORY_DOCUMENTS[3].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0194d492-1daa-716f-a04e-f422f08a99dc.schema.json")),
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
    CommentTemplateDocData("0194d494-4402-7e0e-b8d6-171f8fea18b0", CATEGORY_DOCUMENTS[0].0),
    CommentTemplateDocData("0194d494-4402-7444-9058-9030815eb029", CATEGORY_DOCUMENTS[1].0),
    CommentTemplateDocData("0194d494-4402-7351-b4f7-24938dc2c12e", CATEGORY_DOCUMENTS[2].0),
    CommentTemplateDocData("0194d494-4402-79ad-93ba-4d7a0b65d563", CATEGORY_DOCUMENTS[3].0),
];

impl From<CommentTemplateDocData> for SignedDocData {
    fn from(value: CommentTemplateDocData) -> Self {
        Self {
            id: value.0,
            ver: value.0,
            doc_type: catalyst_signed_doc::doc_types::COMMENT_TEMPLATE_UUID_TYPE,
            content: include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/F14-Comments/0b8424d4-ebfd-46e3-9577-1775a69d290c.schema.json"),
            category_id: Some(value.1),
        }
    }
}
