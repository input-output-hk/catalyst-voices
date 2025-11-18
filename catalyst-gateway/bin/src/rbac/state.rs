use std::collections::{HashMap, HashSet};

use anyhow::Context;
use cardano_chain_follower::StakeAddress;
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

pub(crate) struct RbacChainsState<'a> {
    is_persistent: bool,
    context: Option<&'a RbacBlockIndexingContext>,
    modified_chains: HashMap<CatalystId, HashSet<StakeAddress>>,
}

impl<'a> RbacChainsState<'a> {
    pub fn new(
        is_persistent: bool,
        context: Option<&'a RbacBlockIndexingContext>,
    ) -> Self {
        Self {
            is_persistent,
            context,
            modified_chains: HashMap::new(),
        }
    }

    pub fn consume(self) -> HashMap<CatalystId, HashSet<StakeAddress>> {
        self.modified_chains
    }
}

impl rbac_registration::cardano::state::RbacChainsState for RbacChainsState<'_> {
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
        if let Some(context) = self.context {
            if let Some(regs) = context.find_registrations(id) {
                let regs = regs.iter().cloned();
                match chain {
                    Some(c) => return apply_regs(c, regs).await.map(Some),
                    None => return build_rbac_chain(regs).await,
                }
            }
        }
        Ok(chain)
    }

    async fn is_chain_known(
        &self,
        id: &CatalystId,
    ) -> anyhow::Result<bool> {
        if let Some(context) = self.context {
            if context.find_registrations(id).is_some() {
                return Ok(true);
            }
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

    async fn is_stake_address_used(
        &self,
        address: &StakeAddress,
    ) -> anyhow::Result<bool> {
        catalyst_id_from_stake_address(address, self.is_persistent, self.context)
            .await
            .map(|v| v.is_some())
    }

    async fn chain_catalyst_id_from_signing_pk(
        &self,
        key: &VerifyingKey,
    ) -> anyhow::Result<Option<CatalystId>> {
        use crate::db::index::queries::rbac::get_catalyst_id_from_public_key::Query;

        // Check the context first.
        if let Some(context) = self.context {
            if let Some(catalyst_id) = context.find_public_key(&key) {
                return Ok(Some(catalyst_id.to_owned()));
            }
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

    async fn take_stake_address_from_chains(
        &mut self,
        addresses: impl Iterator<Item = cardano_chain_follower::StakeAddress> + Send,
    ) -> anyhow::Result<()> {
        for addr in addresses {
            if let Some(cat_id) =
                catalyst_id_from_stake_address(&addr, self.is_persistent, self.context).await?
            {
                self.modified_chains
                    .entry(cat_id)
                    .and_modify(|e| {
                        e.insert(addr.clone());
                    })
                    .or_insert([addr.clone()].into_iter().collect());
            }
        }

        Ok(())
    }
}

async fn catalyst_id_from_stake_address(
    address: &StakeAddress,
    is_persistent: bool,
    context: Option<&RbacBlockIndexingContext>,
) -> anyhow::Result<Option<CatalystId>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_stake_address::Query;

    // Check the context first.
    if let Some(context) = context {
        if let Some(catalyst_id) = context.find_address(address) {
            return Ok(Some(catalyst_id.to_owned()));
        }
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
