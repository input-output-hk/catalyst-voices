//! Utilities for RBAC registrations validation.

use anyhow::Result;
use cardano_blockchain_types::TransactionId;
use catalyst_types::catalyst_id::CatalystId;
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};
use tracing::error;

use crate::rbac::{
    latest_rbac_chain, persistent_rbac_chain, RbacIndexingContext, RbacValidationError,
    RbacValidationResult,
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
        Some(previous_txn) => update_chain(reg, previous_txn),
        None => start_new_chain(reg, is_persistent).await,
    }
}

fn update_chain(reg: Cip509, previous_txn: TransactionId) -> RbacValidationResult {
    let purpose = reg.purpose();
    let report = reg.report().to_owned();

    // TODO: FIXME:

    // // Find a chain this registration belongs to.
    // let catalyst_id = self.transactions.get(&previous_txn).ok_or_else(|| {
    //     debug!("Unable to find previous transaction {previous_txn} in the RBAC cache");
    //     // We are unable to determine a Catalyst ID, so there is no sense to update the
    //     // problem report because we would be unable to store this registration anyway.
    //     RbacCacheAddError::UnknownCatalystId
    // })?;
    // let chain = self.chains.get(&catalyst_id).ok_or_else(|| {
    //     // This means the cache is broken. This should never normally happen.
    //     error!("Broken RBAC cache: {catalyst_id} is present in TRANSACTIONS cache, but
    // missing in CHAINS");     RbacCacheAddError::InvalidRegistration {
    //         catalyst_id: catalyst_id.clone(),
    //         purpose,
    //         report: report.clone(),
    //     }
    // })?;
    //
    // // Check that addresses from the new registration aren't used in other chains.
    // let previous_addresses = chain.role_0_stake_addresses();
    // let registration_addresses = registration.role_0_stake_addresses();
    // let new_addresses: Vec<_> = registration_addresses
    //     .difference(&previous_addresses)
    //     .collect();
    // for address in &new_addresses {
    //     if self.active_addresses.get(address).is_some() {
    //         report.functional_validation(
    //             &format!("{address} stake addresses is already used"),
    //             "It isn't allowed to use same stake address in multiple registration
    // chains",         );
    //     }
    // }
    //
    // // Try to add a new registration to the chain.
    // let new_chain = chain.update(registration).map_err(|e| {
    //     report.other(
    //         &format!("{e:?}"),
    //         "Failed to apply update the registration chain",
    //     );
    //     RbacCacheAddError::InvalidRegistration {
    //         catalyst_id: catalyst_id.clone(),
    //         purpose,
    //         report: report.clone(),
    //     }
    // })?;
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
    //         .insert(address.to_owned(), catalyst_id.clone());
    // }
    // self.transactions
    //     .insert(new_chain.current_tx_id_hash(), catalyst_id.clone());
    // if let Some((key, _)) = new_chain.get_latest_signing_pk_for_role(&RoleId::Role0) {
    //     self.public_keys.insert(key, catalyst_id.clone());
    // }
    // self.chains.insert(catalyst_id.clone(), new_chain);
    //
    // Ok(RbacCacheAddSuccess { catalyst_id })
    todo!()
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

/// Returns either persistent or "latest" (persistent + volatile) registration chain for
/// the given Catalyst ID.
async fn chain(id: &CatalystId, is_persistent: bool) -> Result<Option<RegistrationChain>> {
    if is_persistent {
        persistent_rbac_chain(id).await
    } else {
        Ok(latest_rbac_chain(id).await?.map(|i| i.chain))
    }
}
