//! Utilities for RBAC registrations validation.

use std::collections::{HashMap, HashSet};

use anyhow::{Context, Result};
use cardano_chain_follower::{hashes::TransactionId, StakeAddress};
use catalyst_types::{
    catalyst_id::{role_index::RoleId, CatalystId},
    problem_report::ProblemReport,
};
use ed25519_dalek::VerifyingKey;
use futures::StreamExt;
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};

use crate::{
    db::index::{
        queries::rbac::get_catalyst_id_from_stake_address::cache_stake_address,
        session::CassandraSession,
    },
    rbac::{
        chains_cache::{cache_persistent_rbac_chain, cached_persistent_rbac_chain},
        get_chain::{apply_regs, build_rbac_chain, persistent_rbac_chain},
        latest_rbac_chain, RbacBlockIndexingContext, RbacValidationError, RbacValidationResult,
        RbacValidationSuccess,
    },
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
    match reg.previous_transaction() {
        // `Box::pin` is used here because of the future size (`clippy::large_futures` lint).
        Some(previous_txn) => {
            Box::pin(update_chain(reg, previous_txn, is_persistent, context)).await
        },
        None => Box::pin(start_new_chain(reg, is_persistent, context)).await,
    }
}

/// Tries to update an existing RBAC chain.
async fn update_chain(
    reg: Cip509,
    previous_txn: TransactionId,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> RbacValidationResult {
    let purpose = reg.purpose();
    let report = reg.report().to_owned();

    // Find a chain this registration belongs to.
    let Some(catalyst_id) = catalyst_id_from_txn_id(previous_txn, is_persistent, context).await?
    else {
        // We are unable to determine a Catalyst ID, so there is no sense to update the problem
        // report because we would be unable to store this registration anyway.
        return Err(RbacValidationError::UnknownCatalystId);
    };
    let chain = chain(&catalyst_id, is_persistent, context).await?
        .context("{catalyst_id} is present in 'catalyst_id_for_txn_id' table, but not in 'rbac_registration'")?;

    // Check that addresses from the new registration aren't used in other chains.
    let previous_addresses = chain.stake_addresses();
    let reg_addresses = cip509_stake_addresses(&reg);
    let new_addresses: Vec<_> = reg_addresses.difference(&previous_addresses).collect();
    for address in &new_addresses {
        match catalyst_id_from_stake_address(address, is_persistent, context).await? {
            None => {
                // All good: the address wasn't used before.
            },
            Some(_) => {
                report.functional_validation(
                    &format!("{address} stake addresses is already used"),
                    "It isn't allowed to use same stake address in multiple registration chains",
                );
            },
        }
    }

    // Store values before consuming the registration.
    let txn_id = reg.txn_hash();
    let stake_addresses = cip509_stake_addresses(&reg);
    let origin = reg.origin().to_owned();

    // Try to add a new registration to the chain.
    let new_chain = chain.update(reg).ok_or_else(|| {
        RbacValidationError::InvalidRegistration {
            catalyst_id: catalyst_id.clone(),
            purpose,
            report: report.clone(),
        }
    })?;

    // Check that new public keys aren't used by other chains.
    let public_keys = validate_public_keys(&new_chain, is_persistent, &report, context).await?;

    // Return an error if any issues were recorded in the report.
    if report.is_problematic() {
        return Err(RbacValidationError::InvalidRegistration {
            catalyst_id,
            purpose,
            report,
        });
    }

    // Everything is fine: update the context.
    context.insert_transaction(txn_id, catalyst_id.clone());
    context.insert_addresses(stake_addresses.clone(), &catalyst_id);
    context.insert_public_keys(public_keys.clone(), &catalyst_id);
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
        cache_persistent_rbac_chain(catalyst_id.clone(), new_chain);
    }

    Ok(RbacValidationSuccess {
        catalyst_id,
        stake_addresses,
        public_keys,
        // Only new chains can take ownership of stake addresses of existing chains, so in this case
        // other chains aren't affected.
        modified_chains: Vec::new(),
        purpose,
    })
}

