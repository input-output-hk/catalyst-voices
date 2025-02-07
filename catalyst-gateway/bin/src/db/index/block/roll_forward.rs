//! Immutable Roll Forward logic.

use std::{collections::HashSet, sync::Arc};

use cardano_blockchain_types::{Slot, TransactionHash};
use futures::StreamExt;

use crate::{
    db::index::{block::CassandraSession, queries::purge},
    settings::Settings,
};

/// Purge Data from Live Index
pub(crate) async fn purge_live_index(purge_slot: Slot) -> anyhow::Result<()> {
    let persistent = false; // get volatile session
    let Some(session) = CassandraSession::get(persistent) else {
        anyhow::bail!("Failed to acquire db session");
    };

    // Purge data up to this slot
    let purge_to_slot = purge_slot - Settings::purge_slot_buffer();

    let txn_hashes = purge_txi_by_hash(&session, purge_to_slot).await?;
    purge_chain_root_for_stake_address(&session, purge_to_slot).await?;
    purge_chain_root_for_txn_id(&session, &txn_hashes).await?;
    purge_cip36_registration(&session, purge_to_slot).await?;
    purge_cip36_registration_for_vote_key(&session, purge_to_slot).await?;
    purge_cip36_registration_invalid(&session, purge_to_slot).await?;
    purge_rbac509_registration(&session, purge_to_slot).await?;
    purge_stake_registration(&session, purge_to_slot).await?;
    purge_txo_ada(&session, purge_to_slot).await?;
    purge_txo_assets(&session, purge_to_slot).await?;
    purge_unstaked_txo_ada(&session, purge_to_slot).await?;
    purge_unstaked_txo_assets(&session, purge_to_slot).await?;

    Ok(())
}

/// Purge data from `chain_root_for_stake_address`.
async fn purge_chain_root_for_stake_address(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::chain_root_for_stake_address::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if params.slot_no <= purge_to_slot.into() {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `chain_root_for_txn_id`.
async fn purge_chain_root_for_txn_id(
    session: &Arc<CassandraSession>, txn_hashes: &HashSet<TransactionHash>,
) -> anyhow::Result<()> {
    use purge::catalyst_id_for_txn_id::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if txn_hashes.contains(&params.transaction_id.into()) {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `cip36_registration`.
async fn purge_cip36_registration(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::cip36_registration::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if params.slot_no <= purge_to_slot.into() {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `cip36_registration_for_vote_key`.
async fn purge_cip36_registration_for_vote_key(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::cip36_registration_for_vote_key::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if params.slot_no <= purge_to_slot.into() {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `cip36_registration_invalid`.
async fn purge_cip36_registration_invalid(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::cip36_registration_invalid::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if params.slot_no <= purge_to_slot.into() {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `rbac509_registration`.
async fn purge_rbac509_registration(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::rbac509_registration::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if params.slot_no <= purge_to_slot.into() {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `stake_registration`.
async fn purge_stake_registration(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::stake_registration::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if params.slot_no <= purge_to_slot.into() {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `txi_by_hash`.
async fn purge_txi_by_hash(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<HashSet<TransactionHash>> {
    use purge::txi_by_hash::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    let mut txn_hashes: HashSet<TransactionHash> = HashSet::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if primary_key.2 <= purge_to_slot.into() {
            let params: Params = primary_key.into();
            txn_hashes.insert(params.txn_hash.clone().into());
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(txn_hashes)
}

/// Purge data from `txo_ada`.
async fn purge_txo_ada(session: &Arc<CassandraSession>, purge_to_slot: Slot) -> anyhow::Result<()> {
    use purge::txo_ada::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if params.slot_no <= purge_to_slot.into() {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `txo_assets`.
async fn purge_txo_assets(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::txo_assets::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if params.slot_no <= purge_to_slot.into() {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `unstaked_txo_ada`.
async fn purge_unstaked_txo_ada(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::unstaked_txo_ada::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if primary_key.2 <= purge_to_slot.into() {
            let params: Params = primary_key.into();
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `unstaked_txo_assets`.
async fn purge_unstaked_txo_assets(
    session: &Arc<CassandraSession>, purge_to_slot: Slot,
) -> anyhow::Result<()> {
    use purge::unstaked_txo_assets::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if primary_key.4 <= purge_to_slot.into() {
            let params: Params = primary_key.into();
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}
