//! Helpers related to the Admin Role.

use ed25519_dalek::VerifyingKey;

use crate::settings::ENV_VARS;

/// Returns the Admin's role0 public key if the given Catalyst ID matches with the
/// assigned Admin Catalyst ID.
pub(crate) fn get_admin_key(cat_id: &catalyst_signed_doc::CatalystId) -> Option<VerifyingKey> {
    let admin_key = ENV_VARS.signed_doc.admin_key();
    if let Some(admin_key) = admin_key
        && cat_id == admin_key
    {
        return Some(admin_key.role0_pk());
    }

    None
}
