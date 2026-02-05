//! Document reference selector filtering object.

use std::ops::Deref;

use crate::db::event::{common::ConditionalStmt, signed_docs::DocumentRef};

/// Document reference selector filtering object.
#[derive(Clone, Debug, PartialEq)]
pub enum DocumentRefSelector {
    /// Search by id or version or both.
    IdOrVer(DocumentRef),
    /// Search by the exact `DocumentRefs`
    Eq(Vec<catalyst_signed_doc::DocumentRef>),
    /// Search with `DocumentRef` in the given list.
    In(Vec<catalyst_signed_doc::DocumentRef>),
}

impl ConditionalStmt for DocumentRefSelector {
    fn conditional_stmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        table_field: &str,
    ) -> std::fmt::Result {
        match self {
            Self::IdOrVer(r) => r.conditional_stmt(f, table_field),
            Self::Eq(refs) => {
                // TODO: FIXME:
                todo!()
            },
            Self::In(refs) => {
                write!(
                    f,
                    "EXISTS (SELECT 1 FROM JSONB_ARRAY_ELEMENTS({table_field}) AS doc_ref WHERE doc_ref IN ({refs}))",
                )
            },
        }
    }
}

impl From<catalyst_signed_doc::providers::DocumentRefSelector> for DocumentRefSelector {
    fn from(val: catalyst_signed_doc::providers::DocumentRefSelector) -> Self {
        match val {
            catalyst_signed_doc::providers::DocumentRefSelector::Eq(refs) => {
                Self::Eq(refs.deref().clone())
            },
            catalyst_signed_doc::providers::DocumentRefSelector::In(refs) => Self::In(refs),
        }
    }
}