/// Tries to start a new RBAC chain.
async fn start_new_chain(
    reg: Cip509,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> RbacValidationResult {
    let catalyst_id = reg.catalyst_id().map(CatalystId::as_short_id);
    let purpose = reg.purpose();
    let report = reg.report().to_owned();

    // Try to start a new chain.
    let new_chain = RegistrationChain::new(reg).ok_or_else(|| {
        if let Some(catalyst_id) = catalyst_id {
            RbacValidationError::InvalidRegistration {
                catalyst_id,
                purpose,
                report: report.clone(),
            }
        } else {
            RbacValidationError::UnknownCatalystId
        }
    })?;

    // Verify that a Catalyst ID of this chain is unique.
    let catalyst_id = new_chain.catalyst_id().as_short_id();
    if is_chain_known(&catalyst_id, is_persistent, context).await? {
        report.functional_validation(
            &format!("{catalyst_id} is already used"),
            "It isn't allowed to use same Catalyst ID (certificate subject public key) in multiple registration chains",
        );
        return Err(RbacValidationError::InvalidRegistration {
            catalyst_id,
            purpose,
            report,
        });
    }

    // Validate stake addresses.
    let new_addresses = new_chain.stake_addresses();
    let mut updated_chains: HashMap<_, HashSet<StakeAddress>> = HashMap::new();
    for address in &new_addresses {
        if let Some(id) = catalyst_id_from_stake_address(address, is_persistent, context).await? {
            // If an address is used in existing chain then a new chain must have different role 0
            // signing key.
            let previous_chain = chain(&id, is_persistent, context)
                .await?
                .context("{id} is present in 'catalyst_id_for_stake_address', but not in 'rbac_registration'")?;
            if previous_chain.get_latest_signing_pk_for_role(&RoleId::Role0)
                == new_chain.get_latest_signing_pk_for_role(&RoleId::Role0)
            {
                report.functional_validation(
                    &format!("A new registration ({catalyst_id}) uses the same public key as the previous one ({})",
                        previous_chain.catalyst_id().as_short_id()
                    ),
                    "It is only allowed to override the existing chain by using different public key",
                );
            } else {
                // The new root registration "takes" an address(es) from the existing chain, so that
                // chain needs to be updated.
                updated_chains
                    .entry(id)
                    .and_modify(|e| {
                        e.insert(address.clone());
                    })
                    .or_insert([address.clone()].into_iter().collect());
            }
        }
    }

    // Check that new public keys aren't used by other chains.
    let public_keys = validate_public_keys(&new_chain, is_persistent, &report, context).await?;

    if report.is_problematic() {
        return Err(RbacValidationError::InvalidRegistration {
            catalyst_id,
            purpose,
            report,
        });
    }

    // Everything is fine: update the context.
    context.insert_transaction(new_chain.current_tx_id_hash(), catalyst_id.clone());
    // This will also update the addresses that are already present in the context if they
    // were reassigned to the new chain.
    context.insert_addresses(new_addresses.clone(), &catalyst_id);
    context.insert_public_keys(public_keys.clone(), &catalyst_id);
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

    // This cache must be updated because these addresses previously belonged to other chains.
    for (catalyst_id, addresses) in &updated_chains {
        for address in addresses {
            cache_stake_address(is_persistent, address.clone(), catalyst_id.clone());
        }
    }

    Ok(RbacValidationSuccess {
        catalyst_id,
        stake_addresses: new_addresses,
        public_keys,
        modified_chains: updated_chains.into_iter().collect(),
        purpose,
    })
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

/// Returns either persistent or "latest" (persistent + volatile) registration chain for
/// the given Catalyst ID.
async fn chain(
    id: &CatalystId,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> Result<Option<RegistrationChain>> {
    let chain = if is_persistent {
        persistent_rbac_chain(id).await?
    } else {
        latest_rbac_chain(id).await?.map(|i| i.chain)
    };

    // Apply additional registrations from context if any.
    if let Some(regs) = context.find_registrations(id) {
        let regs = regs.iter().cloned();
        match chain {
            Some(c) => apply_regs(c, regs).await.map(Some),
            None => build_rbac_chain(regs).await,
        }
    } else {
        Ok(chain)
    }
}

/// Returns a Catalyst ID corresponding to the given stake address.
async fn catalyst_id_from_stake_address(
    address: &StakeAddress,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> Result<Option<CatalystId>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_stake_address::Query;

    // Check the context first.
    if let Some(catalyst_id) = context.find_address(address) {
        return Ok(Some(catalyst_id.to_owned()));
    }

    // Then try to find in the persistent database.
    let session =
        CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
    if let Some(id) = Query::latest(&session, address).await? {
        return Ok(Some(id));
    }

    // Conditionally check the volatile database.
    if !is_persistent {
        let session =
            CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
        return Query::latest(&session, address).await;
    }

    Ok(None)
}

/// Checks that a new registration doesn't contain a signing key that was used by any
/// other chain. Returns a list of public keys in the registration.
async fn validate_public_keys(
    chain: &RegistrationChain,
    is_persistent: bool,
    report: &ProblemReport,
    context: &mut RbacBlockIndexingContext,
) -> Result<HashSet<VerifyingKey>> {
    let mut keys = HashSet::new();

    let roles: Vec<_> = chain.role_data_history().keys().collect();
    let catalyst_id = chain.catalyst_id().as_short_id();

    for role in roles {
        if let Some((key, _)) = chain.get_latest_signing_pk_for_role(role) {
            keys.insert(key);
            if let Some(previous) = catalyst_id_from_public_key(key, is_persistent, context).await?
            {
                if previous != catalyst_id {
                    report.functional_validation(
                        &format!("An update to {catalyst_id} registration chain uses the same public key ({key:?}) as {previous} chain"),
                        "It isn't allowed to use role 0 signing (certificate subject public) key in different chains",
                    );
                }
            }
        }
    }

    Ok(keys)
}

/// Returns a Catalyst ID corresponding to the given public key.
async fn catalyst_id_from_public_key(
    key: VerifyingKey,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> Result<Option<CatalystId>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_public_key::Query;

    // Check the context first.
    if let Some(catalyst_id) = context.find_public_key(&key) {
        return Ok(Some(catalyst_id.to_owned()));
    }

    // Then try to find in the persistent database.
    let session =
        CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
    if let Some(id) = Query::get(&session, key).await? {
        return Ok(Some(id));
    }

    // Conditionally check the volatile database.
    if !is_persistent {
        let session =
            CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
        return Query::get(&session, key).await;
    }

    Ok(None)
}

/// Returns `true` if a chain with the given Catalyst ID already exists.
///
/// This function behaves in the same way as `latest_rbac_chain(...).is_some()` but the
/// implementation is more optimized because we don't need to build the whole chain.
pub async fn is_chain_known(
    id: &CatalystId,
    is_persistent: bool,
    context: &mut RbacBlockIndexingContext,
) -> Result<bool> {
    if context.find_registrations(id).is_some() {
        return Ok(true);
    }

    let session =
        CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;

    // We only cache persistent chains, so it is ok to check the cache regardless of the
    // `is_persistent` parameter value.
    if cached_persistent_rbac_chain(&session, id).is_some() {
        return Ok(true);
    }

    if is_cat_id_known(&session, id).await? {
        return Ok(true);
    }

    // Conditionally check the volatile database.
    if !is_persistent {
        let session =
            CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
        if is_cat_id_known(&session, id).await? {
            return Ok(true);
        }
    }

    Ok(false)
}

/// Returns `true` if there is at least one registration with the given Catalyst ID.
async fn is_cat_id_known(
    session: &CassandraSession,
    id: &CatalystId,
) -> Result<bool> {
    use crate::db::index::queries::rbac::get_rbac_registrations::{Query, QueryParams};

    Ok(Query::execute(session, QueryParams {
        catalyst_id: id.clone().into(),
    })
    .await?
    .next()
    .await
    .is_some())
}

/// Returns a set of stake addresses in the given registration.
fn cip509_stake_addresses(cip509: &Cip509) -> HashSet<StakeAddress> {
    cip509
        .metadata()
        .map(|m| m.certificate_uris.stake_addresses())
        .unwrap_or_default()
}
