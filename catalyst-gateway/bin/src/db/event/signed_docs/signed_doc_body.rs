//! `SignedDocBody` struct implementation.

/// Signed doc body event db struct
#[derive(Debug, Clone, PartialEq)]
pub(crate) struct SignedDocBody {
    /// `signed_doc` table `id` field
    pub(crate) id: uuid::Uuid,
    /// `signed_doc` table `ver` field
    pub(crate) ver: uuid::Uuid,
    /// `signed_doc` table `type` field
    pub(crate) doc_type: uuid::Uuid,
    /// `signed_doc` table `author` field
    pub(crate) author: String,
    /// `signed_doc` table `metadata` field
    pub(crate) metadata: Option<serde_json::Value>,
}
