//! Utilities for RBAC registrations validation.

use std::collections::HashSet;

use anyhow::{Context, Result};
use cardano_chain_follower::hashes::TransactionId;
use catalyst_types::catalyst_id::CatalystId;
use rbac_registration::{
    cardano::{cip509::Cip509, state::RbacChainsState as _},
    registration::cardano::RegistrationChain,
};

use crate::{
    db::index::session::CassandraSession,
    rbac::{
        RbacBlockIndexingContext, RbacValidationResult, RbacValidationSuccess,
        chains_cache::cache_persistent_rbac_chain, state::RbacChainsState,
    },
};

/// Validates a new registration by either starting a new chain or adding it to the
/// existing one.
///
/// In case of failure a problem report from the given registration is updated and
/// returned.
pub async fn validate_rbac_registration(
    reg: &Cip509,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> RbacValidationResult {
    match reg.previous_transaction() {
        // `Box::pin` is used here because of the future size (`clippy::large_futures` lint).
        Some(previous_txn) => update_chain(reg, previous_txn, is_persistent, context).await,
        None => start_new_chain(reg, is_persistent, context).await,
    }
}

/// Tries to update an existing RBAC chain.
async fn update_chain(
    reg: &Cip509,
    previous_txn: TransactionId,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> RbacValidationResult {
    // Find a chain this registration belongs to.
    let Some(catalyst_id) = catalyst_id_from_txn_id(previous_txn, is_persistent, context).await?
    else {
        return Ok(None);
    };

    let mut state = RbacChainsState::new(is_persistent, Some(context));

    let chain = state.chain(&catalyst_id).await?.context(format!(
        "{catalyst_id} is present in 'catalyst_id_for_txn_id' table, but not in 'rbac_registration'"
    ))?;

    // Try to add a new registration to the chain.
    let Some(new_chain) = chain.update(reg, &mut state).await? else {
        return Ok(None);
    };

    let previous_addresses = chain.stake_addresses();
    let stake_addresses: HashSet<_> = new_chain
        .stake_addresses()
        .difference(&previous_addresses)
        .cloned()
        .collect();
    let public_keys = reg
        .all_roles()
        .iter()
        .filter_map(|v| reg.signing_pk_for_role(*v))
        .collect::<HashSet<_>>();
    let modified_chains = state.consume();
    let purpose = reg.purpose();

    // Everything is fine: update the context.
    context.insert_transaction(new_chain.current_tx_id_hash(), catalyst_id.clone());
    context.insert_addresses(stake_addresses.clone(), &catalyst_id);
    context.insert_public_keys(public_keys.clone(), &catalyst_id);
    context.insert_registration(
        catalyst_id.clone(),
        new_chain.current_tx_id_hash(),
        new_chain.current_point().slot_or_default(),
        new_chain.current_txn_index(),
        Some(previous_txn),
    );

    if is_persistent {
        cache_persistent_rbac_chain(catalyst_id.clone(), new_chain);
    }

    Ok(Some(RbacValidationSuccess {
        catalyst_id,
        stake_addresses,
        public_keys,
        modified_chains,
        purpose,
    }))
}

/// Tries to start a new RBAC chain.
async fn start_new_chain(
    reg: &Cip509,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> RbacValidationResult {
    let mut state = RbacChainsState::new(is_persistent, Some(context));
    // Try to start a new chain.
    let Some(new_chain) = RegistrationChain::new(reg, &mut state).await? else {
        return Ok(None);
    };

    let catalyst_id = new_chain.catalyst_id();
    let new_addresses = new_chain.stake_addresses();
    let public_keys = reg
        .all_roles()
        .iter()
        .filter_map(|v| reg.signing_pk_for_role(*v))
        .collect::<HashSet<_>>();
    let modified_chains = state.consume();
    let purpose = reg.purpose();

    context.insert_transaction(new_chain.current_tx_id_hash(), catalyst_id.clone());
    // This will also update the addresses that are already present in the context if they
    // were reassigned to the new chain.
    context.insert_addresses(new_addresses.clone(), catalyst_id);
    context.insert_public_keys(public_keys.clone(), catalyst_id);
    context.insert_registration(
        catalyst_id.clone(),
        new_chain.current_tx_id_hash(),
        new_chain.current_point().slot_or_default(),
        new_chain.current_txn_index(),
        // No previous transaction for the root registration.
        None,
    );

    Ok(Some(RbacValidationSuccess {
        catalyst_id: catalyst_id.clone(),
        stake_addresses: new_addresses,
        public_keys,
        modified_chains,
        purpose,
    }))
}

/// Returns a Catalyst ID corresponding to the given transaction hash.
async fn catalyst_id_from_txn_id(
    txn_id: TransactionId,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> Result<Option<CatalystId>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_transaction_id::Query;

    // Check the context first.
    if let Some(catalyst_id) = context.find_transaction(&txn_id) {
        return Ok(Some(catalyst_id.to_owned()));
    }

    // Then try to find in the persistent database.
    let session =
        CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
    if let Some(id) = Query::get(&session, txn_id).await? {
        return Ok(Some(id));
    }

    // Conditionally check the volatile database.
    if !is_persistent {
        let session =
            CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
        return Query::get(&session, txn_id).await;
    }

    Ok(None)
}
