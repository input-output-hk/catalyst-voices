//! F15 Document templates hardcoded data.

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
/// List of category documents.
#[rustfmt::skip]
pub(crate) const CATEGORY_DOCUMENTS: [CategoryDocData; 4] = [
    CategoryDocData("01997fce-fde3-7fd7-8a62-b3a6d5fc20d3", CAMPAIGN_ID),
    CategoryDocData("01997fcf-1dd0-707d-8439-c2e6e1d80524", CAMPAIGN_ID),
    CategoryDocData("01997fcf-369a-7b07-9367-a1eac707b35b", CAMPAIGN_ID),
    CategoryDocData("01997fcf-72e1-7ff2-8a39-8ad907bcc61a", CAMPAIGN_ID),
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
    ProposalTemplateDocData("01997fcf-a7b5-7c48-9438-b2c8049063c3", CATEGORY_DOCUMENTS[0].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0194d492-1daa-75b5-b4a4-5cf331cd8d1a.schema.json")),
    ProposalTemplateDocData("01997fcf-c941-780f-b3f2-8c4d0020b363", CATEGORY_DOCUMENTS[1].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0194d492-1daa-7371-8bd3-c15811b2b063.schema.json")),
    ProposalTemplateDocData("01997fcf-e9ca-75bd-9141-013e644527df", CATEGORY_DOCUMENTS[2].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0194d492-1daa-79c7-a222-2c3b581443a8.schema.json")),
    ProposalTemplateDocData("01997fd0-4723-7d8e-9a17-3449c0f81a7a", CATEGORY_DOCUMENTS[3].0, include_bytes!("../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0194d492-1daa-716f-a04e-f422f08a99dc.schema.json")),
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
    CommentTemplateDocData("01997fd0-8006-73ac-a480-08c3b6f50f21", CATEGORY_DOCUMENTS[0].0),
    CommentTemplateDocData("01997fd0-8006-7d55-b560-8497176fb66e", CATEGORY_DOCUMENTS[1].0),
    CommentTemplateDocData("01997fd0-8006-78cf-9fb0-9893130d0aa8", CATEGORY_DOCUMENTS[2].0),
    CommentTemplateDocData("01997fd0-8006-718c-83f4-a671e035ae9d", CATEGORY_DOCUMENTS[3].0),
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
