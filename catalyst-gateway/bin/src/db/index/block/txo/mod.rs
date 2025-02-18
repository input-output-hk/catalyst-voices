//! Insert TXO Indexed Data Queries.
//!
//! Note, there are multiple ways TXO Data is indexed and they all happen in here.

pub(crate) mod insert_txo;
pub(crate) mod insert_txo_asset;
pub(crate) mod insert_unstaked_txo;
pub(crate) mod insert_unstaked_txo_asset;

use std::sync::Arc;

use cardano_blockchain_types::{Network, Slot, TransactionHash, TxnIndex, TxnOutputOffset};
use scylla::Session;
use tracing::{error, warn};

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    settings::cassandra_db,
    utils::stake_hash::stake_hash,
};

/// This is used to indicate that there is no stake address.
const NO_STAKE_ADDRESS: &[u8] = &[];

/// Insert TXO Query and Parameters
///
/// There are multiple possible parameters to a query, which are represented separately.
pub(crate) struct TxoInsertQuery {
    /// Staked TXO Data Parameters
    staked_txo: Vec<insert_txo::Params>,
    /// Unstaked TXO Data Parameters
    unstaked_txo: Vec<insert_unstaked_txo::Params>,
    /// Staked TXO Asset Data Parameters
    staked_txo_asset: Vec<insert_txo_asset::Params>,
    /// Unstaked TXO Asset Data Parameters
    unstaked_txo_asset: Vec<insert_unstaked_txo_asset::Params>,
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
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<(SizedBatch, SizedBatch, SizedBatch, SizedBatch)> {
        let txo_staked_insert_batch = insert_txo::Params::prepare_batch(session, cfg).await;
        let txo_unstaked_insert_batch =
            insert_unstaked_txo::Params::prepare_batch(session, cfg).await;
        let txo_staked_asset_insert_batch =
            insert_txo_asset::Params::prepare_batch(session, cfg).await;
        let txo_unstaked_asset_insert_batch =
            insert_unstaked_txo_asset::Params::prepare_batch(session, cfg).await;

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
    /// header and the stake key hash as a vec of 29 bytes.
    fn extract_stake_address(
        network: Network, txo: &pallas::ledger::traverse::MultiEraOutput<'_>, slot_no: Slot,
        txn_id: &str,
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
                                error!(error=%error, slot=?slot_no, txn=txn_id,"Error converting to bech32: skipping.");
                                return None;
                            },
                        };

                        match address.delegation() {
                            pallas::ledger::addresses::ShelleyDelegationPart::Script(hash) => {
                                (stake_hash(network, true, hash), address_string)
                            },
                            pallas::ledger::addresses::ShelleyDelegationPart::Key(hash) => {
                                (stake_hash(network, false, hash), address_string)
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
                            slot = ?slot_no,
                            txn = txn_id,
                            "Unexpected Stake address found in TXO. Refusing to index."
                        );
                        return None;
                    },
                }
            },
            Err(error) => {
                // This should not ever happen.
                error!(error=%error, slot = ?slot_no, txn = txn_id, "Failed to get Address from TXO. Skipping TXO.");
                return None;
            },
        };

        Some(stake_address)
    }

    /// Index the transaction Inputs.
    pub(crate) fn index(
        &mut self, network: Network, txn: &pallas::ledger::traverse::MultiEraTx<'_>, slot_no: Slot,
        txn_hash: TransactionHash, index: TxnIndex,
    ) {
        let txn_id = txn_hash.to_string();

        // Accumulate all the data we want to insert from this transaction here.
        for (txo_index, txo) in txn.outputs().iter().enumerate() {
            // This will only return None if the TXO is not to be indexed (Byron Addresses)
            let Some((stake_address, address)) =
                Self::extract_stake_address(network, txo, slot_no, &txn_id)
            else {
                continue;
            };

            let staked = stake_address != NO_STAKE_ADDRESS;
            let txo_index = TxnOutputOffset::from(txo_index);

            if staked {
                let params = insert_txo::Params::new(
                    &stake_address,
                    slot_no,
                    index,
                    txo_index,
                    &address,
                    txo.lovelace_amount(),
                    txn_hash,
                );

                self.staked_txo.push(params);
            } else {
                let params = insert_unstaked_txo::Params::new(
                    txn_hash,
                    txo_index,
                    slot_no,
                    index,
                    &address,
                    txo.lovelace_amount(),
                );

                self.unstaked_txo.push(params);
            }

            for asset in txo.non_ada_assets() {
                let policy_id = asset.policy().to_vec();
                for policy_asset in asset.assets() {
                    if policy_asset.is_output() {
                        let asset_name = policy_asset.name();
                        let value = policy_asset.any_coin();

                        if staked {
                            let params = insert_txo_asset::Params::new(
                                &stake_address,
                                slot_no,
                                index,
                                txo_index,
                                &policy_id,
                                asset_name,
                                value,
                            );
                            self.staked_txo_asset.push(params);
                        } else {
                            let params = insert_unstaked_txo_asset::Params::new(
                                txn_hash, txo_index, &policy_id, asset_name, slot_no, index, value,
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
