//! A module for signed documents compatability toolings from different versions

use catalyst_signed_doc::UuidV4;

use crate::db::event::signed_docs::SignedDocBody;

/// Checks if the given signed document is in the deprecated version of below v0.04
/// format.
///
/// Returns a tuple `(doc_type_deprecated, doc_refs_deprecated)` where:
/// - `doc_type_deprecated`: `true` if the document type itself is marked as deprecated.
/// - `doc_refs_deprecated`: `true` if any document references are deprecated.
pub(crate) fn is_deprecated(doc: &SignedDocBody) -> Result<(bool, bool), anyhow::Error> {
    if let Some(json_meta) = doc.metadata() {
        let meta = catalyst_signed_doc::Metadata::from_json(json_meta.clone())?;

        let doc_type_old = doc.doc_type().len() == 1;

        if let Some(doc_refs) = meta.doc_ref() {
            let doc_ref_old = doc_refs
                .doc_refs()
                .iter()
                .any(|doc_ref| doc_ref.doc_locator().is_empty());

            return Ok((doc_type_old, doc_ref_old));
        }

        return Ok((doc_type_old, false));
    }

    Ok((false, false))
}

/// Converts the given signed document to the newer version of v0.04 if it is in the
/// deprecated version.
pub(crate) fn to_new_version(doc: SignedDocBody) -> Result<SignedDocBody, anyhow::Error> {
    let (doc_type_old, doc_ref_old) = is_deprecated(&doc)?;

    if doc_type_old || doc_ref_old {
        // TODO: rename brand_id, campaign_id and category_id to
        // the parameters and also make transformation of the DocumentRef  type
        // TODO: transform all template, ref,  reply  etc. fields which are DocumentRef into the
        // newer format.

        let doc_type = if doc_type_old {
            let uuid = doc
                .doc_type()
                .first()
                .map(|uuid| -> Result<_, anyhow::Error> {
                    let uuid = UuidV4::try_from(uuid.clone())?;
                    Ok(catalyst_signed_doc::map_doc_type(uuid))
                })
                .transpose()?;

            if let Some(uuid) = uuid {
                uuid.try_into()?
            } else {
                doc.doc_type().clone()
            }
        } else {
            doc.doc_type().clone()
        };

        let metadata = if let Some(json_meta) = doc.metadata() {
            // transform metadata by decoding and encoding it again
            let meta = catalyst_signed_doc::Metadata::from_json(json_meta.clone())?;

            Some(meta.to_json()?)
        } else {
            None
        };

        let doc = SignedDocBody::new(*doc.id(), *doc.ver(), doc_type, doc.authors().clone(), metadata);

        Ok(doc)
    } else {
        Ok(doc)
    }
}
