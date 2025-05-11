//! A cache for RBAC registrations.

// TODO (stanislav-tkach): Remove the attribute.
#![allow(dead_code)]

use std::sync::LazyLock;

use cardano_blockchain_types::{StakeAddress, TransactionId};
use catalyst_types::{
    catalyst_id::{role_index::RoleId, CatalystId},
    problem_report::ProblemReport,
    uuid::UuidV4,
};
use moka::{policy::EvictionPolicy, sync::Cache};
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};
use tracing::{debug, error};

/// A cache of valid RBAC registration chains.
static CHAINS: LazyLock<Cache<CatalystId, RegistrationChain>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .build()
});

/// A cache of active stake addresses.
///
/// An address considered active if it is used by any of valid RBAC chains.
static ACTIVE_ADDRESSES: LazyLock<Cache<StakeAddress, CatalystId>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .build()
});

/// A cache that allows to find a Catalyst ID of the previous registration using its
/// transaction identifier (hash).
static TRANSACTIONS: LazyLock<Cache<TransactionId, CatalystId>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .build()
});

/// A cache that allows to find all registration transaction of a chain by Catalyst ID.
static CHAIN_TRANSACTIONS: LazyLock<Cache<CatalystId, Vec<TransactionId>>> = LazyLock::new(|| {
    Cache::builder()
        .eviction_policy(EvictionPolicy::lru())
        .build()
});

/// A cache for RBAC registrations.
pub struct RbacCache {}

/// A value returned from the `RbacCache::add` on happy path.
///
/// It is used to insert a registration data to the `rbac_registration` table.
pub struct RbacCacheAddSuccess {
    /// A Catalyst ID.
    pub catalyst_id: CatalystId,
    /// A registration purpose.
    pub purpose: UuidV4,
}

/// And error returned from the `RbacCache::add` method.
///
/// It is used to insert a registration data to the `rbac_invalid_registration` table.
pub struct RbacCacheAddError {
    /// A Catalyst ID.
    pub catalyst_id: Option<CatalystId>,
    /// A registration purpose.
    pub purpose: Option<UuidV4>,
    /// A problem report.
    pub report: ProblemReport,
}

impl RbacCache {
    /// Adds the given registration to one of the existing chains or starts a new one.
    ///
    /// In case of failure a problem report from the given registration is updated and
    /// returned.
    #[allow(clippy::result_large_err)]
    // TODO: FIXME: Store both persistent and volatile registrations.
    pub fn add(
        registration: Cip509, _is_persistent: bool,
    ) -> Result<RbacCacheAddSuccess, RbacCacheAddError> {
        match registration.previous_transaction() {
            Some(previous_txn) => update_chain(registration, previous_txn),
            None => start_new_chain(registration),
        }
    }

    /// Returns a registration chain by the given Catalyst ID.
    pub fn get(id: &CatalystId) -> Option<RegistrationChain> {
        CHAINS.get(id)
    }

    /// Returns a registration chain by the stake address.
    pub fn get_by_address(address: &StakeAddress) -> Option<RegistrationChain> {
        let id = ACTIVE_ADDRESSES.get(address)?;
        Self::get(&id)
    }
}

/// Applies the given registration to one of the existing chains.
#[allow(clippy::result_large_err)]
fn update_chain(
    registration: Cip509, previous_txn: TransactionId,
) -> Result<RbacCacheAddSuccess, RbacCacheAddError> {
    let catalyst_id = registration.catalyst_id().cloned();
    let purpose = registration.purpose();
    let report = registration.report().to_owned();

    // Find a chain this registration belongs to.
    let catalyst_id = TRANSACTIONS.get(&previous_txn).ok_or_else(|| {
        debug!("Unable to find previous transaction {previous_txn} in the RBAC cache");
        // We are unable to determine a Catalyst ID, so there is no sense to update the
        // problem report because we would be unable to store this registration anyway.
        RbacCacheAddError {
            catalyst_id,
            purpose,
            report: report.clone(),
        }
    })?;
    let chain = CHAINS.get(&catalyst_id).ok_or_else(|| {
        // This means the cache is broken. This should never normally happen.
        error!("Broken Rbac cache: {catalyst_id} is present in TRANSACTIONS cache, but missing in CHAINS");
        RbacCacheAddError {
            catalyst_id: Some(catalyst_id.clone()),
            purpose,
            report: report.clone(),
        }
    })?;

    // Check that addresses from the new registration aren't used in other chains.
    let previous_addresses = chain.role_0_stake_addresses();
    let registration_addresses = registration.role_0_stake_addresses();
    let new_addresses: Vec<_> = registration_addresses
        .difference(&previous_addresses)
        .collect();
    for address in &new_addresses {
        if ACTIVE_ADDRESSES.get(address).is_some() {
            report.functional_validation(
                &format!("{address} stake addresses is already used"),
                "It isn't allowed to use same stake address in multiple registration chains",
            );
        }
    }
    if report.is_problematic() {
        return Err(RbacCacheAddError {
            catalyst_id: Some(catalyst_id),
            purpose,
            report,
        });
    }

    // Try to add a new registration to the chain.
    let new_chain = chain.update(registration).map_err(|e| {
        report.other(
            &format!("{e:?}"),
            "Failed to apply update the registration chain",
        );
        RbacCacheAddError {
            catalyst_id: Some(catalyst_id.clone()),
            purpose,
            report,
        }
    })?;

    // Everything is fine: update caches.
    for address in new_addresses {
        ACTIVE_ADDRESSES.insert(address.to_owned(), catalyst_id.clone());
    }
    TRANSACTIONS.insert(new_chain.current_tx_id_hash(), catalyst_id.clone());
    CHAIN_TRANSACTIONS
        .entry(catalyst_id.clone())
        .and_upsert_with(|e| {
            e.map(|e| {
                let mut val = e.into_value();
                val.push(new_chain.current_tx_id_hash());
                val
            })
            .unwrap_or_default()
        });
    CHAINS.insert(catalyst_id.clone(), new_chain);

    Ok(RbacCacheAddSuccess {
        catalyst_id,
        // A valid registration must have a purpose.
        #[allow(clippy::expect_used)]
        purpose: purpose.expect("Missing registration purpose"),
    })
}

