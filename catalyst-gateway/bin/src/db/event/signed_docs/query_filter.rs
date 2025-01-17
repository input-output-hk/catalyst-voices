//! `DocsQueryFilter` struct implementation.

use std::fmt::Display;

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
    /// Select docs with the specific `authors` field
    Author(String),
}

impl Display for DocsQueryFilter {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::All => write!(f, "TRUE"),
            Self::DocType(doc_type) => write!(f, "signed_docs.type = '{doc_type}'"),
            Self::DocId(id) => write!(f, "signed_docs.id = '{id}'"),
            Self::DocVer(id, ver) => {
                write!(f, "signed_docs.id = '{id}' AND signed_docs.ver = '{ver}'")
            },
            Self::Author(author) => write!(f, "signed_docs.authors @> '{{ \"{author}\" }}'"),
        }
    }
}
