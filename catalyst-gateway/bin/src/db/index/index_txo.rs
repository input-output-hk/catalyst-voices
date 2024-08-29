//! Insert TXO Indexed Data Queries.
//!
//! Note, there are multiple ways TXO Data is indexed and they all happen in here.

use std::sync::Arc;

use scylla::{SerializeRow, Session};
use tracing::{error, warn};

use super::{
    block::usize_to_i16,
    queries::{FallibleQueryTasks, PreparedQueries, PreparedQuery, SizedBatch},
    session::CassandraSession,
};
use crate::settings::CassandraEnvVars;

/// This is used to indicate that there is no stake address.
const NO_STAKE_ADDRESS: &[u8] = &[];

/// TXO by Stake Address Indexing query
const INSERT_TXO_QUERY: &str = include_str!("./queries/insert_txo.cql");

/// Insert TXO Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow)]
struct TxoInsertParams {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Actual full TXO Address
    address: String,
    /// Actual TXO Value in lovelace
    value: num_bigint::BigInt,
    /// Transactions hash.
    txn_hash: Vec<u8>,
    /// Spent slot.
    spent_slot: num_bigint::BigInt,
}

impl TxoInsertParams {
    /// Create a new record for this transaction.
    #[allow(clippy::too_many_arguments)]
    pub(crate) fn new(
        stake_address: &[u8], slot_no: u64, txn: i16, txo: i16, address: &str, value: u64,
        txn_hash: &[u8], spent_slot: num_bigint::BigInt,
    ) -> Self {
        Self {
            stake_address: stake_address.to_vec(),
            slot_no: slot_no.into(),
            txn,
            txo,
            address: address.to_string(),
            value: value.into(),
            txn_hash: txn_hash.to_vec(),
            spent_slot,
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let txo_insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_TXO_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = txo_insert_queries {
            error!(error=%error,"Failed to prepare Insert TXO Asset Query.");
        };

        txo_insert_queries
    }
}

/// Unstaked TXO by Stake Address Indexing query
const INSERT_UNSTAKED_TXO_QUERY: &str = include_str!("./queries/insert_unstaked_txo.cql");

/// Insert TXO Unstaked Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow)]
struct TxoUnstakedInsertParams {
    /// Transactions hash.
    txn_hash: Vec<u8>,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Actual full TXO Address
    address: String,
    /// Actual TXO Value in lovelace
    value: num_bigint::BigInt,
}

impl TxoUnstakedInsertParams {
    /// Create a new record for this transaction.
    pub(crate) fn new(
        txn_hash: &[u8], txo: i16, slot_no: u64, txn: i16, address: &str, value: u64,
    ) -> Self {
        Self {
            txn_hash: txn_hash.to_vec(),
            txo,
            slot_no: slot_no.into(),
            txn,
            address: address.to_string(),
            value: value.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let txo_insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_UNSTAKED_TXO_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = txo_insert_queries {
            error!(error=%error,"Failed to prepare Insert TXO Asset Query.");
        };

        txo_insert_queries
    }
}

/// TXO Asset by Stake Address Indexing Query
const INSERT_TXO_ASSET_QUERY: &str = include_str!("./queries/insert_txo_asset.cql");

/// Insert TXO Asset Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow)]
struct TxoAssetInsertParams {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Policy hash of the asset
    policy_id: Vec<u8>,
    /// Policy name of the asset
    policy_name: String,
    /// Value of the asset
    value: num_bigint::BigInt,
}

impl TxoAssetInsertParams {
    /// Create a new record for this transaction.
    ///
    /// Note Value can be either a u64 or an i64, so use a i128 to represent all possible
    /// values.
    #[allow(clippy::too_many_arguments)]
    pub(crate) fn new(
        stake_address: &[u8], slot_no: u64, txn: i16, txo: i16, policy_id: &[u8],
        policy_name: &str, value: i128,
    ) -> Self {
        Self {
            stake_address: stake_address.to_vec(),
            slot_no: slot_no.into(),
            txn,
            txo,
            policy_id: policy_id.to_vec(),
            policy_name: policy_name.to_owned(),
            value: value.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let txo_insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_TXO_ASSET_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = txo_insert_queries {
            error!(error=%error,"Failed to prepare Insert TXO Asset Query.");
        };

        txo_insert_queries
    }
}

/// Unstaked TXO Asset by Stake Address Indexing Query
const INSERT_UNSTAKED_TXO_ASSET_QUERY: &str =
    include_str!("./queries/insert_unstaked_txo_asset.cql");

/// Insert TXO Asset Query Parameters
/// (Superset of data to support both Staked and Unstaked TXO records.)
#[derive(SerializeRow)]
struct TxoUnstakedAssetInsertParams {
    /// Transactions hash.
    txn_hash: Vec<u8>,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Policy hash of the asset
    policy_id: Vec<u8>,
    /// Policy name of the asset
    policy_name: String,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Value of the asset
    value: num_bigint::BigInt,
}

impl TxoUnstakedAssetInsertParams {
    /// Create a new record for this transaction.
    ///
    /// Note Value can be either a u64 or an i64, so use a i128 to represent all possible
    /// values.
    #[allow(clippy::too_many_arguments)]
    pub(crate) fn new(
        txn_hash: &[u8], txo: i16, policy_id: &[u8], policy_name: &str, slot_no: u64, txn: i16,
        value: i128,
    ) -> Self {
        Self {
            txn_hash: txn_hash.to_vec(),
            txo,
            policy_id: policy_id.to_vec(),
            policy_name: policy_name.to_owned(),
            slot_no: slot_no.into(),
            txn,
            value: value.into(),
        }
    }

