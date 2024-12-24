//! `DocsQueryFilter` struct implementation.

/// A `select_signed_docs` query filtering argument.
#[allow(dead_code)]
pub(crate) enum DocsQueryFilter {
    /// All entries
    All,
    /// Select docs with the specific `type` field
    DocType(uuid::Uuid),
    /// Select docs with the specific `id` field
    DocId(uuid::Uuid),
    /// Select docs with the specific `id` and `ver` field
    DocVer(uuid::Uuid, uuid::Uuid),
    /// Select docs with the specific `author` field
    Author(String),
}

impl DocsQueryFilter {
    /// Returns a string with the corresponding query docs filter statement
    pub(crate) fn query_stmt(&self) -> String {
        match self {
            Self::All => "TRUE".to_string(),
            Self::DocType(doc_type) => format!("signed_docs.type = '{doc_type}'"),
            Self::DocId(id) => format!("signed_docs.id = '{id}'"),
            Self::DocVer(id, ver) => {
                format!("signed_docs.id = '{id}' AND signed_docs.ver = '{ver}'")
            },
            Self::Author(author) => format!("signed_docs.author = '{author}'"),
        }
    }
}
