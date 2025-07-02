//! Get the TXO by Stake Address
use std::sync::{Arc, LazyLock};

use cardano_blockchain_types::StakeAddress;
use futures::TryStreamExt;
use moka::{ops::compute::Op, policy::EvictionPolicy};
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
static ASSETS_CACHE: LazyLock<moka::future::Cache<DbStakeAddress, Vec<GetTxoByStakeAddressQuery>>> =
    LazyLock::new(|| {
        moka::future::Cache::builder()
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

/// Get txo by stake address query.
#[derive(DeserializeRow)]
pub(crate) struct GetTxoByStakeAddressQuery {
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
    ) -> anyhow::Result<TypedRowStream<GetTxoByStakeAddressQuery>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::TxoByStakeAddress, params)
            .await?
            .rows_stream::<GetTxoByStakeAddressQuery>()?;

        Ok(iter)
    }
}
