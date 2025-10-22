//! Utilities for RBAC registrations validation.

use std::collections::HashSet;

use anyhow::Context;
use rbac_registration::{
    cardano::cip509::Cip509,
    registration::cardano::validation::{start_new_chain, update_chain, RbacValidationResult},
};

use crate::{
    db::index::queries::rbac::get_catalyst_id_from_stake_address::cache_stake_address,
    rbac::{chains_cache::cache_persistent_rbac_chain, RbacBlockIndexingContext},
};

/// Validates a new registration by either starting a new chain or adding it to the
/// existing one.
///
/// In case of failure a problem report from the given registration is updated and
/// returned.
pub async fn validate_rbac_registration(
    reg: Cip509,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> RbacValidationResult {
    // `Box::pin` is used here because of the future size (`clippy::large_futures` lint).
    if let Some(previous_txn) = reg.previous_transaction() {
        let result = Box::pin(update_chain(reg, previous_txn, is_persistent, context)).await;

        // Everything is fine: update the context.
        if let Ok((new_chain, reg)) = &result {
            let catalyst_id = reg
                .catalyst_id()
                .context("Cip509 error: cannot read Catalyst ID")?;
            let txn_id = reg.txn_hash();
            let stake_addresses = reg.stake_addresses();
            let public_keys = reg.public_keys();
            let origin = reg.origin();

            context.insert_transaction(txn_id, catalyst_id.clone());
            context.insert_addresses(stake_addresses.clone(), catalyst_id);
            context.insert_public_keys(public_keys.clone(), catalyst_id);
            context.insert_registration(
                catalyst_id.clone(),
                txn_id,
                origin.point().slot_or_default(),
                origin.txn_index(),
                Some(previous_txn),
                // Only a new chain can remove stake addresses from an existing one.
                HashSet::new(),
            );

            if is_persistent {
                cache_persistent_rbac_chain(catalyst_id.clone(), new_chain.clone());
            }
        }

        result
    } else {
        let result = Box::pin(start_new_chain(reg, is_persistent, context)).await;

        // Everything is fine: update the context.
        if let Ok((new_chain, reg)) = &result {
            let catalyst_id = reg
                .catalyst_id()
                .context("Cip509 error: cannot read Catalyst ID")?;
            let public_keys = reg.public_keys();
            let new_addresses = new_chain.stake_addresses();

            context.insert_transaction(new_chain.current_tx_id_hash(), catalyst_id.clone());
            // This will also update the addresses that are already present in the context if
            // they were reassigned to the new chain.
            context.insert_addresses(new_addresses.clone(), catalyst_id);
            context.insert_public_keys(public_keys.clone(), catalyst_id);
            context.insert_registration(
                catalyst_id.clone(),
                new_chain.current_tx_id_hash(),
                new_chain.current_point().slot_or_default(),
                new_chain.current_txn_index(),
                // No previous transaction for the root registration.
                None,
                // This chain has just been created, so no addresses have been removed from it.
                HashSet::new(),
            );

            // This cache must be updated because these addresses previously belonged to other
            // chains.
            for (catalyst_id, addresses) in reg.modified_chains() {
                for address in addresses {
                    cache_stake_address(is_persistent, address.clone(), catalyst_id.clone());
                }
            }
        }

        result
    }
}
