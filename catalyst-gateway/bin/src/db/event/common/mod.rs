//! Reusable common database objects

pub(crate) mod query_limits;
pub(crate) mod uuid_list;
pub(crate) mod uuid_selector;

/// SQL conditional statement trait
pub(crate) trait ConditionalStmt {
    /// Return a sql conditional statement by the provided `table_field`
    fn conditional_stmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        table_field: &str,
    ) -> std::fmt::Result;
}

impl<T: ConditionalStmt> ConditionalStmt for Option<T> {
    fn conditional_stmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        table_field: &str,
    ) -> std::fmt::Result {
        if let Some(v) = self {
            v.conditional_stmt(f, table_field)?;
        }
        Ok(())
    }
}
