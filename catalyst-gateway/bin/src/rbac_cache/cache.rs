//! A cache for RBAC registrations.

use cardano_blockchain_types::{StakeAddress, TransactionId};
use catalyst_types::{
    catalyst_id::{role_index::RoleId, CatalystId},
    problem_report::ProblemReport,
};
use ed25519_dalek::VerifyingKey;
use moka::{policy::EvictionPolicy, sync::Cache};
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};
use tracing::{debug, error};

use crate::rbac_cache::add_result::{AddResult, RbacCacheAddError, RbacCacheAddSuccess};

/// A cache for RBAC registrations.
pub struct RbacCache {
    /// A cache of valid RBAC registration chains.
    chains: Cache<CatalystId, RegistrationChain>,
    /// A cache of active stake addresses.
    ///
    /// An address considered active if it is used by any of valid RBAC chains.
    active_addresses: Cache<StakeAddress, CatalystId>,
    /// A cache that allows to find a Catalyst ID of the previous registration using its
    /// transaction identifier (hash).
    transactions: Cache<TransactionId, CatalystId>,
    /// A cache of role 0 signing (certificate subject public) keys.
    ///
    /// Once a key is used in one of the chains it isn't allowed to use it in any other
    /// chain. This cache is used to enforce that rule. A Catalyst ID value is used to
    /// allow reuse of a key by the chain where it was originally used.
    public_keys: Cache<VerifyingKey, CatalystId>,
}

impl RbacCache {
    /// Creates a new `RbacCache` instance.
    pub fn new() -> Self {
        let chains = Cache::builder()
            .eviction_policy(EvictionPolicy::lru())
            .build();
        let active_addresses = Cache::builder()
            .eviction_policy(EvictionPolicy::lru())
            .build();
        let transactions = Cache::builder()
            .eviction_policy(EvictionPolicy::lru())
            .build();
        let public_keys = Cache::builder()
            .eviction_policy(EvictionPolicy::lru())
            .build();

        Self {
            chains,
            active_addresses,
            transactions,
            public_keys,
        }
    }

    /// Adds the given registration to one of the existing chains or starts a new one.
    ///
    /// In case of failure a problem report from the given registration is updated and
    /// returned.
    #[allow(clippy::result_large_err)]
    pub fn add(&self, registration: Cip509) -> AddResult {
        match registration.previous_transaction() {
            Some(previous_txn) => self.update_chain(registration, previous_txn),
            None => self.start_new_chain(registration),
        }
    }

    /// Returns a registration chain by the given Catalyst ID.
    pub fn get(&self, id: &CatalystId) -> Option<RegistrationChain> {
        self.chains.get(id)
    }

    /// Returns a registration chain by the stake address.
    pub fn get_by_address(&self, address: &StakeAddress) -> Option<RegistrationChain> {
        let id = self.active_addresses.get(address)?;
        self.get(&id)
    }

    /// Returns a list of active stake addresses of the given registration chain.
    ///
    /// One or all addresses of the chain can be "taken" by another "restarting"
    /// registration. See [RBAC examples] for more details.
    ///
    /// [RBAC examples]: https://github.com/input-output-hk/catalyst-libs/blob/main/rust/rbac-registration/examples.md
    pub fn active_stake_addresses(&self, id: &CatalystId) -> Vec<StakeAddress> {
        let Some(chain) = self.get(id) else {
            return Vec::new();
        };

        chain
            .role_0_stake_addresses()
            .into_iter()
            .filter(|address| self.active_addresses.get(address).as_ref() == Some(id))
            .collect()
    }

