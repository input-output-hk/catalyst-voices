//! Immutable Roll Forward logic.
#![allow(dead_code, clippy::unused_async, clippy::todo)]
use std::sync::Arc;

use scylla::Session;

use crate::{db::index::queries::SizedBatch, settings::cassandra_db::EnvVars};

type Wip = Vec<()>;

/// Roll Forward Purge Query.
pub(crate) struct RollforwardPurgeQuery {
    /// Get Primary Keys for TXO Purge Query.
    pub(crate) get_txo: Wip,
    /// Get Primary Keys for TXO Asset Purge Query.
    pub(crate) get_txo_asset: Wip,
    /// Get Primary Keys forUnstaked TXO Purge Query.
    pub(crate) get_unstaked_txo: Wip,
    /// Get Primary Keys for Unstaked TXO Asset Purge Query.
    pub(crate) get_unstaked_txo_asset: Wip,
    /// Get Primary Keys for TXI Purge Query.
    pub(crate) get_txi: Wip,
    /// Get Primary Keys for TXI Purge Query.
    pub(crate) get_stake_registration: Wip,
    /// Get Primary Keys for CIP36 Registrations Purge Query.
    pub(crate) get_cip36_registration: Wip,
    /// Get Primary Keys for CIP36 Registration errors Purge Query.
    pub(crate) get_cip36_registration_error: Wip,
    /// Get Primary Keys for CIP36 Registration for Stake Address Purge Query.
    pub(crate) get_cip36_registration_for_stake_address: Wip,
    /// Get Primary Keys for RBAC 509 Registrations Purge Query.
    pub(crate) get_rbac509_registration: Wip,
    /// Get Primary Keys for Chain Root for TX ID Purge Query..
    pub(crate) get_chain_root_for_txn_id: Wip,
    /// Get Primary Keys for Chain Root for Role 0 Key Purge Query..
    pub(crate) get_chain_root_for_role0_key: Wip,
    /// Get Primary Keys for Chain Root for Stake Address Purge Query.
    pub(crate) get_chain_root_for_stake_address: Wip,
    /// TXO Purge Query.
    pub(crate) purge_txo: Wip,
    /// TXO Asset Purge Query.
    pub(crate) purge_txo_asset: Wip,
    /// Unstaked TXO Purge Query.
    pub(crate) purge_unstaked_txo: Wip,
    /// Unstaked TXO Asset Purge Query.
    pub(crate) purge_unstaked_txo_asset: Wip,
    /// TXI Purge Query.
    pub(crate) purge_txi: Wip,
    /// TXI Purge Query.
    pub(crate) purge_stake_registration: Wip,
    /// CIP36 Registrations Purge Query.
    pub(crate) purge_cip36_registration: Wip,
    /// CIP36 Registration errors Purge Query.
    pub(crate) purge_cip36_registration_error: Wip,
    /// CIP36 Registration for Stake Address Purge Query.
    pub(crate) purge_cip36_registration_for_stake_address: Wip,
    /// RBAC 509 Registrations Purge Query.
    pub(crate) purge_rbac509_registration: Wip,
    /// Chain Root for TX ID Purge Query..
    pub(crate) purge_chain_root_for_txn_id: Wip,
    /// Chain Root for Role 0 Key Purge Query..
    pub(crate) purge_chain_root_for_role0_key: Wip,
    /// Chain Root for Stake Address Purge Query..
    pub(crate) purge_chain_root_for_stake_address: Wip,
}

/// Purge batches.
#[allow(clippy::struct_field_names)]
pub(crate) struct PurgeBatches {
    /// Get Primary Keys forTXO Purge Query.
    pub(crate) get_txo_purge_queries: SizedBatch,
    /// Get Primary Keys forTXO Asset Purge Query.
    pub(crate) get_txo_asset_purge_queries: SizedBatch,
    /// Get Primary Keys forUnstaked TXO Purge Query.
    pub(crate) get_unstaked_txo_purge_queries: SizedBatch,
    /// Get Primary Keys forUnstaked TXO Asset Purge Query.
    pub(crate) get_unstaked_txo_asset_purge_queries: SizedBatch,
    /// Get Primary Keys forTXI Purge Query.
    pub(crate) get_txi_purge_queries: SizedBatch,
    /// Get Primary Keys forTXI Purge Query.
    pub(crate) get_stake_registration_purge_queries: SizedBatch,
    /// Get Primary Keys forCIP36 Registrations Purge Query.
    pub(crate) get_cip36_registration_purge_queries: SizedBatch,
    /// Get Primary Keys forCIP36 Registration errors Purge Query.
    pub(crate) get_cip36_registration_error_purge_queries: SizedBatch,
    /// Get Primary Keys forCIP36 Registration for Stake Address Purge Query.
    pub(crate) get_cip36_registration_for_stake_address_purge_queries: SizedBatch,
    /// Get Primary Keys forRBAC 509 Registrations Purge Query.
    pub(crate) get_rbac509_registration_purge_queries: SizedBatch,
    /// Get Primary Keys forChain Root for TX ID Purge Query..
    pub(crate) get_chain_root_for_txn_id_purge_queries: SizedBatch,
    /// Get Primary Keys forChain Root for Role 0 Key Purge Query..
    pub(crate) get_chain_root_for_role0_key_purge_queries: SizedBatch,
    /// Get Primary Keys forChain Root for Stake Address Purge Query..
    pub(crate) get_chain_root_for_stake_address_purge_queries: SizedBatch,
    /// TXO Purge Query.
    pub(crate) txo_purge_queries: SizedBatch,
    /// TXO Asset Purge Query.
    pub(crate) txo_asset_purge_queries: SizedBatch,
    /// Unstaked TXO Purge Query.
    pub(crate) unstaked_txo_purge_queries: SizedBatch,
    /// Unstaked TXO Asset Purge Query.
    pub(crate) unstaked_txo_asset_purge_queries: SizedBatch,
    /// TXI Purge Query.
    pub(crate) txi_purge_queries: SizedBatch,
    /// TXI Purge Query.
    pub(crate) stake_registration_purge_queries: SizedBatch,
    /// CIP36 Registrations Purge Query.
    pub(crate) cip36_registration_purge_queries: SizedBatch,
    /// CIP36 Registration errors Purge Query.
    pub(crate) cip36_registration_error_purge_queries: SizedBatch,
    /// CIP36 Registration for Stake Address Purge Query.
    pub(crate) cip36_registration_for_stake_address_purge_queries: SizedBatch,
    /// RBAC 509 Registrations Purge Query.
    pub(crate) rbac509_registration_purge_queries: SizedBatch,
    /// Chain Root for TX ID Purge Query..
    pub(crate) chain_root_for_txn_id_purge_queries: SizedBatch,
    /// Chain Root for Role 0 Key Purge Query..
    pub(crate) chain_root_for_role0_key_purge_queries: SizedBatch,
    /// Chain Root for Stake Address Purge Query..
    pub(crate) chain_root_for_stake_address_purge_queries: SizedBatch,
}

impl RollforwardPurgeQuery {
    /// Prepare the purge query.
    pub(crate) async fn prepare_batch(
        _session: &Arc<Session>, _cfg: &EnvVars,
    ) -> anyhow::Result<PurgeBatches> {
        todo!();
    }
}
