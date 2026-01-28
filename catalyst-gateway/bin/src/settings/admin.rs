//! Command line and environment variable for admin settings

use std::str::FromStr;

use catalyst_types::catalyst_id::{CatalystId, key_rotation::KeyRotation, role_index::RoleId};
use ed25519_dalek::VerifyingKey;

use super::str_env_var::StringEnvVar;

/// Configuration for the Admin functionality.
#[derive(Clone)]
pub(crate) struct EnvVars {
    /// The Catalyst Signed Document Admin Catalyst ID from the `ADMIN_CATALYST_ID`
    /// env.
    admin_key: Option<CatalystId>,
}

impl EnvVars {
    /// Create a config for Catalyst Signed Document validation configuration.
    pub(super) fn new() -> Self {
        let admin_key = string_to_catalyst_id(
            &StringEnvVar::new_optional("ADMIN_CATALYST_ID", false)
                .map(|v| v.as_string())
                .unwrap_or_default(),
        )
        .filter(|v| {
            let is_admin = v.is_admin();
            if !is_admin {
                tracing::error!(
                    cat_id = v.to_string(),
                    "Admin Catalyst ID must be in the admin format."
                );
            }
            let is_valid_role_and_rotation =
                v.role_and_rotation() == (RoleId::Role0, KeyRotation::DEFAULT);
            if !is_valid_role_and_rotation {
                tracing::error!(
                    cat_id = v.to_string(),
                    "Admin Catalyst ID must be role 0 with 0 rotation."
                );
            }
            is_admin && is_valid_role_and_rotation
        });

        if admin_key.is_none() {
            tracing::error!("Missing or invalid Catalyst ID for Admin. This is required.");
        }

        Self { admin_key }
    }

    /// Returns the Admin's role0 public key if the given Catalyst ID matches with the
    /// assigned Admin Catalyst ID.
    pub(crate) fn get_admin_key(
        &self,
        cat_id: &CatalystId,
        role: RoleId,
    ) -> Option<(VerifyingKey, KeyRotation)> {
        if let Some(ref admin_key) = self.admin_key
            && cat_id == admin_key
            && role == RoleId::Role0
        {
            return Some((admin_key.role0_pk(), KeyRotation::DEFAULT));
        }

        None
    }
}

/// Convert an Envvar into the Catalyst ID type, `None` if missing or invalid value.
fn string_to_catalyst_id(s: &str) -> Option<CatalystId> {
    CatalystId::from_str(s)
        .inspect_err(|err| {
            tracing::error!(
                err = ?err,
                "Cannot parse Admin CatalystId entry"
            );
        })
        .ok()
}
