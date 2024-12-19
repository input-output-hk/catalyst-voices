//! `FullSignedDoc` struct implementation.

use super::SignedDocBody;

/// Full signed doc event db struct
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct FullSignedDoc {
    /// Signed doc body
    pub(crate) body: SignedDocBody,
    /// `signed_doc` table `payload` field
    pub(crate) payload: Option<serde_json::Value>,
    /// `signed_doc` table `raw` field
    pub(crate) raw: Vec<u8>,
}
