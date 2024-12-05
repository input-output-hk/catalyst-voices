//! Immutable Roll Forward logic.

use crate::{
    db::index::{block::CassandraSession, queries::purge},
    settings::Settings,
};

/// Purge Data from Live Index
#[allow(unused_variables)]
pub(crate) async fn purge_live_index(purge_slot: u64) -> anyhow::Result<()> {
    let persistent = false; // get volatile session
    let Some(session) = CassandraSession::get(persistent) else {
        anyhow::bail!("Failed to acquire db session");
    };

    let chain_root_for_role0_keys =
        purge::chain_root_for_role0_key::PrimaryKeyQuery::execute(&session).await?;
    let chain_root_for_stake_address_keys =
        purge::chain_root_for_stake_address::PrimaryKeyQuery::execute(&session).await?;
    let chain_root_for_txn_id_keys =
        purge::chain_root_for_txn_id::PrimaryKeyQuery::execute(&session).await?;
    let cip36_registration_keys =
        purge::cip36_registration::PrimaryKeyQuery::execute(&session).await?;
    let cip36_registration_for_vote_keys =
        purge::cip36_registration_for_vote_key::PrimaryKeyQuery::execute(&session).await?;
    let cip36_registration_invalid_keys =
        purge::cip36_registration_invalid::PrimaryKeyQuery::execute(&session).await?;
    let rbac509_registration_keys =
        purge::rbac509_registration::PrimaryKeyQuery::execute(&session).await?;
    let stake_registration_keys =
        purge::stake_registration::PrimaryKeyQuery::execute(&session).await?;
    let txi_by_hash_keys = purge::txi_by_hash::PrimaryKeyQuery::execute(&session).await?;
    let txo_ada_keys = purge::txo_ada::PrimaryKeyQuery::execute(&session).await?;
    let txo_assets_keys = purge::txo_assets::PrimaryKeyQuery::execute(&session).await?;
    let unstaked_txo_ada_keys = purge::unstaked_txo_ada::PrimaryKeyQuery::execute(&session).await?;
    let unstaked_txo_assets_keys =
        purge::unstaked_txo_assets::PrimaryKeyQuery::execute(&session).await?;

    // WIP: delete filtered keys
    // let purge_to_slot: u64 = purge_slot.saturating_sub(Settings::purge_slot_buffer());

    Ok(())
}
