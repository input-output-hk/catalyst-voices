//! Document Reference filtering object.

use crate::db::event::common::{ConditionalStmt, uuid_selector::UuidSelector};

/// Document Reference filtering struct.
#[derive(Clone, Debug, PartialEq)]
pub(crate) struct DocumentRef {
    /// Document id filtering
    pub(crate) id: Option<UuidSelector>,
    /// Document ver filtering
    pub(crate) ver: Option<UuidSelector>,
}

impl ConditionalStmt for DocumentRef {
    fn conditional_stmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        table_field: &str,
    ) -> std::fmt::Result {
        write!(
            f,
            "EXISTS (SELECT 1 FROM JSONB_ARRAY_ELEMENTS({table_field}) AS doc_ref WHERE TRUE"
        )?;

        if let Some(id) = &self.id {
            write!(f, " AND ")?;
            id.conditional_stmt(f, "(doc_ref->>'id')::uuid")?;
        }
        if let Some(ver) = &self.ver {
            write!(f, " AND ")?;
            ver.conditional_stmt(f, "(doc_ref->>'ver')::uuid")?;
        }

        write!(f, ")")
    }
}
