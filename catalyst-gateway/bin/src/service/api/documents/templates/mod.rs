//! Catalyst signed document templates.

mod proposal;

use std::sync::LazyLock;

use catalyst_signed_doc::{Builder, CatalystSignedDocument, Metadata};
use minicbor::{Encode, Encoder};
use proposal::PROPOSAL;

/// A list of templates.
pub(crate) static TEMPLATES: LazyLock<[CatalystSignedDocument; 1]> =
    LazyLock::new(|| [PROPOSAL.to_signed_doc()]);

#[derive(Clone)]
/// Signed document template.
pub(crate) struct SignedDocTemplate {
    /// ID.
    id: String,
    /// Version.
    ver: String,
    /// Document type.
    doc_type: String,
    /// Content bytes.
    content: Vec<u8>,
    /// Content type.
    content_type: String,
    /// Content encoding method.
    content_encoding: String,
}

impl SignedDocTemplate {
    /// Convert the template to a catalyst signed document.
    /// This function should not fail, because template details are hardcoded.
    #[allow(clippy::expect_used)]
    fn to_signed_doc(&self) -> CatalystSignedDocument {
        let metadata: Metadata = serde_json::from_value(serde_json::json!({
            "content-type": self.content_type,
            "content-encoding": self.content_encoding,
            "type": self.doc_type,
            "id": self.id,
            "ver": self.ver,
        }))
        // This should not happen
        .expect("Failed to build Metadata from template");

        Builder::new()
            .with_metadata(metadata.clone())
            .with_content(self.content.clone())
            .build()
            // This should not happen
            .expect("Failed to build CatalystSignedDocument from template")
    }
}

/// Get a static document template from ID and version.
pub(crate) fn get_doc_static_template(
    document_id: uuid::Uuid, version: Option<uuid::Uuid>,
) -> Option<Vec<u8>> {
    for template in TEMPLATES.iter() {
        // Check if the document ID matches
        if template.doc_id().uuid() == document_id {
            // If version is None, or version match, proceed with encoding
            if version.is_none() || version == Some(template.doc_ver().uuid()) {
                let mut buffer = Vec::new();
                let mut encoder = Encoder::new(&mut buffer);
                // Cannot encode the template, return None
                // Should not happen
                template.encode(&mut encoder, &mut ()).ok()?;
                return Some(buffer);
            }
        }
    }
    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn templates() {
        for tem in TEMPLATES.iter() {
            assert!(tem.doc_ver().is_valid());
            assert!(tem.doc_content().is_json());
        }
    }
}
