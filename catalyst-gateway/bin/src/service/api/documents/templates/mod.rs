//! Catalyst signed document templates.

mod data;

use std::{collections::HashMap, env, sync::LazyLock};

use catalyst_signed_doc::{Builder, CatalystSignedDocument, Metadata};
use catalyst_types::id_uri::IdUri;
use data::TEMPLATE_DATA;
use ed25519_dalek::SigningKey;
use hex::FromHex;
use minicbor::{Encode, Encoder};
use tracing::error;
use uuid::Uuid;

/// Catalyst brand ID.
const BRAND_ID: &str = "0194cfcd-bddc-7bb3-b5e9-455168bd3ff7";

/// Fund 14 Campaign ID.
const CAMPAIGN_ID: &str = "0194cfcf-15a2-7e32-b559-386b93d0724e";

/// Content type.
const CONTENT_TYPE: &str = "application/json";

/// Content encoding.
const CONTENT_ENCODING: &str = "br";

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

            let mut map = HashMap::new();
            for t in TEMPLATE_DATA.iter() {
                let signed_doc = t.to_signed_doc(&sk);
                map.insert(signed_doc.doc_id().uuid(), signed_doc);
            }
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
    doc_type: String,
    /// Content bytes.
    content: Vec<u8>,
    /// Category ID.
    category_id: String,
}

impl SignedDocTemplate {
    /// Convert the template to a catalyst signed document.
    /// This function should not fail, because template details are hardcoded.
    #[allow(clippy::expect_used)]
    fn to_signed_doc(&self, sk: &SigningKey) -> CatalystSignedDocument {
        let metadata: Metadata = serde_json::from_value(serde_json::json!({
            "type": self.doc_type,
            "id": self.id,
            "ver": self.ver,
            "category_id": {"id": self.category_id},
            "content-type": CONTENT_TYPE,
            "content-encoding": CONTENT_ENCODING,
            "campaign_id": {"id": CAMPAIGN_ID},
            "brand_id":  {"id": BRAND_ID},
        }))
        .expect("Failed to build Metadata from template");

        let kid = IdUri::new("cardano", None, sk.verifying_key());
        Builder::new()
            .with_metadata(metadata.clone())
            .with_decoded_content(self.content.clone())
            .add_signature(sk.to_bytes(), kid)
            .expect("Failed to add signature for template")
            .build()
            .expect("Failed to build CatalystSignedDocument from template")
    }
}

/// Get a static document template from ID and version.
pub(crate) fn get_doc_static_template(document_id: uuid::Uuid) -> Option<Vec<u8>> {
    let data = TEMPLATES
        .as_ref()
        .and_then(|templates| templates.get(&document_id));

    if let Some(template) = data {
        let mut buffer = Vec::new();
        let mut encoder = Encoder::new(&mut buffer);
        // Cannot encode the template, return None
        // Should not happen
        template.encode(&mut encoder, &mut ()).ok()?;
        return Some(buffer);
    }
    None
}
