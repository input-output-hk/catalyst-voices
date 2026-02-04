//! A conditional statement object for `CatalystId`.

use catalyst_types::catalyst_id::CatalystId;
use itertools::Itertools;

use crate::db::event::common::ConditionalStmt;

/// A `CatalystId` search selector.
#[derive(Debug, Clone, PartialEq)]
pub enum CatalystIdSelector {
    /// Search by the exact `Vec<CatalystId>`
    Eq(Vec<CatalystId>),
    /// Search with `CatalystId` in the given list.
    In(Vec<CatalystId>),
}

impl ConditionalStmt for CatalystIdSelector {
    fn conditional_stmt(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        table_field: &str,
    ) -> std::fmt::Result {
        match self {
            Self::Eq(ids) => {
                let ids = ids.iter().map(|uuid| format!("'{uuid}'")).join(",");
                write!(
                    f,
                    "{table_field} <@ ARRAY[{ids}] AND {table_field} @> ARRAY[{ids}]"
                )
            },
            Self::In(ids) => {
                write!(
                    f,
                    "{table_field} IN ({})",
                    ids.iter().map(|uuid| format!("'{uuid}'")).join(",")
                )
            },
        }
    }
}

impl From<catalyst_signed_doc::providers::CatalystIdSelector> for CatalystIdSelector {
    fn from(value: catalyst_signed_doc::providers::CatalystIdSelector) -> Self {
        match value {
            catalyst_signed_doc::providers::CatalystIdSelector::In(ids) => Self::In(ids),
            catalyst_signed_doc::providers::CatalystIdSelector::Eq(ids) => Self::Eq(ids),
        }
    }
}
