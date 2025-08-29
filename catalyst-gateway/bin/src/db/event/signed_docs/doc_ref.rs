//! Document Reference filtering object.

use std::fmt::Write;

use crate::db::event::common::eq_or_ranged_uuid::EqOrRangedUuid;

/// Document Reference filtering struct.
#[derive(Clone, Debug)]
pub(crate) struct DocumentRef {
    /// Document id filtering
    pub(crate) id: Option<EqOrRangedUuid>,
    /// Document ver filtering
    pub(crate) ver: Option<EqOrRangedUuid>,
}

impl DocumentRef {
    /// Return a sql conditional statement by the provided `table_field`
    pub(crate) fn conditional_stmt(
        &self,
        table_field: &str,
    ) -> String {
        let mut stmt = "TRUE".to_string();
        if let Some(id) = &self.id {
            let _ = write!(
                stmt,
                " AND {}",
                id.conditional_stmt("(doc_ref->>'id')::uuid")
            );
        }
        if let Some(ver) = &self.ver {
            let _ = write!(
                stmt,
                " AND {}",
                ver.conditional_stmt("(doc_ref->>'ver')::uuid")
            );
        }

        format!(
            "EXISTS (SELECT 1 FROM JSONB_ARRAY_ELEMENTS({table_field}) AS doc_ref WHERE {stmt})"
        )
    }
}
