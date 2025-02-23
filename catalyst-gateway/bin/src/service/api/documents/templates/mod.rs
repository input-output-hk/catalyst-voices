//! Catalyst signed document templates.

mod data;

use std::{collections::HashMap, env, sync::LazyLock};

use catalyst_signed_doc::{Builder, CatalystSignedDocument, ContentEncoding, ContentType, IdUri};
use data::TEMPLATE_DATA;
use ed25519_dalek::SigningKey;
use hex::FromHex;
use tracing::error;
use uuid::Uuid;

/// Catalyst brand ID.
const BRAND_ID: &str = "0194cfcd-bddc-7bb3-b5e9-455168bd3ff7";

/// Fund 14 Campaign ID.
const CAMPAIGN_ID: &str = "0194cfcf-15a2-7e32-b559-386b93d0724e";

/// A map of signed document templates to its ID.
pub(crate) static TEMPLATES: LazyLock<Option<HashMap<Uuid, CatalystSignedDocument>>> =
    LazyLock::new(|| {
        // Load the secret key from the environment
        // Expect hex encoded secret key that start with 0x
        let value = env::var("SIGNED_DOC_SK");

        // If no secret key is found, cannot generate sign documents
        if let Ok(v) = value {
            // Strip the prefix and convert to 32 bytes array
            let byte_array: [u8; 32] = if let Some(bytes) = v
                .strip_prefix("0x")
                .and_then(|s| Vec::from_hex(s).ok())
                .and_then(|bytes| bytes.as_slice().try_into().ok())
            {
                bytes
            } else {
                error!(
                    id = "static_template",
                    "Failed to convert secret key to bytes"
                );
                return None;
            };
            let sk = SigningKey::from_bytes(&byte_array);

            let map = TEMPLATE_DATA.iter().map(|t| t.to_signed_doc(&sk)).collect();
            Some(map)
        } else {
            error!(
                id = "static_template_env",
                "Secret key not found in environment"
            );
            None
        }
    });

#[derive(Clone)]
/// Signed document template.
pub(crate) struct SignedDocTemplate {
    /// ID.
    id: String,
    /// Version.
    ver: String,
    /// Document type.
    doc_type: Uuid,
    /// Content bytes.
    content: Vec<u8>,
    /// Category ID.
    category_id: String,
}

impl SignedDocTemplate {
    /// Convert the template to a catalyst signed document with its id.
    /// This function should not fail, because template details are hardcoded.
    #[allow(clippy::expect_used)]
    fn to_signed_doc(&self, sk: &SigningKey) -> (Uuid, CatalystSignedDocument) {
        /// ID URI network.
        const KID_NETWORK: &str = "cardano";

        let metadata = serde_json::json!({
            "type": self.doc_type,
            "id": self.id,
            "ver": self.ver,
            "category_id": {"id": self.category_id},
            "content-type": ContentType::Json.to_string(),
            "content-encoding": ContentEncoding::Brotli.to_string(),
            "campaign_id": {"id": CAMPAIGN_ID},
            "brand_id":  {"id": BRAND_ID},
        });

        let kid = IdUri::new(KID_NETWORK, None, sk.verifying_key());
        let doc = Builder::new()
            .with_json_metadata(metadata.clone())
            .expect("Failed to build Metadata from template")
            .with_decoded_content(self.content.clone())
            .add_signature(sk.to_bytes(), kid)
            .expect("Failed to add signature for template")
            .build();
        let doc_id = doc
            .doc_id()
            .expect("Template document must have id field")
            .uuid();
        (doc_id, doc)
    }
}

/// Get a static document template from ID and version.
pub(crate) fn get_doc_static_template(document_id: &uuid::Uuid) -> Option<CatalystSignedDocument> {
    TEMPLATES
        .as_ref()
        .and_then(|templates| templates.get(document_id))
        .cloned()
}

#[cfg(test)]
mod tests {
    use std::env;

    use rand::rngs::OsRng;

    use super::*;

    #[test]
    fn templates() {
        let mut rand = OsRng;
        let sk_bytes: SigningKey = SigningKey::generate(&mut rand);
        let sk_hex = format!("0x{}", hex::encode(sk_bytes.to_bytes()).as_str());
        unsafe {
            env::set_var("SIGNED_DOC_SK", sk_hex);
        }
        for doc in TEMPLATES.as_ref().unwrap().values() {
            assert!(!doc.problem_report().is_problematic());
        }
    }
}
