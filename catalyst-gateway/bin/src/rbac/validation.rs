//! Utilities for RBAC registrations validation.

use std::collections::HashSet;

use anyhow::{anyhow, Context, Result};
use cardano_blockchain_types::{StakeAddress, TransactionId};
use catalyst_types::{catalyst_id::CatalystId, problem_report::ProblemReport};
use ed25519_dalek::VerifyingKey;
use futures::TryFutureExt;
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};

use crate::{
    db::index::session::CassandraSession,
    rbac::{
        get_chain::{apply_regs, build_rbac_chain},
        latest_rbac_chain, persistent_rbac_chain,
        validation_result::RbacUpdate,
        RbacIndexingContext, RbacValidationError, RbacValidationResult,
    },
};

/// Validates a new registration by either starting a new chain or adding it to the
/// existing one.
///
/// In case of failure a problem report from the given registration is updated and
/// returned.
pub async fn validate_rbac_registration(
    reg: Cip509, is_persistent: bool, context: &mut RbacIndexingContext,
) -> RbacValidationResult {
    match reg.previous_transaction() {
        Some(previous_txn) => update_chain(reg, previous_txn, is_persistent, context).await,
        None => start_new_chain(reg, is_persistent).await,
    }
}

async fn update_chain(
    reg: Cip509, previous_txn: TransactionId, is_persistent: bool,
    context: &mut RbacIndexingContext,
) -> RbacValidationResult {
    let purpose = reg.purpose();
    let report = reg.report().to_owned();

    // Find a chain this registration belongs to.
    let catalyst_id = match catalyst_id_from_txn_id(previous_txn, is_persistent, context).await? {
        Some(id) => id,
        None => {
            // We are unable to determine a Catalyst ID, so there is no sense to update the
            // problem report because we would be unable to store this registration anyway.
            return Err(RbacValidationError::UnknownCatalystId);
        },
    };
    let chain = match chain(&catalyst_id, is_persistent, context).await? {
        Some(c) => c,
        None => {
            return Err(anyhow!("{catalyst_id} is present in 'catalyst_id_for_txn_id' table, but not in 'rbac_registration'").into());
        },
    };

    // Check that addresses from the new registration aren't used in other chains.
    let previous_addresses = chain.role_0_stake_addresses();
    let reg_addresses = reg.role_0_stake_addresses();
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
    let stake_addresses = reg.role_0_stake_addresses();
    let origin = reg.origin().to_owned();

    // Try to add a new registration to the chain.
    let new_chain = chain.update(reg).map_err(|e| {
        report.other(
            &format!("{e:?}"),
            "Failed to apply update the registration chain",
        );
        RbacValidationError::InvalidRegistration {
            catalyst_id: catalyst_id.clone(),
            purpose,
            report: report.clone(),
        }
    })?;

    // Check that new public keys aren't used by other chains.
    let keys = validate_public_keys(&new_chain, is_persistent, &report, context).await?;

    if report.is_problematic() {
        return Err(RbacValidationError::InvalidRegistration {
            catalyst_id,
            purpose,
            report,
        });
    }

    // Everything is fine: update the context.
    context.insert_transaction(txn_id, catalyst_id.clone());
    context.insert_addresses(stake_addresses, catalyst_id.clone());
    context.insert_public_keys(&keys, catalyst_id.clone());
    context.insert_registration(
        catalyst_id.clone(),
        txn_id,
        origin.point().slot_or_default(),
        origin.txn_index(),
        Some(previous_txn),
        // Only a new chain can remove stake addresses from an existing one.
        HashSet::new(),
    );

    Ok(vec![RbacUpdate {
        catalyst_id,
        removed_stake_addresses: HashSet::new(),
    }])
}