    /// Applies the given registration to one of the existing chains.
    #[allow(clippy::result_large_err)]
    fn update_chain(
        &self, registration: Cip509, previous_txn: TransactionId,
    ) -> Result<RbacCacheAddSuccess, RbacCacheAddError> {
        let purpose = registration.purpose();
        let report = registration.report().to_owned();

        // Find a chain this registration belongs to.
        let catalyst_id = self.transactions.get(&previous_txn).ok_or_else(|| {
            debug!("Unable to find previous transaction {previous_txn} in the RBAC cache");
            // We are unable to determine a Catalyst ID, so there is no sense to update the
            // problem report because we would be unable to store this registration anyway.
            RbacCacheAddError::UnknownCatalystId
        })?;
        let chain = self.chains.get(&catalyst_id).ok_or_else(|| {
            // This means the cache is broken. This should never normally happen.
            error!("Broken RBAC cache: {catalyst_id} is present in TRANSACTIONS cache, but missing in CHAINS");
            RbacCacheAddError::InvalidRegistration {
                catalyst_id: catalyst_id.clone(),
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
            if self.active_addresses.get(address).is_some() {
                report.functional_validation(
                    &format!("{address} stake addresses is already used"),
                    "It isn't allowed to use same stake address in multiple registration chains",
                );
            }
        }

        // Try to add a new registration to the chain.
        let new_chain = chain.update(registration).map_err(|e| {
            report.other(
                &format!("{e:?}"),
                "Failed to apply update the registration chain",
            );
            RbacCacheAddError::InvalidRegistration {
                catalyst_id: catalyst_id.clone(),
                purpose,
                report: report.clone(),
            }
        })?;

        self.verify_public_keys(&new_chain, &report);

        if report.is_problematic() {
            return Err(RbacCacheAddError::InvalidRegistration {
                catalyst_id,
                purpose,
                report,
            });
        }

        // Everything is fine: update caches.
        for address in new_addresses {
            self.active_addresses
                .insert(address.to_owned(), catalyst_id.clone());
        }
        self.transactions
            .insert(new_chain.current_tx_id_hash(), catalyst_id.clone());
        if let Some((key, _)) = new_chain.get_latest_signing_pk_for_role(&RoleId::Role0) {
            self.public_keys.insert(key, catalyst_id.clone());
        }
        self.chains.insert(catalyst_id.clone(), new_chain);

        Ok(RbacCacheAddSuccess { catalyst_id })
    }

    /// Starts a new Rbac registration chain.
    #[allow(clippy::result_large_err)]
    fn start_new_chain(
        &self, registration: Cip509,
    ) -> Result<RbacCacheAddSuccess, RbacCacheAddError> {
        let catalyst_id = registration.catalyst_id().cloned();
        let purpose = registration.purpose();
        let report = registration.report().to_owned();

        let new_chain = RegistrationChain::new(registration).map_err(|e| {
            report.other(
                &format!("{e:?}"),
                "Failed to apply start a registration chain",
            );
            if let Some(catalyst_id) = catalyst_id {
                RbacCacheAddError::InvalidRegistration {
                    catalyst_id,
                    purpose,
                    report: report.clone(),
                }
            } else {
                RbacCacheAddError::UnknownCatalystId
            }
        })?;
        let catalyst_id = new_chain.catalyst_id().to_owned();
        if self.chains.get(&catalyst_id).is_some() {
            report.functional_validation(
                &format!("{catalyst_id} is already used"),
                "It isn't allowed to use same Catalyst ID (certificate subject public key) in multiple registration chains",
            );
            return Err(RbacCacheAddError::InvalidRegistration {
                catalyst_id,
                purpose,
                report,
            });
        }

        let new_addresses = new_chain.role_0_stake_addresses();
        for address in &new_addresses {
            if let Some(id) = self.active_addresses.get(address) {
                let previous_chain = self.chains.get(&id).ok_or_else(|| {
                    // This means the cache is broken. This should never normally happen.
                    error!("Broken RBAC cache: {id} is present in ACTIVE_ADDRESSES cache, but missing in CHAINS");
                    RbacCacheAddError::InvalidRegistration {
                        catalyst_id: catalyst_id.clone(),
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
                }
            }
        }

        self.verify_public_keys(&new_chain, &report);

        if report.is_problematic() {
            return Err(RbacCacheAddError::InvalidRegistration {
                catalyst_id,
                purpose,
                report,
            });
        }

        // Everything is fine: update caches.
        for address in new_addresses {
            self.active_addresses
                .insert(address.clone(), catalyst_id.clone());
        }
        self.transactions
            .insert(new_chain.current_tx_id_hash(), catalyst_id.clone());
        if let Some((key, _)) = new_chain.get_latest_signing_pk_for_role(&RoleId::Role0) {
            self.public_keys.insert(key, catalyst_id.clone());
        } else {
            // A root registration should always contain role 0 with a signing key. The registration
            // must already be validated, so this should never happen.
            error!("{catalyst_id} root registration doesn't have a signing key");
        }
        self.chains.insert(catalyst_id.clone(), new_chain);

        Ok(RbacCacheAddSuccess { catalyst_id })
    }

    /// Checks that a new registration doesn't contain a signing key that was used by any
    /// other chain.
    fn verify_public_keys(&self, new_chain: &RegistrationChain, report: &ProblemReport) {
        if let Some((key, _)) = new_chain.get_latest_signing_pk_for_role(&RoleId::Role0) {
            if let Some(previous) = self.public_keys.get(&key) {
                if &previous != new_chain.catalyst_id() {
                    report.functional_validation(
                        &format!("An update to {} registration chain uses the same public key ({key:?}) as {previous} chain",
                            new_chain.catalyst_id()),
                        "It isn't allowed to use role 0 signing (certificate subject public) key in different chains",
                    );
                }
            }
        }
    }
}
