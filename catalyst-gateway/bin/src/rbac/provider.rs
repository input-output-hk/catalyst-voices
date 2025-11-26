//! An implementation of the `rbac_registration::cardano::state::RbacChainsState` trait

use anyhow::Context;
use cardano_chain_follower::{StakeAddress, hashes::TransactionId};
use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;
use futures::StreamExt;

use crate::{
    db::index::session::CassandraSession,
    rbac::{
        RbacBlockIndexingContext,
        chains_cache::cached_persistent_rbac_chain,
        get_chain::{apply_regs, build_rbac_chain, persistent_rbac_chain},
        latest_rbac_chain,
    },
};

/// A helper struct to handle RBAC related state from the DB and caches.
/// Implements `rbac_registration::cardano::state::RbacChainsState` trait.
pub(crate) struct RbacChainsProvider<'a> {
    /// `index-db` corresponding flag
    is_persistent: bool,
    /// `RbacBlockIndexingContext` reference
    context: &'a RbacBlockIndexingContext,
}

impl<'a> RbacChainsProvider<'a> {
    /// Creates a new instance of `RbacChainsState`
    pub fn new(
        is_persistent: bool,
        context: &'a RbacBlockIndexingContext,
    ) -> Self {
        Self {
            is_persistent,
            context,
        }
    }

    /// Returns a Catalyst ID corresponding to the given transaction hash.
    pub async fn catalyst_id_from_txn_id(
        &self,
        txn_id: TransactionId,
    ) -> anyhow::Result<Option<CatalystId>> {
        use crate::db::index::queries::rbac::get_catalyst_id_from_transaction_id::Query;

        // Check the context first.
        if let Some(catalyst_id) = self.context.find_transaction(&txn_id) {
            return Ok(Some(catalyst_id.to_owned()));
        }

        // Then try to find in the persistent database.
        let session =
            CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
        if let Some(id) = Query::get(&session, txn_id).await? {
            return Ok(Some(id));
        }

        // Conditionally check the volatile database.
        if !self.is_persistent {
            let session =
                CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
            return Query::get(&session, txn_id).await;
        }

        Ok(None)
    }
}

impl rbac_registration::cardano::provider::RbacChainsProvider for RbacChainsProvider<'_> {
    async fn chain(
        &self,
        id: &CatalystId,
    ) -> anyhow::Result<Option<rbac_registration::registration::cardano::RegistrationChain>> {
        let chain = if self.is_persistent {
            persistent_rbac_chain(id).await?
        } else {
            latest_rbac_chain(id).await?.map(|i| i.chain)
        };

        // Apply additional registrations from context if any.
        if let Some(regs) = self.context.find_registrations(id) {
            let regs = regs.iter().cloned();
            match chain {
                Some(c) => return apply_regs(c, regs).await.map(Some),
                None => return build_rbac_chain(regs).await,
            }
        }

        Ok(chain)
    }

    async fn is_chain_known(
        &self,
        id: &CatalystId,
    ) -> anyhow::Result<bool> {
        if self.context.find_registrations(id).is_some() {
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
        if !self.is_persistent {
            let session =
                CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
            if is_cat_id_known(&session, id).await? {
                return Ok(true);
            }
        }

        Ok(false)
    }

    async fn chain_catalyst_id_from_stake_address(
        &self,
        address: &StakeAddress,
    ) -> anyhow::Result<Option<CatalystId>> {
        use crate::db::index::queries::rbac::get_catalyst_id_from_stake_address::Query;

        // Check the context first.
        if let Some(catalyst_id) = self.context.find_address(address) {
            return Ok(Some(catalyst_id.to_owned()));
        }

        // Then try to find in the persistent database.
        let session =
            CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
        if let Some(id) = Query::latest(&session, address).await? {
            return Ok(Some(id));
        }

        // Conditionally check the volatile database.
        if !self.is_persistent {
            let session =
                CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
            return Query::latest(&session, address).await;
        }

        Ok(None)
    }

    async fn chain_catalyst_id_from_signing_public_key(
        &self,
        key: &VerifyingKey,
    ) -> anyhow::Result<Option<CatalystId>> {
        use crate::db::index::queries::rbac::get_catalyst_id_from_public_key::Query;

        // Check the context first.
        if let Some(catalyst_id) = self.context.find_public_key(key) {
            return Ok(Some(catalyst_id.to_owned()));
        }

        // Then try to find in the persistent database.
        let session =
            CassandraSession::get(true).context("Failed to get Cassandra persistent session")?;
        if let Some(id) = Query::get(&session, *key).await? {
            return Ok(Some(id));
        }

        // Conditionally check the volatile database.
        if !self.is_persistent {
            let session =
                CassandraSession::get(false).context("Failed to get Cassandra volatile session")?;
            return Query::get(&session, *key).await;
        }

        Ok(None)
    }
}

/// Returns `true` if there is at least one registration with the given Catalyst ID.
async fn is_cat_id_known(
    session: &CassandraSession,
    id: &CatalystId,
) -> anyhow::Result<bool> {
    use crate::db::index::queries::rbac::get_rbac_registrations::{Query, QueryParams};

    Ok(Query::execute(session, QueryParams {
        catalyst_id: id.clone().into(),
    })
    .await?
    .next()
    .await
    .is_some())
}
