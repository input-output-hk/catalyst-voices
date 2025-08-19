//! Utilities for obtaining a RBAC registration chain (`RegistrationChain`).

use anyhow::{bail, Context, Result};
use cardano_chain_follower::{ChainFollower, Network, Point, Slot, StakeAddress, TxnIndex};
use catalyst_types::catalyst_id::CatalystId;
use futures::{future::try_join, TryFutureExt, TryStreamExt};
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};

use crate::{
    db::index::{
        queries::rbac::{
            get_catalyst_id_from_stake_address::Query as CatalystIdQuery,
            get_rbac_registrations::{Query as RbacQuery, QueryParams as RbacQueryParams},
        },
        session::CassandraSession,
    },
    rbac::{
        chains_cache::{cache_persistent_rbac_chain, cached_persistent_rbac_chain},
        ChainInfo,
    },
    settings::Settings,
};

/// Returns the latest (including the volatile part) registration chain by the given
/// Catalyst ID.
pub async fn latest_rbac_chain(id: &CatalystId) -> Result<Option<ChainInfo>> {
    let id = id.as_short_id();

    let volatile_session =
        CassandraSession::get(false).context("Failed to get volatile Cassandra session")?;
    // Get the persistent part of the chain and volatile registrations. Both of these parts
    // can be non-existing.
    let (chain, volatile_regs) = try_join(
        persistent_rbac_chain(&id),
        indexed_regs(&volatile_session, &id),
    )
    .await?;

    let mut last_persistent_txn = None;
    let mut last_persistent_slot = 0.into();

    // Either update the persistent chain or build a new one.
    let chain = match chain {
        Some(c) => {
            last_persistent_txn = Some(c.current_tx_id_hash());
            last_persistent_slot = c.current_point().slot_or_default();
            Some(apply_regs(c, volatile_regs).await?)
        },
        None => build_rbac_chain(volatile_regs).await?,
    };

    Ok(chain.map(|chain| {
        let last_txn = Some(chain.current_tx_id_hash());
        // If the last persistent transaction ID is the same as the last one, then there are no
        // volatile registrations in this chain.
        let last_volatile_txn = if last_persistent_txn == last_txn {
            None
        } else {
            last_txn
        };

        ChainInfo {
            chain,
            last_persistent_txn,
            last_volatile_txn,
            last_persistent_slot,
        }
    }))
}

/// Returns the latest (including the volatile part) registration chain by the given stake
/// address.
pub async fn latest_rbac_chain_by_address(address: &StakeAddress) -> Result<Option<ChainInfo>> {
    let persistent_session =
        CassandraSession::get(true).context("Failed to get persistent Cassandra session")?;
    let volatile_session =
        CassandraSession::get(false).context("Failed to get volatile Cassandra session")?;

    // We always check the latest (volatile) data first.
    let id = match CatalystIdQuery::latest(&volatile_session, address).await? {
        Some(id) => id,
        None => {
            match CatalystIdQuery::latest(&persistent_session, address).await? {
                Some(id) => id,
                None => return Ok(None),
            }
        },
    };

    latest_rbac_chain(&id).await
}

/// Returns only the persistent part of a registration chain by the given Catalyst ID.
pub async fn persistent_rbac_chain(id: &CatalystId) -> Result<Option<RegistrationChain>> {
    let id = id.as_short_id();

    if let Some(chain) = cached_persistent_rbac_chain(&id) {
        return Ok(Some(chain));
    }

    let session = CassandraSession::get(true).context("Failed to get Cassandra session")?;

    let regs = indexed_regs(&session, &id).await?;
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
pub async fn build_rbac_chain(
    regs: impl IntoIterator<Item = RbacQuery>,
) -> Result<Option<RegistrationChain>> {
    let mut regs = regs.into_iter();
    let Some(root) = regs.next() else {
        return Ok(None);
    };
    if !root.removed_stake_addresses.is_empty() {
        // This set contains addresses that were removed from the chain. It is impossible to
        // remove an address before the chain was even started.
        bail!("The root registration shouldn't contain removed stake addresses");
    }
    let root = cip509(
        Settings::cardano_network(),
        root.slot_no.into(),
        root.txn_index.into(),
    )
    .await?;

    let chain = RegistrationChain::new(root).context("Failed to start registration chain")?;
    let chain = apply_regs(chain, regs).await?;
    Ok(Some(chain))
}

/// Applies the given registration to the given chain.
pub async fn apply_regs(
    mut chain: RegistrationChain, regs: impl IntoIterator<Item = RbacQuery>,
) -> Result<RegistrationChain> {
    let network = Settings::cardano_network();

    for reg in regs {
        if !reg.removed_stake_addresses.is_empty() {
            // TODO: This should be handled as a part of the
            // https://github.com/input-output-hk/catalyst-voices/issues/2599 task.
            continue;
        }
        let reg = cip509(network, reg.slot_no.into(), reg.txn_index.into()).await?;
        chain = chain
            .update(reg)
            .context("Failed to update registration chain")?;
    }

    Ok(chain)
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
        bail!(
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
