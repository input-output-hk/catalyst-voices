//! Utilities for RBAC registrations validation.

use rbac_registration::{
    cardano::cip509::Cip509,
    providers::RbacRegistrationProvider,
    registration::cardano::validation::{start_new_chain, update_chain, RbacValidationResult},
};

/// Validates a new registration by either starting a new chain or adding it to the
/// existing one.
///
/// In case of failure a problem report from the given registration is updated and
/// returned.
pub async fn validate_rbac_registration<Provider>(
    reg: Cip509,
    is_persistent: bool,
    provider: &Provider,
) -> RbacValidationResult
where
    Provider: RbacRegistrationProvider,
{
    match reg.previous_transaction() {
        // `Box::pin` is used here because of the future size (`clippy::large_futures` lint).
        Some(previous_txn) => {
            Box::pin(update_chain(reg, previous_txn, is_persistent, provider)).await
        },
        None => Box::pin(start_new_chain(reg, is_persistent, provider)).await,
    }
}
