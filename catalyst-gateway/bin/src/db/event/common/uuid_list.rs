//! `UuidList` query conditional stmt object.

use std::ops::Deref;

use itertools::Itertools;

use crate::db::event::common::ConditionalStmt;

/// Search by a list of UUIDs.
#[derive(Clone, Debug, PartialEq, Default)]
pub(crate) struct UuidList(Vec<uuid::Uuid>);

impl Deref for UuidList {
    type Target = Vec<uuid::Uuid>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl From<Vec<uuid::Uuid>> for UuidList {
    fn from(value: Vec<uuid::Uuid>) -> Self {
        Self(value)
    }
}

impl ConditionalStmt for UuidList {
    fn conditional_stmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        table_field: &str,
    ) -> std::fmt::Result {
        write!(
            f,
            "{table_field} IN ({})",
            self.0.iter().map(|uuid| format!("'{uuid}'")).join(",")
        )
    }
}
