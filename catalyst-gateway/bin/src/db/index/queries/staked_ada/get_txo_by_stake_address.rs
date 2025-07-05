//! Get the TXO by Stake Address
use std::sync::{Arc, LazyLock, RwLock};

use cardano_blockchain_types::StakeAddress;
use futures::TryStreamExt;
use moka::{ops::compute::Op, policy::EvictionPolicy, sync::Cache};
use scylla::{prepared_statement::PreparedStatement, DeserializeRow, SerializeRow, Session};
use tracing::error;

use super::update_txo_spent::UpdateTxoSpentQueryParams;
use crate::{
    db::{
        index::{
            queries::{PreparedQueries, PreparedSelectQuery},
            session::CassandraSession,
        },
        types::{DbSlot, DbStakeAddress, DbTransactionId, DbTxnIndex, DbTxnOutputOffset},
    },
    settings::Settings,
};

/// Get txo by stake address query string.
const GET_TXO_BY_STAKE_ADDRESS_QUERY: &str = include_str!("../cql/get_txo_by_stake_address.cql");

/// In memory cache of the most recent Cardano UTXO assets by Stake Address.
static ASSETS_CACHE: LazyLock<Cache<DbStakeAddress, Arc<Vec<GetTxoByStakeAddressQuery>>>> =
    LazyLock::new(|| {
        Cache::builder()
            .name("Cardano UTXO assets")
            .eviction_policy(EvictionPolicy::lru())
            .max_capacity(Settings::cardano_assets_cache().utxo_cache_size())
            .build()
    });

/// Get txo by stake address query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetTxoByStakeAddressQueryParams {
    /// Stake address.
    stake_address: DbStakeAddress,
}

impl GetTxoByStakeAddressQueryParams {
    /// Creates a new [`GetTxoByStakeAddressQueryParams`].
    pub(crate) fn new(stake_address: StakeAddress) -> Self {
        Self {
            stake_address: stake_address.into(),
        }
    }
}

/// Get UTXO assets internal query data.
#[derive(DeserializeRow)]
pub(crate) struct GetTxoByStakeAddressQueryInner {
    /// TXO transaction hash.
    pub txn_id: DbTransactionId,
    /// TXO transaction index within the slot.
    pub txn_index: DbTxnIndex,
    /// TXO index.
    pub txo: DbTxnOutputOffset,
    /// TXO transaction slot number.
    pub slot_no: DbSlot,
    /// TXO value.
    pub value: num_bigint::BigInt,
    /// TXO spent slot.
    pub spent_slot: Option<DbSlot>,
}

/// Get UTXO assets query value.
pub(crate) struct GetTxoByStakeAddressQueryValue {
    /// TXO transaction hash.
    pub txn_id: DbTransactionId,
    /// TXO value.
    pub value: num_bigint::BigInt,
    /// TXO spent slot.
    pub spent_slot: Option<DbSlot>,
}

/// Get UTXO assets query key.
#[derive(Hash, PartialEq, Eq, Debug)]
pub(crate) struct GetTxoByStakeAddressQueryKey {
    /// TXO transaction index within the slot.
    pub txn_index: DbTxnIndex,
    /// TXO index.
    pub txo: DbTxnOutputOffset,
    /// TXO transaction slot number.
    pub slot_no: DbSlot,
}

/// Get UTXO assets query.
#[derive(Clone)]
pub(crate) struct GetTxoByStakeAddressQuery {
    /// Key Data.
    pub key: Arc<GetTxoByStakeAddressQueryKey>,
    /// Value Data.
    pub value: Arc<RwLock<GetTxoByStakeAddressQueryValue>>,
}

// Convert from flat result into result which doesn't need to clone all its data
// everywhere.
impl From<GetTxoByStakeAddressQueryInner> for GetTxoByStakeAddressQuery {
    fn from(value: GetTxoByStakeAddressQueryInner) -> Self {
        Self {
            key: Arc::new(GetTxoByStakeAddressQueryKey {
                txn_index: value.txn_index,
                txo: value.txo,
                slot_no: value.slot_no,
            }),
            value: Arc::new(RwLock::new(GetTxoByStakeAddressQueryValue {
                txn_id: value.txn_id,
                value: value.value,
                spent_slot: value.spent_slot,
            })),
        }
    }
}

impl GetTxoByStakeAddressQuery {
    /// Prepares a get txo by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(
            session,
            GET_TXO_BY_STAKE_ADDRESS_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await
        .inspect_err(|error| error!(error=%error, "Failed to prepare get TXO by stake address."))
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{GET_TXO_BY_STAKE_ADDRESS_QUERY}"))
    }

    /// Executes a get txo by stake address query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetTxoByStakeAddressQueryParams,
    ) -> anyhow::Result<Arc<Vec<GetTxoByStakeAddressQuery>>> {
        if session.is_persistent() {
            if let Some(rows) = ASSETS_CACHE.get(&params.stake_address) {
                return Ok(rows);
            }
        }

        let rows: Vec<_> = session
            .execute_iter(PreparedSelectQuery::TxoByStakeAddress, &params)
            .await?
            .rows_stream::<GetTxoByStakeAddressQueryInner>()?
            .map_err(Into::<anyhow::Error>::into)
            .try_collect()
            .await?;
        let rows: Arc<Vec<_>> = Arc::new(
            rows.into_iter()
                .map(Into::<GetTxoByStakeAddressQuery>::into)
                .collect(),
        );

        // update cache
        if session.is_persistent() {
            ASSETS_CACHE.insert(params.stake_address, rows.clone());
        }

        Ok(rows)
    }

    /// Update spent UTXO Assets.
    pub(crate) fn update_cache(params: Vec<UpdateTxoSpentQueryParams>) {
        for update in params {
            let stake_address = &update.stake_address;
            let _entry = ASSETS_CACHE
                .entry(stake_address.clone())
                .and_compute_with(|maybe_entry| {
                    maybe_entry.map_or_else(|| {
                        tracing::debug!(utxo_params = ?update, stake_address = %stake_address, "Stake Address not found in Assets Cache");
                        Op::Nop
                    }, |entry| {
                        if let Some(txo) = entry.into_value().iter().find(|t| {
                            t.key.txo == update.txo
                                && t.key.txn_index == update.txn_index
                                && t.key.slot_no == update.slot_no
                        }) {
                            let mut value = txo.value.write().unwrap_or_else(|error| {
                                tracing::error!(
                                    ?update,
                                    %stake_address,
                                    %error,
                                    "UTXO Assets Cache lock is poisoned, recovering lock.");
                                txo.value.clear_poison();
                                error.into_inner()

                            });
                            value.spent_slot = Some(update.spent_slot);
                            tracing::debug!(
                                ?update,
                                %stake_address,
                                "Updated UTXO for Stake Address in Assets Cache");
                        } else {
                            tracing::debug!(
                                ?update,
                                %stake_address,
                                "UTXOs not found for Stake Address in Assets Cache");
                        }
                        Op::Nop
                    })
                });
        }
    }

    /// Empty the UTXO assets cache.
    pub(crate) fn drop_cache() {
        ASSETS_CACHE.invalidate_all();
    }
}