    /// Prepare Batch of Staked Insert TXO Asset Index Data Queries
    async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let txo_insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_UNSTAKED_TXO_ASSET_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = txo_insert_queries {
            error!(error=%error,"Failed to prepare Insert Unstaked TXO Asset Query.");
        };

        txo_insert_queries
    }
}

/// Insert TXO Query and Parameters
///
/// There are multiple possible parameters to a query, which are represented separately.
#[allow(dead_code)]
pub(crate) struct TxoInsertQuery {
    /// Staked TXO Data Parameters
    staked_txo: Vec<TxoInsertParams>,
    /// Unstaked TXO Data Parameters
    unstaked_txo: Vec<TxoUnstakedInsertParams>,
    /// Staked TXO Asset Data Parameters
    staked_txo_asset: Vec<TxoAssetInsertParams>,
    /// Unstaked TXO Asset Data Parameters
    unstaked_txo_asset: Vec<TxoUnstakedAssetInsertParams>,
}

impl TxoInsertQuery {
    /// Create a new Insert TXO Query Batch
    pub(crate) fn new() -> Self {
        TxoInsertQuery {
            staked_txo: Vec::new(),
            unstaked_txo: Vec::new(),
            staked_txo_asset: Vec::new(),
            unstaked_txo_asset: Vec::new(),
        }
    }

    /// Prepare Batch of Insert TXI Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<(SizedBatch, SizedBatch, SizedBatch, SizedBatch)> {
        let txo_staked_insert_batch = TxoInsertParams::prepare_batch(session, cfg).await;
        let txo_unstaked_insert_batch = TxoUnstakedInsertParams::prepare_batch(session, cfg).await;
        let txo_staked_asset_insert_batch = TxoAssetInsertParams::prepare_batch(session, cfg).await;
        let txo_unstaked_asset_insert_batch =
            TxoUnstakedAssetInsertParams::prepare_batch(session, cfg).await;

        Ok((
            txo_staked_insert_batch?,
            txo_unstaked_insert_batch?,
            txo_staked_asset_insert_batch?,
            txo_unstaked_asset_insert_batch?,
        ))
    }

    /// Extracts a stake address from a TXO if possible.
    /// Returns None if it is not possible.
    /// If we want to index, but can not determine a stake key hash, then return a Vec
    /// with a single 0 byte.    This is because the index DB needs data in the
    /// primary key, so we use a single byte of 0 to indicate    that there is no
    /// stake address, and still have a primary key on the table. Otherwise return the
    /// stake key hash as a vec of 28 bytes.
    fn extract_stake_address(
        txo: &pallas::ledger::traverse::MultiEraOutput<'_>, slot_no: u64, txn_id: &str,
    ) -> Option<(Vec<u8>, String)> {
        let stake_address = match txo.address() {
            Ok(address) => {
                match address {
                    // Byron addresses do not have stake addresses and are not supported.
                    pallas::ledger::addresses::Address::Byron(_) => {
                        return None;
                    },
                    pallas::ledger::addresses::Address::Shelley(address) => {
                        let address_string = match address.to_bech32() {
                            Ok(address) => address,
                            Err(error) => {
                                // Shouldn't happen, but if it does error and don't index.
                                error!(error=%error, slot=slot_no, txn=txn_id,"Error converting to bech32: skipping.");
                                return None;
                            },
                        };

                        match address.delegation() {
                            pallas::ledger::addresses::ShelleyDelegationPart::Script(hash)
                            | pallas::ledger::addresses::ShelleyDelegationPart::Key(hash) => {
                                (hash.to_vec(), address_string)
                            },
                            pallas::ledger::addresses::ShelleyDelegationPart::Pointer(_pointer) => {
                                // These are not supported from Conway, so we don't support them
                                // either.
                                (NO_STAKE_ADDRESS.to_vec(), address_string)
                            },
                            pallas::ledger::addresses::ShelleyDelegationPart::Null => {
                                (NO_STAKE_ADDRESS.to_vec(), address_string)
                            },
                        }
                    },
                    pallas::ledger::addresses::Address::Stake(_) => {
                        // This should NOT appear in a TXO, so report if it does. But don't index it
                        // as a stake address.
                        warn!(
                            slot = slot_no,
                            txn = txn_id,
                            "Unexpected Stake address found in TXO. Refusing to index."
                        );
                        return None;
                    },
                }
            },
            Err(error) => {
                // This should not ever happen.
                error!(error=%error, slot = slot_no, txn = txn_id, "Failed to get Address from TXO. Skipping TXO.");
                return None;
            },
        };

        Some(stake_address)
    }

