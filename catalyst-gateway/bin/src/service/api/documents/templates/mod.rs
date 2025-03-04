//! Catalyst signed document templates.

mod data;

use std::{collections::HashMap, env, sync::LazyLock};

use catalyst_signed_doc::{Builder, CatalystSignedDocument, ContentEncoding, ContentType, IdUri};
use data::{CATEGORY_DOCUMENTS, COMMENT_TEMPLATES, PROPOSAL_TEMPLATES};
use ed25519_dalek::SigningKey;
use hex::FromHex;
use uuid::Uuid;

/// Catalyst brand ID.
const BRAND_ID: &str = "0194cfcd-bddc-7bb3-b5e9-455168bd3ff7";

/// Fund 14 Campaign ID.
const CAMPAIGN_ID: &str = "0194cfcf-15a2-7e32-b559-386b93d0724e";

/// A map of signed document templates to its ID.
pub(crate) static TEMPLATES: LazyLock<Option<HashMap<Uuid, CatalystSignedDocument>>> =
    LazyLock::new(|| {
        let sk = load_doc_signing_key()?;

        let mut map = HashMap::new();
        map.extend(
            CATEGORY_DOCUMENTS
                .into_iter()
                .map(|t| build_signed_doc(&t.into(), &sk)),
        );
        map.extend(
            PROPOSAL_TEMPLATES
                .into_iter()
                .map(|t| build_signed_doc(&t.into(), &sk)),
        );
        map.extend(
            COMMENT_TEMPLATES
                .into_iter()
                .map(|t| build_signed_doc(&t.into(), &sk)),
        );
        Some(map)
    });

/// Loads a Signing Key which is used to sign hardcoded Catalyst Signed Document objects
fn load_doc_signing_key() -> Option<SigningKey> {
    // Load the secret key from the environment
    // Expect hex encoded secret key that start with 0x
    // If no secret key is found, cannot generate sign documents
    let Ok(signed_doc_sk_hex) = env::var("SIGNED_DOC_SK") else {
        tracing::error!(
            id = "static_template_env",
            "Secret key not found in environment"
        );
        return None;
    };
    // Strip the prefix and convert to 32 bytes array
    let Some(byte_array) = signed_doc_sk_hex
        .strip_prefix("0x")
        .and_then(|s| Vec::from_hex(s).ok())
        .and_then(|bytes| bytes.as_slice().try_into().ok())
    else {
        tracing::error!(
            id = "static_template",
            "Failed to convert secret key to bytes"
        );
        return None;
    };

    let sk = SigningKey::from_bytes(&byte_array);
    Some(sk)
}

#[derive(Clone)]
/// Signed document hardcoded data structure.
pub(crate) struct SignedDocData {
    /// ID.
    id: &'static str,
    /// Version.
    ver: &'static str,
    /// Document type.
    doc_type: Uuid,
    /// Content bytes.
    content: &'static [u8],
    /// Category ID.
    category_id: Option<&'static str>,
}

/// Build a `CatalystSignedDocument` from the hardcoded `SignedDocData`, return a document
/// with its id.
/// This function should not fail, because template details are hardcoded.
#[allow(clippy::expect_used)]
fn build_signed_doc(data: &SignedDocData, sk: &SigningKey) -> (Uuid, CatalystSignedDocument) {
    /// ID URI network.
    const KID_NETWORK: &str = "cardano";

    let metadata = serde_json::json!({
        "alg": catalyst_signed_doc::Algorithm::EdDSA.to_string(),
        "type": data.doc_type,
        "id": data.id,
        "ver": data.ver,
        "category_id": data.category_id.map(|v| serde_json::json!({"id": v})),
        "content-type": ContentType::Json.to_string(),
        "content-encoding": ContentEncoding::Brotli.to_string(),
        "campaign_id": {"id": CAMPAIGN_ID},
        "brand_id":  {"id": BRAND_ID},
    });

    let kid = IdUri::new(KID_NETWORK, None, sk.verifying_key());
    let doc = Builder::new()
        .with_json_metadata(metadata.clone())
        .expect("Failed to build Metadata from template")
        .with_decoded_content(data.content.to_vec())
        .add_signature(sk.to_bytes(), kid)
        .expect("Failed to add signature for template")
        .build();
    let doc_id = doc
        .doc_id()
        .expect("Template document must have id field")
        .uuid();
    (doc_id, doc)
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
