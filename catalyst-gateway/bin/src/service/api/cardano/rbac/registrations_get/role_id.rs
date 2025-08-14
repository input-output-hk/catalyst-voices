//! A Catalyst user role identifier wrapper.

use catalyst_types::catalyst_id::role_index::RoleId;
use derive_more::{From, Into};
use poem_openapi::{types::Example, NewType};

/// A Catalyst user role identifier.
#[derive(NewType, Debug, Clone, From, Into)]
#[oai(example = true)]
pub(crate) struct CatalystRoleId(u8);

impl From<RoleId> for CatalystRoleId {
    fn from(value: RoleId) -> Self {
        Self(value.into())
    }
}

impl Example for CatalystRoleId {
    fn example() -> Self {
        RoleId::Role0.into()
    }
}
