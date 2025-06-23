//! Utilities for obtaining a RBAC registration chain (`RegistrationChain`).

use anyhow::{Context, Result};
use cardano_blockchain_types::{Network, Point, Slot, StakeAddress, TxnIndex};
use cardano_chain_follower::ChainFollower;
use catalyst_types::catalyst_id::CatalystId;
use futures::{future::try_join, FutureExt, StreamExt, TryFutureExt, TryStreamExt};
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};

use crate::{
    db::index::{
        queries::rbac::{
            get_catalyst_id_from_stake_address::Query as CatalystIdQuery,
            get_rbac_registrations::{Query as RbacQuery, QueryParams as RbacQueryParams},
        },
        session::CassandraSession,
    },
    rbac::{cache_persistent_rbac_chain, chains_cache::cached_persistent_rbac_chain},
    settings::Settings,
};

/// Returns the latest (including the volatile part) registration chain by the given
/// Catalyst ID.
pub async fn latest_rbac_chain(id: &CatalystId) -> Result<Option<RegistrationChain>> {
    let persistent_session =
        CassandraSession::get(true).context("Failed to get persistent Cassandra session")?;
    let volatile_session =
        CassandraSession::get(false).context("Failed to get volatile Cassandra session")?;
    let (persistent_regs, volatile_regs) = try_join(
        indexed_regs(&persistent_session, id),
        indexed_regs(&volatile_session, id),
    )
    .await?;
    let regs = persistent_regs.into_iter().chain(volatile_regs.into_iter());
    build_rbac_chain(regs).await
}

/// Returns the latest (including the volatile part) registration chain by the given stake
/// address.
pub async fn latest_rbac_chain_by_address(
    address: &StakeAddress,
) -> Result<Option<RegistrationChain>> {
    let persistent_session =
        CassandraSession::get(true).context("Failed to get persistent Cassandra session")?;
    let volatile_session =
        CassandraSession::get(false).context("Failed to get volatile Cassandra session")?;

    let id = match CatalystIdQuery::latest(&volatile_session, address.clone()).await? {
        Some(id) => id.catalyst_id,
        None => {
            match CatalystIdQuery::latest(&persistent_session, address.clone()).await? {
                Some(id) => id.catalyst_id,
                None => return Ok(None),
            }
        },
    };

    latest_rbac_chain(&id).await
}

/// Returns only the persistent part of a registration chain by the given Catalyst ID.
pub async fn persistent_rbac_chain(id: &CatalystId) -> Result<Option<RegistrationChain>> {
    if let Some(chain) = cached_persistent_rbac_chain(id) {
        return Ok(Some(chain));
    }

    let session = CassandraSession::get(true).context("Failed to get Cassandra session")?;

    let regs = indexed_regs(&session, id).await?;
    let chain = build_rbac_chain(regs).await?.inspect(|c| {
        cache_persistent_rbac_chain(id.clone(), c.clone());
    });
    Ok(chain)
}

/// Queries indexed RBAC registrations from the database.
async fn indexed_regs(session: &CassandraSession, id: &CatalystId) -> Result<Vec<RbacQuery>> {
    RbacQuery::execute(session, RbacQueryParams {
        catalyst_id: id.clone().into(),
    })
    .and_then(|r| r.try_collect().map_err(Into::into))
    .await
}

/// Builds a chain from the given registrations.
async fn build_rbac_chain(
    regs: impl IntoIterator<Item = RbacQuery>,
) -> Result<Option<RegistrationChain>> {
    let mut regs = regs.into_iter();
    let Some(root) = regs.next() else {
        return Ok(None);
    };
    let network = Settings::cardano_network();
    let root = cip509(network, root.slot_no.into(), root.txn_index.into()).await?;

    let mut chain = RegistrationChain::new(root)?;

    for reg in regs {
        let reg = cip509(network, reg.slot_no.into(), reg.txn_index.into()).await?;
        chain = chain.update(reg)?;
    }

    Ok(Some(chain))
}

/// Loads and parses a `Cip509` registration from a block using chain follower.
async fn cip509(network: Network, slot: Slot, txn_index: TxnIndex) -> Result<Cip509> {
    let point = Point::fuzzy(slot);
    let block = ChainFollower::get_block(network, point)
        .await
        .context("Unable to get block")?
        .data;
    if block.point().slot_or_default() != slot {
        // The `ChainFollower::get_block` function can return the next consecutive block if it
        // cannot find the exact one. This shouldn't happen, but we need to check anyway.
        anyhow::bail!(
            "Unable to find exact {slot:?} block. Found block slot {:?}",
            block.point().slot_or_default()
        );
    }
    // We perform validation during indexing, so this normally should never fail.
    Cip509::new(&block, txn_index, &[])
        .with_context(|| {
            format!("Invalid RBAC registration, slot = {slot:?}, transaction index = {txn_index:?}")
        })?
        .with_context(|| {
            format!("No RBAC registration, slot = {slot:?}, transaction index = {txn_index:?}")
        })
}
