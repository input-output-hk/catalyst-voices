//! Get the TXO by Stake Address
use std::sync::{Arc, RwLock};

use cardano_blockchain_types::StakeAddress;
use futures::TryStreamExt;
use scylla::{prepared_statement::PreparedStatement, DeserializeRow, SerializeRow, Session};
use tracing::error;

use crate::db::{
    index::{
        queries::{
            caches::txo_by_stake::{get as cache_get, insert as cache_insert},
            PreparedQueries, PreparedSelectQuery,
        },
        session::CassandraSession,
    },
    types::{DbSlot, DbStakeAddress, DbTransactionId, DbTxnIndex, DbTxnOutputOffset},
};

/// Get txo by stake address query string.
const GET_TXO_BY_STAKE_ADDRESS_QUERY: &str = include_str!("../cql/get_txo_by_stake_address.cql");

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
            if let Some(rows) = cache_get(&params.stake_address) {
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
            cache_insert(params.stake_address, rows.clone());
        }

        Ok(rows)
    }
}
