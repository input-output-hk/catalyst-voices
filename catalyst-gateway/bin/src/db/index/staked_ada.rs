//! Staked ADA related queries.
use std::sync::Arc;

use scylla::{
    prepared_statement::PreparedStatement, transport::iterator::TypedRowIterator, FromRow,
    SerializeRow, Session,
};
use tracing::error;

use super::{
    queries::{
        FallibleQueryResults, PreparedQueries, PreparedQuery, PreparedSelectQuery, SizedBatch,
    },
    session::CassandraSession,
};
use crate::settings::CassandraEnvVars;

/// Get txo by stake address query string.
const GET_TXO_BY_STAKE_ADDRESS_QUERY: &str = include_str!("./queries/get_txo_by_stake_address.cql");
/// Get TXI query string.
const GET_TXI_BY_TXN_HASHES_QUERY: &str = include_str!("./queries/get_txi_by_txn_hashes.cql");
/// Update TXO spent query string.
const UPDATE_TXO_SPENT_QUERY: &str = include_str!("./queries/update_txo_spent.cql");

/// Get txo by stake address query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetTxoByStakeAddressQueryParams {
    /// Stake address.
    stake_address: Vec<u8>,
    /// Max slot num.
    slot_no: num_bigint::BigInt,
}

impl GetTxoByStakeAddressQueryParams {
    /// Creates a new [`GetTxoByStakeAddressQueryParams`].
    pub(crate) fn new(stake_address: Vec<u8>, slot_no: num_bigint::BigInt) -> Self {
        Self {
            stake_address,
            slot_no,
        }
    }
}

/// Get txo by stake address query result.
#[derive(FromRow)]
pub(crate) struct GetTxoByStakeAddressQueryResult {
    /// TXO transaction hash.
    pub txn_hash: Vec<u8>,
    /// TXO transaction index within the slot.
    pub txn: i16,
    /// TXO index.
    pub txo: i16,
    /// TXO transaction slot number.
    pub slot_no: num_bigint::BigInt,
    /// TXO value.
    pub value: num_bigint::BigInt,
    /// TXO spent slot.
    pub spent_slot: Option<num_bigint::BigInt>,
}

/// Get staked ADA query.
pub(crate) struct GetTxoByStakeAddressQuery;

impl GetTxoByStakeAddressQuery {
    /// Prepares a get txo by stake address query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_txo_by_stake_address_query = PreparedQueries::prepare(
            session,
            GET_TXO_BY_STAKE_ADDRESS_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_txo_by_stake_address_query {
            error!(error=%error, "Failed to prepare get TXO by stake address");
        };

        get_txo_by_stake_address_query
    }

    /// Executes a get txo by stake address query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetTxoByStakeAddressQueryParams,
    ) -> anyhow::Result<TypedRowIterator<GetTxoByStakeAddressQueryResult>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::GetTxoByStakeAddress, params)
            .await?
            .into_typed::<GetTxoByStakeAddressQueryResult>();

        Ok(iter)
    }
}

/// Get TXI query parameters.
#[derive(SerializeRow)]
pub(crate) struct GetTxiByTxnHashesQueryParams {
    /// Transaction hashes.
    txn_hashes: Vec<Vec<u8>>,
}

impl GetTxiByTxnHashesQueryParams {
    /// Create a new instance of [`GetTxiByTxnHashesQueryParams`]
    pub(crate) fn new(txn_hashes: Vec<Vec<u8>>) -> Self {
        Self { txn_hashes }
    }
}

/// Get TXI query result.
#[derive(FromRow)]
pub(crate) struct GetTxiByTxnHashesQueryResult {
    /// TXI transaction hash.
    pub txn_hash: Vec<u8>,
    /// TXI original TXO index.
    pub txo: i16,
    /// TXI slot number.
    pub slot_no: num_bigint::BigInt,
}

/// Get TXI query.
pub(crate) struct GetTxiByTxnHashesQuery;

impl GetTxiByTxnHashesQuery {
    /// Prepares a get txi query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        let get_txi_by_txn_hashes_query = PreparedQueries::prepare(
            session,
            GET_TXI_BY_TXN_HASHES_QUERY,
            scylla::statement::Consistency::All,
            true,
        )
        .await;

        if let Err(ref error) = get_txi_by_txn_hashes_query {
            error!(error=%error, "Failed to prepare get TXI by txn hashes query.");
        };

        get_txi_by_txn_hashes_query
    }

    /// Executes a get txi by transaction hashes query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: GetTxiByTxnHashesQueryParams,
    ) -> anyhow::Result<TypedRowIterator<GetTxiByTxnHashesQueryResult>> {
        let iter = session
            .execute_iter(PreparedSelectQuery::GetTxiByTransactionHash, params)
            .await?
            .into_typed::<GetTxiByTxnHashesQueryResult>();

        Ok(iter)
    }
}

/// Update TXO spent query params.
#[derive(SerializeRow)]
pub(crate) struct UpdateTxoSpentQueryParams {
    /// TXO stake address.
    pub stake_address: Vec<u8>,
    /// TXO transaction index within the slot.
    pub txn: i16,
    /// TXO index.
    pub txo: i16,
    /// TXO slot number.
    pub slot_no: num_bigint::BigInt,
    /// TXO spent slot number.
    pub spent_slot: num_bigint::BigInt,
}

/// Update TXO spent query.
pub(crate) struct UpdateTxoSpentQuery;

impl UpdateTxoSpentQuery {
    /// Prepare a batch of update TXO spent queries.
    pub(crate) async fn prepare_batch(
        session: Arc<Session>, cfg: &CassandraEnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let update_txo_spent_queries = PreparedQueries::prepare_batch(
            session.clone(),
            UPDATE_TXO_SPENT_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = update_txo_spent_queries {
            error!(error=%error,"Failed to prepare update TXO spent query.");
        };

        update_txo_spent_queries
    }

    /// Executes a update txo spent query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: Vec<UpdateTxoSpentQueryParams>,
    ) -> FallibleQueryResults {
        let results = session
            .execute_batch(PreparedQuery::TxoSpentUpdateQuery, params)
            .await?;

        Ok(results)
    }
}