/// Starts a new Rbac registration chain.
#[allow(clippy::result_large_err)]
fn start_new_chain(registration: Cip509) -> Result<RbacCacheAddSuccess, RbacCacheAddError> {
    let catalyst_id = registration.catalyst_id().cloned();
    let purpose = registration.purpose();
    let report = registration.report().to_owned();

    let new_chain = RegistrationChain::new(registration).map_err(|e| {
        report.other(
            &format!("{e:?}"),
            "Failed to apply start a registration chain",
        );
        RbacCacheAddError {
            catalyst_id,
            purpose,
            report: report.clone(),
        }
    })?;
    let catalyst_id = new_chain.catalyst_id().to_owned();
    if CHAINS.get(&catalyst_id).is_some() {
        report.functional_validation(
            &format!("{catalyst_id} is already used"),
            "It isn't allowed to use same Catalyst ID (certificate subject public key) in multiple registration chains",
        );
        return Err(RbacCacheAddError {
            catalyst_id: Some(catalyst_id),
            purpose,
            report,
        });
    }

    let new_addresses = new_chain.role_0_stake_addresses();
    let mut other_chains = Vec::new();
    for address in &new_addresses {
        if let Some(id) = ACTIVE_ADDRESSES.get(address) {
            other_chains.push(id);
        }
    }

    // TODO: FIXME: Allow to override/replace/restart multiple chains!
    match other_chains.as_slice() {
        [] => {
            // All addresses are unique - nothing to do.
        },
        [previous_chain] => {
            // Check if it is a proper overriding registration.
            let previous_chain = CHAINS.get(previous_chain).ok_or_else(|| {
                // This means the cache is broken. This should never normally happen.
                error!("Broken Rbac cache: {previous_chain} is present in ACTIVE_ADDRESSES cache, but missing in CHAINS");
                RbacCacheAddError {
                    catalyst_id: Some(catalyst_id.clone()),
                    purpose,
                    report: report.clone(),
                }
            })?;
            if previous_chain.get_latest_signing_pk_for_role(&RoleId::Role0)
                == new_chain.get_latest_signing_pk_for_role(&RoleId::Role0)
            {
                report.functional_validation(
                    &format!("A new registration ({catalyst_id}) uses the same public key as the previous one ({})",
                             previous_chain.catalyst_id()),
                    "It is only allowed to override the existing chain by using different public key",
                );
                return Err(RbacCacheAddError {
                    catalyst_id: Some(catalyst_id),
                    purpose,
                    report,
                });
            }

            // Remove the previous chain from caches.
            if let Some(transactions) = CHAIN_TRANSACTIONS.get(previous_chain.catalyst_id()) {
                for txn in transactions {
                    TRANSACTIONS.invalidate(&txn);
                }
            } else {
                error!(
                    "Unable to find {} chain transactions",
                    previous_chain.catalyst_id()
                );
            }
            CHAINS.invalidate(previous_chain.catalyst_id());
            // There is no need to update `ACTIVE_ADDRESSES` cache because it will
            // be overwritten below anyway.
        },
        [..] => {
            // At the moment we don't allow for one registration to override multiple
            // existing chains. We can reconsider this logic when multiple stake addressed
            // will be properly supported.
            report.functional_validation(
                &format!("{catalyst_id} Catalyst ID is already used"),
                "It isn't allowed to use same stake address in multiple registration chains",
            );
            return Err(RbacCacheAddError {
                catalyst_id: Some(catalyst_id),
                purpose,
                report,
            });
        },
    }

    // Everything is fine: update caches.
    for address in new_addresses {
        ACTIVE_ADDRESSES.insert(address.clone(), catalyst_id.clone());
    }
    TRANSACTIONS.insert(new_chain.current_tx_id_hash(), catalyst_id.clone());
    CHAIN_TRANSACTIONS.insert(catalyst_id.clone(), vec![new_chain.current_tx_id_hash()]);
    CHAINS.insert(catalyst_id.clone(), new_chain);

    Ok(RbacCacheAddSuccess {
        catalyst_id,
        // A valid registration must have a purpose.
        #[allow(clippy::expect_used)]
        purpose: purpose.expect("Missing registration purpose"),
    })
}
