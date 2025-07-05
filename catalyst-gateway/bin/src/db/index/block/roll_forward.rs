//! Immutable Roll Forward logic.

use std::sync::Arc;

use cardano_blockchain_types::Slot;
use futures::StreamExt;

use crate::db::index::{
    block::CassandraSession,
    queries::{
        purge,
        rbac::{
            get_catalyst_id_from_public_key::invalidate_public_keys_cache,
            get_catalyst_id_from_stake_address::invalidate_stake_addresses_cache,
            get_catalyst_id_from_transaction_id::invalidate_transactions_ids_cache,
        },
    },
};

/// Purge condition option
#[derive(Debug, Clone, Copy, PartialEq)]
pub(crate) enum PurgeCondition {
    /// Purge all data before the provided slot number (including)
    PurgeBackwards(Slot),
    /// Purge all data after the provided slot number (including)
    PurgeForwards(Slot),
}

impl PurgeCondition {
    /// A filtering condition of the `PurgeOption` and provided `slot` value
    fn filter(&self, slot: Slot) -> bool {
        match self {
            Self::PurgeBackwards(purge_to_slot) => &slot <= purge_to_slot,
            Self::PurgeForwards(purge_to_slot) => &slot >= purge_to_slot,
        }
    }
}

/// Purge cardano Live Index data from the volatile db session
pub(crate) async fn purge_live_index(purge_condition: PurgeCondition) -> anyhow::Result<()> {
    let persistent = false; // get volatile session
    let Some(session) = CassandraSession::get(persistent) else {
        anyhow::bail!("Failed to acquire db session");
    };

    purge_txi_by_hash(&session, purge_condition).await?;
    purge_cip36_registration(&session, purge_condition).await?;
    purge_cip36_registration_for_vote_key(&session, purge_condition).await?;
    purge_cip36_registration_invalid(&session, purge_condition).await?;
    purge_rbac509_registration(&session, purge_condition).await?;
    purge_invalid_rbac509_registration(&session, purge_condition).await?;
    purge_catalyst_id_for_stake_address(&session, purge_condition).await?;
    purge_catalyst_id_for_txn_id(&session, purge_condition).await?;
    purge_catalyst_id_for_public_key(&session, purge_condition).await?;
    purge_stake_registration(&session, purge_condition).await?;
    purge_txo_ada(&session, purge_condition).await?;
    purge_txo_assets(&session, purge_condition).await?;
    purge_unstaked_txo_ada(&session, purge_condition).await?;
    purge_unstaked_txo_assets(&session, purge_condition).await?;

    Ok(())
}

/// Purge data from `txi_by_hash`.
async fn purge_txi_by_hash(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::txi_by_hash::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if purge_condition.filter(primary_key.2.into()) {
            let params: Params = primary_key.into();
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `cip36_registration`.
async fn purge_cip36_registration(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::cip36_registration::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if purge_condition.filter(params.slot_no.into()) {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `cip36_registration_for_vote_key`.
async fn purge_cip36_registration_for_vote_key(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::cip36_registration_for_vote_key::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if purge_condition.filter(params.slot_no.into()) {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `cip36_registration_invalid`.
async fn purge_cip36_registration_invalid(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::cip36_registration_invalid::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if purge_condition.filter(params.slot_no.into()) {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `rbac509_registration`.
async fn purge_rbac509_registration(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::rbac509_registration::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if purge_condition.filter(primary_key.1.into()) {
            delete_params.push(primary_key.into());
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purges the data from `rbac509_invalid_registration`.
async fn purge_invalid_rbac509_registration(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::rbac509_invalid_registration::{DeleteQuery, Params, PrimaryKeyQuery};

    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if purge_condition.filter(primary_key.2.into()) {
            delete_params.push(primary_key.into());
        }
    }

    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purges the data from the `catalyst_id_for_stake_address` table.
async fn purge_catalyst_id_for_stake_address(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::catalyst_id_for_stake_address::{DeleteQuery, Params, PrimaryKeyQuery};

    invalidate_stake_addresses_cache(false);

    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;

    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if purge_condition.filter(primary_key.1.into()) {
            delete_params.push(primary_key.into());
        }
    }

    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purges the data from the `catalyst_id_for_txn_id` table.
async fn purge_catalyst_id_for_txn_id(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::catalyst_id_for_txn_id::{DeleteQuery, Params, PrimaryKeyQuery};

    invalidate_transactions_ids_cache(false);

    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;

    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if purge_condition.filter(primary_key.1.into()) {
            delete_params.push(primary_key.into());
        }
    }

    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purges the data from the `catalyst_id_for_public_key` table.
async fn purge_catalyst_id_for_public_key(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::catalyst_id_for_public_key::{DeleteQuery, Params, PrimaryKeyQuery};

    invalidate_public_keys_cache(false);

    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;

    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if purge_condition.filter(primary_key.1.into()) {
            delete_params.push(primary_key.into());
        }
    }

    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `stake_registration`.
async fn purge_stake_registration(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::stake_registration::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if purge_condition.filter(params.slot_no.into()) {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `txo_ada`.
async fn purge_txo_ada(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::txo_ada::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if purge_condition.filter(params.slot_no.into()) {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `txo_assets`.
async fn purge_txo_assets(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::txo_assets::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        let params: Params = primary_key.into();
        if purge_condition.filter(params.slot_no.into()) {
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}

/// Purge data from `unstaked_txo_ada`.
async fn purge_unstaked_txo_ada(
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::unstaked_txo_ada::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if purge_condition.filter(primary_key.2.clone().into()) {
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
    session: &Arc<CassandraSession>, purge_condition: PurgeCondition,
) -> anyhow::Result<()> {
    use purge::unstaked_txo_assets::{DeleteQuery, Params, PrimaryKeyQuery};

    // Get all keys
    let mut primary_keys_stream = PrimaryKeyQuery::execute(session).await?;
    // Filter
    let mut delete_params: Vec<Params> = Vec::new();
    while let Some(Ok(primary_key)) = primary_keys_stream.next().await {
        if purge_condition.filter(primary_key.4.clone().into()) {
            let params: Params = primary_key.into();
            delete_params.push(params);
        }
    }
    // Delete filtered keys
    DeleteQuery::execute(session, delete_params).await?;
    Ok(())
}