    /// Index the transaction Inputs.
    pub(crate) fn index(
        &mut self, txs: &pallas::ledger::traverse::MultiEraTx<'_>, slot_no: u64, txn_hash: &[u8],
        txn: i16,
    ) {
        let txn_id = hex::encode_upper(txn_hash);

        // Accumulate all the data we want to insert from this transaction here.
        for (txo_index, txo) in txs.outputs().iter().enumerate() {
            // This will only return None if the TXO is not to be indexed (Byron Addresses)
            let Some((stake_address, address)) = Self::extract_stake_address(txo, slot_no, &txn_id)
            else {
                continue;
            };

            let staked = stake_address != NO_STAKE_ADDRESS;
            let txo_index = usize_to_i16(txo_index);

            if staked {
                let params = TxoInsertParams::new(
                    &stake_address,
                    slot_no,
                    txn,
                    txo_index,
                    &address,
                    txo.lovelace_amount(),
                    txn_hash,
                    (-1).into(),
                );

                self.staked_txo.push(params);
            } else {
                let params = TxoUnstakedInsertParams::new(
                    txn_hash,
                    txo_index,
                    slot_no,
                    txn,
                    &address,
                    txo.lovelace_amount(),
                );

                self.unstaked_txo.push(params);
            }

            for asset in txo.non_ada_assets() {
                let policy_id = asset.policy().to_vec();
                for policy_asset in asset.assets() {
                    if policy_asset.is_output() {
                        let policy_name = policy_asset.to_ascii_name().unwrap_or_default();
                        let value = policy_asset.any_coin();

                        if staked {
                            let params = TxoAssetInsertParams::new(
                                &stake_address,
                                slot_no,
                                txn,
                                txo_index,
                                &policy_id,
                                &policy_name,
                                value,
                            );
                            self.staked_txo_asset.push(params);
                        } else {
                            let params = TxoUnstakedAssetInsertParams::new(
                                txn_hash,
                                txo_index,
                                &policy_id,
                                &policy_name,
                                slot_no,
                                txn,
                                value,
                            );
                            self.unstaked_txo_asset.push(params);
                        }
                    } else {
                        error!("Minting MultiAsset in TXO.");
                    }
                }
            }
        }
    }

    /// Index the transaction Inputs.
    ///
    /// Consumes `self` and returns a vector of futures.
    pub(crate) fn execute(self, session: &Arc<CassandraSession>) -> FallibleQueryTasks {
        let mut query_handles: FallibleQueryTasks = Vec::new();

        if !self.staked_txo.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(PreparedQuery::TxoAdaInsertQuery, self.staked_txo)
                    .await
            }));
        }

        if !self.unstaked_txo.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(PreparedQuery::UnstakedTxoAdaInsertQuery, self.unstaked_txo)
                    .await
            }));
        }

        if !self.staked_txo_asset.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(PreparedQuery::TxoAssetInsertQuery, self.staked_txo_asset)
                    .await
            }));
        }
        if !self.unstaked_txo_asset.is_empty() {
            let inner_session = session.clone();
            query_handles.push(tokio::spawn(async move {
                inner_session
                    .execute_batch(
                        PreparedQuery::UnstakedTxoAssetInsertQuery,
                        self.unstaked_txo_asset,
                    )
                    .await
            }));
        }

        query_handles
    }
}
