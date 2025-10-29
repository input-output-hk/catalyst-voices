//! Catalyst signed document templates.

mod f14;
mod f15;

use std::{collections::HashMap, env, sync::LazyLock};

use catalyst_signed_doc::{
    Builder, CatalystId, CatalystSignedDocument, ContentEncoding, ContentType,
};
use ed25519_dalek::{ed25519::signature::Signer, SigningKey};
use hex::FromHex;
use uuid::Uuid;

/// A map of F14 signed document templates to its ID.
static F14_TEMPLATES: LazyLock<Option<HashMap<Uuid, CatalystSignedDocument>>> =
    LazyLock::new(|| {
        let sk = load_doc_signing_key()?;

        let mut map = HashMap::new();
        map.extend(
            f14::CATEGORY_DOCUMENTS
                .into_iter()
                .map(|t| build_signed_doc(&t.into(), &sk)),
        );
        map.extend(
            f14::PROPOSAL_TEMPLATES
                .into_iter()
                .map(|t| build_signed_doc(&t.into(), &sk)),
        );
        map.extend(
            f14::COMMENT_TEMPLATES
                .into_iter()
                .map(|t| build_signed_doc(&t.into(), &sk)),
        );
        Some(map)
    });

/// A map of F15 signed document templates to its ID.
static F15_TEMPLATES: LazyLock<Option<HashMap<Uuid, CatalystSignedDocument>>> =
    LazyLock::new(|| {
        let sk = load_doc_signing_key()?;

        let mut map = HashMap::new();
        map.extend(
            f15::CATEGORY_DOCUMENTS
                .into_iter()
                .map(|t| build_signed_doc(&t.into(), &sk)),
        );
        map.extend(
            f15::PROPOSAL_TEMPLATES
                .into_iter()
                .map(|t| build_signed_doc(&t.into(), &sk)),
        );
        map.extend(
            f15::COMMENT_TEMPLATES
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
fn build_signed_doc(
    data: &SignedDocData,
    sk: &SigningKey,
) -> (Uuid, CatalystSignedDocument) {
    /// ID URI network.
    const KID_NETWORK: &str = "cardano";

    let metadata = serde_json::json!({
        "type": data.doc_type,
        "id": data.id,
        "ver": data.ver,
        "parameters": data.category_id.map(|v| serde_json::json!({"id": v, "ver": v })),
        "content-type": ContentType::Json.to_string(),
        "content-encoding": ContentEncoding::Brotli.to_string(),
    });

    let kid = CatalystId::new(KID_NETWORK, None, sk.verifying_key());
    let doc = Builder::new()
        .with_json_metadata(metadata.clone())
        .expect("Failed to build Metadata from template")
        .with_decoded_content(data.content.to_vec())
        .add_signature(|m| sk.sign(&m).to_vec(), &kid)
        .expect("Failed to add signature for template")
        .build();
    let doc_id = doc
        .doc_id()
        .expect("Template document must have id field")
        .uuid();
    (doc_id, doc)
}

/// Get a static document template from ID and version looking from all available static
/// templates.
pub(crate) fn get_doc_static_template(document_id: &uuid::Uuid) -> Option<CatalystSignedDocument> {
    F15_TEMPLATES
        .as_ref()
        .and_then(|templates| templates.get(document_id))
        .or_else(|| {
            F14_TEMPLATES
                .as_ref()
                .and_then(|templates| templates.get(document_id))
        })
        .cloned()
}

/// Get an active static document template from ID and version.
pub(crate) fn get_active_doc_static_template(
    document_id: &uuid::Uuid
) -> Option<CatalystSignedDocument> {
    F15_TEMPLATES
        .as_ref()
        .and_then(|templates| templates.get(document_id))
        .cloned()
}

#[cfg(test)]
mod tests {
    use std::env;

    use rand::rngs::OsRng;

    use super::*;

    /// A convenient function to prepare an SQL queries to insert a hardcoded data into
    /// the `event-db`.
    #[allow(clippy::indexing_slicing)]
    fn process_docs<'a, I: Iterator<Item = &'a CatalystSignedDocument>>(
        w: &mut impl std::io::Write,
        mut docs_iter: std::iter::Peekable<I>,
    ) -> anyhow::Result<()> {
        const INSERT_STMT: &str = "INSERT INTO signed_docs (\n  id,\n  ver,\n  type,\n  authors,\n  metadata,\n  payload,\n  raw\n)\nVALUES\n-- cspell: disable";
        writeln!(w, "{INSERT_STMT}").unwrap();

        while let Some(doc) = docs_iter.next() {
            let mut metadata = serde_json::json!({
                "id": doc.doc_id()?,
                "ver": doc.doc_ver()?,
                "type": doc.doc_type()?,
                "content-type": doc.doc_content_type()?.to_string(),
                "content-encoding": doc.doc_content_encoding().ok_or(anyhow::anyhow!("missing content-encoding field"))?.to_string(),
            });
            if let Some(parameters) = doc.doc_meta().parameters() {
                metadata["parameters"] = serde_json::json!([
                    {
                        "id": parameters.id,
                        "ver": parameters.ver,
                        "cid": "0x",
                    }
                ]);
            }

            write!(
                w,
                "(\n  '{id}',\n  '{ver}',\n  '{type}',\n  ARRAY[{authors}], -- noqa: LT05\n  '{metadata}', -- noqa: LT05\n  '{payload}', -- noqa: LT05\n  DECODE('{raw}', 'hex') -- noqa: LT05\n)",
                id = doc.doc_id()?,
                ver = doc.doc_ver()?,
                r#type = doc.doc_type()?,
                authors = doc
                    .authors()
                    .iter()
                    .map(|v| format!("'{v}'"))
                    .collect::<Vec<_>>()
                    .join(","),
                payload = serde_json::from_slice::<serde_json::Value>(doc.doc_content().decoded_bytes()?)?.to_string().replace('\'', "''"),
                raw = hex::encode(minicbor::to_vec(doc)?)
            )?;
            if docs_iter.peek().is_some() {
                // If so, we are NOT at the last item, so write ","
                writeln!(w, ",")?;
            }
        }
        write!(w, ";\n-- cspell: enable")?;
        Ok(())
    }

    #[test]
    fn templates() {
        let mut rand = OsRng;
        let sk_bytes: SigningKey = SigningKey::generate(&mut rand);
        let sk_hex = format!("0x{}", hex::encode(sk_bytes.to_bytes()).as_str());
        unsafe {
            env::set_var("SIGNED_DOC_SK", sk_hex);
        }
        process_docs(
            &mut std::fs::File::create("f14.sql").unwrap(),
            F14_TEMPLATES.as_ref().unwrap().values().peekable(),
        )
        .unwrap();
        process_docs(
            &mut std::fs::File::create("f15.sql").unwrap(),
            F15_TEMPLATES.as_ref().unwrap().values().peekable(),
        )
        .unwrap();
    }
}
