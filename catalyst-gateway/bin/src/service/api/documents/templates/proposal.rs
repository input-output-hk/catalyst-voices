//! Proposal document template.
//! <https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/catalyst_docs/proposal/#proposal-template>

use std::sync::LazyLock;

use super::SignedDocTemplate;

/// Proposal document template type as UUID V4.
const DOC_TYPE: &str = "0ce8ab38-9258-4fbc-a62e-7faa6e58318f";

/// Proposal document template.
pub(crate) static PROPOSAL: LazyLock<SignedDocTemplate> = LazyLock::new(|| {
    SignedDocTemplate {
        id: "0194b595-da01-73e8-91be-d22687faf577".to_owned(),
        ver: "0194b595-da01-73e8-91be-d22687faf577".to_owned(),
        doc_type: DOC_TYPE.to_owned(),
        content: include_bytes!(
            "../../../../../../../docs/src/architecture/08_concepts/document_templates/proposal/F14-Generic/0ce8ab38-9258-4fbc-a62e-7faa6e58318f.schema.json"
        ).to_vec(),
        content_type: "application/json".to_owned(),
        content_encoding: "br".to_owned(),
    }
});
