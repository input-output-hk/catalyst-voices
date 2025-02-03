//! Document Reference filtering object.

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
    pub(crate) fn conditional_stmt(&self, table_field: &str) -> String {
        let mut stmt = "TRUE".to_string();
        if let Some(id) = &self.id {
            stmt.push_str(&format!(
                " AND {}",
                id.conditional_stmt(&format!("({table_field}->>'id')::uuid"))
            ));
        }
        if let Some(ver) = &self.ver {
            stmt.push_str(&format!(
                " AND {}",
                ver.conditional_stmt(&format!("({table_field}->>'ver')::uuid"))
            ));
        }
        stmt
    }

    /// FIXME
    #[allow(dead_code)]
    pub(crate) fn matches(&self, id: uuid::Uuid, ver: uuid::Uuid) -> bool {
        self.id.as_ref().map_or(true, |i| i.matches(id))
            && self.ver.as_ref().map_or(true, |v| v.matches(ver))
    }
}