async fn start_new_chain(reg: Cip509, is_persistent: bool) -> RbacValidationResult {
    let catalyst_id = reg.catalyst_id().cloned();
    let purpose = reg.purpose();
    let report = reg.report().to_owned();

    let new_chain = RegistrationChain::new(reg).map_err(|e| {
        report.other(&format!("{e:?}"), "Failed to start a registration chain");
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

    let catalyst_id = new_chain.catalyst_id().to_owned();
    // // TODO: FIXME: Check context and instead of building full chain just check the
    // presence // of any information in the database!

    // match chain(&catalyst_id, is_persistent).await {
    //     Err(e) => {
    //         error!("Error finding a chain for {catalyst_id}: {e:?}");
    //     },
    //     Ok(Some(_)) => {
    //         report.functional_validation(
    //             &format!("{catalyst_id} is already used"),
    //             "It isn't allowed to use same Catalyst ID (certificate subject public key)
    // in multiple registration chains",         );
    //         return Err(RbacValidationError::InvalidRegistration {
    //             catalyst_id,
    //             purpose,
    //             report,
    //         });
    //     },
    //     Ok(None) => {},
    // }
    // if self.chains.get(&catalyst_id).is_some() {
    //     report.functional_validation(
    //         &format!("{catalyst_id} is already used"),
    //         "It isn't allowed to use same Catalyst ID (certificate subject public key)
    // in multiple registration chains",
    //     );
    //     return Err(RbacValidationError::InvalidRegistration {
    //         catalyst_id,
    //         purpose,
    //         report,
    //     });
    // }

    // let new_addresses = new_chain.role_0_stake_addresses();
    // for address in &new_addresses {
    //     if let Some(id) = self.active_addresses.get(address) {
    //         let previous_chain = self.chains.get(&id).ok_or_else(|| {
    //             // This means the cache is broken. This should never normally happen.
    //             error!("Broken RBAC cache: {id} is present in ACTIVE_ADDRESSES cache,
    // but missing in CHAINS");             RbacCacheAddError::InvalidRegistration {
    //                 catalyst_id: catalyst_id.clone(),
    //                 purpose,
    //                 report: report.clone(),
    //             }
    //         })?;
    //
    //         if previous_chain.get_latest_signing_pk_for_role(&RoleId::Role0)
    //             == new_chain.get_latest_signing_pk_for_role(&RoleId::Role0)
    //         {
    //             report.functional_validation(
    //                 &format!("A new registration ({catalyst_id}) uses the same public
    // key as the previous one ({})",
    // previous_chain.catalyst_id()),                 "It is only allowed to override
    // the existing chain by using different public key",             );
    //         }
    //     }
    // }
    //
    // self.verify_public_keys(&new_chain, &report);
    //
    // if report.is_problematic() {
    //     return Err(RbacCacheAddError::InvalidRegistration {
    //         catalyst_id,
    //         purpose,
    //         report,
    //     });
    // }
    //
    // // Everything is fine: update caches.
    // for address in new_addresses {
    //     self.active_addresses
    //         .insert(address.clone(), catalyst_id.clone());
    // }
    // self.transactions
    //     .insert(new_chain.current_tx_id_hash(), catalyst_id.clone());
    // if let Some((key, _)) = new_chain.get_latest_signing_pk_for_role(&RoleId::Role0) {
    //     self.public_keys.insert(key, catalyst_id.clone());
    // } else {
    //     // A root registration should always contain role 0 with a signing key. The
    // registration     // must already be validated, so this should never happen.
    //     error!("{catalyst_id} root registration doesn't have a signing key");
    // }
    // self.chains.insert(catalyst_id.clone(), new_chain);
    //
    // Ok(RbacCacheAddSuccess { catalyst_id })
    todo!()
}

/// Returns a Catalyst ID corresponding to the given transaction hash.
async fn catalyst_id_from_txn_id(
    txn_id: TransactionId, is_persistent: bool, context: &mut RbacIndexingContext,
) -> Result<Option<CatalystId>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_transaction_id::Query;

    // Check the context first.
    if let Some(catalyst_id) = context.find_transaction(&txn_id) {
        return Ok(Some(catalyst_id.to_owned()));
    }

    // Then try to find in the persistent database.
    let session =
        CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
    if let Some(r) = Query::get(&session, txn_id).await? {
        return Ok(Some(r.catalyst_id));
    };

    // Conditionally check the volatile database.
    if !is_persistent {
        let session =
            CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
        return Query::get(&session, txn_id)
            .map_ok(|r| r.map(|r| r.catalyst_id))
            .await;
    }

    Ok(None)
}

/// Returns either persistent or "latest" (persistent + volatile) registration chain for
/// the given Catalyst ID.
async fn chain(
    id: &CatalystId, is_persistent: bool, context: &mut RbacIndexingContext,
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
    address: &StakeAddress, is_persistent: bool, context: &mut RbacIndexingContext,
) -> Result<Option<CatalystId>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_stake_address::Query;

    // Check the context first.
    if let Some(catalyst_id) = context.find_address(address) {
        return Ok(Some(catalyst_id.to_owned()));
    }

    // Then try to find in the persistent database.
    let session =
        CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
    if let Some(r) = Query::latest(&session, address).await? {
        return Ok(Some(r.catalyst_id));
    };

    // Conditionally check the volatile database.
    if !is_persistent {
        let session =
            CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
        return Query::latest(&session, address)
            .map_ok(|r| r.map(|r| r.catalyst_id))
            .await;
    }

    Ok(None)
}

/// Checks that a new registration doesn't contain a signing key that was used by any
/// other chain. Returns a list of public keys in the registration.
async fn validate_public_keys(
    chain: &RegistrationChain, is_persistent: bool, report: &ProblemReport,
    context: &mut RbacIndexingContext,
) -> Result<Vec<VerifyingKey>> {
    let mut keys = Vec::new();

    let roles: Vec<_> = chain.role_data_history().keys().collect();
    let catalyst_id = chain.catalyst_id();

    for role in roles {
        if let Some((key, _)) = chain.get_latest_signing_pk_for_role(role) {
            keys.push(key);
            if let Some(previous) = catalyst_id_from_public_key(key, is_persistent, context).await?
            {
                if &previous != catalyst_id {
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
    key: VerifyingKey, is_persistent: bool, context: &mut RbacIndexingContext,
) -> Result<Option<CatalystId>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_public_key::Query;

    // Check the context first.
    if let Some(catalyst_id) = context.find_public_key(&key) {
        return Ok(Some(catalyst_id.to_owned()));
    }

    // Then try to find in the persistent database.
    let session =
        CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
    if let Some(r) = Query::get(&session, key).await? {
        return Ok(Some(r.catalyst_id));
    };

    // Conditionally check the volatile database.
    if !is_persistent {
        let session =
            CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
        return Query::get(&session, key)
            .map_ok(|r| r.map(|r| r.catalyst_id))
            .await;
    }

    Ok(None)
}
