//! Pre-prepare queries for a given session.
//!
//! This improves query execution time.

pub(crate) mod purge;
pub(crate) mod rbac;
pub(crate) mod registrations;
pub(crate) mod staked_ada;
pub(crate) mod sync_status;

use std::{any::TypeId, fmt::Debug, sync::Arc};

use anyhow::bail;
use dashmap::DashMap;
use purge::{
    catalyst_id_for_stake_address::{
        DeleteQuery as PurgeCatalystIdForStakeAddressDelete,
        PrimaryKeyQuery as PurgeCatalystIdForStakeAddressSelect,
    },
    catalyst_id_for_txn_id::{
        DeleteQuery as PurgeCatalystIdForTxnIdDelete,
        PrimaryKeyQuery as PurgeCatalystIdForTxnIdSelect,
    },
    cip36_registration::{
        DeleteQuery as PurgeCip36RegistrationDelete,
        PrimaryKeyQuery as PurgeCip36RegistrationSelect,
    },
    cip36_registration_for_vote_key::{
        DeleteQuery as PurgeCip36RegistrationForVoteKeyDelete,
        PrimaryKeyQuery as PurgeCip36RegistrationForVoteKeySelect,
    },
    cip36_registration_invalid::{
        DeleteQuery as PurgeCip36RegistrationInvalidDelete,
        PrimaryKeyQuery as PurgeCip36RegistrationInvalidSelect,
    },
    rbac509_invalid_registration::{
        DeleteQuery as PurgeRbacRegistrationInvalidDelete,
        PrimaryKeyQuery as PurgeRbacRegistrationInvalidSelect,
    },
    rbac509_registration::{
        DeleteQuery as PurgeRbacRegistrationDelete, PrimaryKeyQuery as PurgeRbacRegistrationSelect,
    },
    stake_registration::{
        DeleteQuery as PurgeStakeRegistrationDelete,
        PrimaryKeyQuery as PurgeStakeRegistrationSelect,
    },
    txi_by_hash::{DeleteQuery as PurgeTxiByHashDelete, PrimaryKeyQuery as PurgeTxiByHashSelect},
    txo_ada::{DeleteQuery as PurgeTxoAdaDelete, PrimaryKeyQuery as PurgeTxoAdaSelect},
    txo_assets::{DeleteQuery as PurgeTxoAssetsDelete, PrimaryKeyQuery as PurgeTxoAssetsSelect},
    unstaked_txo_ada::{
        DeleteQuery as PurgeTxoUnstakedAdaDelete, PrimaryKeyQuery as PurgeTxoUnstakedAdaSelect,
    },
    unstaked_txo_assets::{
        DeleteQuery as PurgeTxoUnstakedAssetDelete, PrimaryKeyQuery as PurgeTxoUnstakedAssetSelect,
    },
};
use rbac::{
    get_catalyst_id_from_stake_address::GetCatalystIdForStakeAddress,
    get_catalyst_id_from_transaction_id::GetCatalystIdForTxnId,
    get_rbac_invalid_registrations::GetRbac509InvalidRegistrations,
    get_rbac_registrations::GetRbac509Registrations,
};
use registrations::{
    get_all_invalids::GetAllInvalidRegistrationsQuery,
    get_all_registrations::GetAllRegistrationsQuery, get_from_stake_addr::GetRegistrationQuery,
    get_from_stake_address::GetStakeAddrQuery, get_from_vote_key::GetStakeAddrFromVoteKeyQuery,
    get_invalid::GetInvalidRegistrationQuery,
};
use scylla::{
    batch::Batch,
    prepared_statement::PreparedStatement,
    serialize::row::SerializeRow,
    transport::{errors::QueryError, iterator::QueryPager},
    QueryResult, Session,
};
use staked_ada::{
    get_assets_by_stake_address::GetAssetsByStakeAddressQuery,
    get_txi_by_txn_hash::GetTxiByTxnHashesQuery,
    get_txo_by_stake_address::GetTxoByStakeAddressQuery, update_txo_spent::UpdateTxoSpentQuery,
};
use sync_status::update::SyncStatusInsertQuery;
use tracing::error;

use super::{
    block::{
        certs::StakeRegistrationInsertQuery,
        cip36::{
            insert_cip36::Cip36Insert, insert_cip36_for_vote_key::Cip36ForVoteKeyInsert,
            insert_cip36_invalid::Cip36InvalidInsert,
        },
        rbac509::{
            insert_catalyst_id_for_stake_address::CatalystIdForStakeAddressInsert,
            insert_catalyst_id_for_txn_id::CatalystIdForTxnIdInsert, insert_rbac509::Rbac509Insert,
            insert_rbac509_invalid::Rbac509InvalidInsert,
        },
        txi::TxiInsertQuery,
        txo::{
            insert_txo::TxoInsertQuery, insert_txo_asset::Params as TxoAssetInsert,
            insert_unstaked_txo::Params as TxoUnstakedInsert,
            insert_unstaked_txo_asset::Params as TxoUnstakedAssetInsert,
        },
    },
    session::{CassandraSession, CassandraSessionError},
};
use crate::{service::utilities::health::set_index_db_liveness, settings::cassandra_db};

/// Batches of different sizes, prepared and ready for use.
pub(crate) type SizedBatch = DashMap<u16, Arc<Batch>>;

/// Kind of result
#[derive(Clone)]
#[allow(dead_code)]
pub(crate) enum QueryKind {
    /// Sized-batch
    Batch(SizedBatch),
    /// Prepared statement
    Statement(PreparedStatement),
}

/// A trait to prepare Index DB queries.
#[allow(dead_code)]
pub(crate) trait Query: std::fmt::Display + std::any::Any {
    /// CQL for query preparation.
    const QUERY_STR: &'static str;

    /// Returns the type id for the query.
    fn type_id() -> std::any::TypeId {
        std::any::TypeId::of::<Self>()
    }

    /// Returns the CQL statement for the query in plain text.
    fn query_str() -> &'static str {
        Self::QUERY_STR
    }

    /// Prepare the query
    async fn prepare_query(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<QueryKind>;
}

/// Implement Display trait for types that implement Query
#[macro_export]
macro_rules! impl_display_for_query_type {
    ($i:ty) => {
        impl std::fmt::Display for $i {
            fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
                write!(
                    f,
                    "{}",
                    <Self as $crate::db::index::queries::Query>::query_str()
                )
            }
        }
    };
}

/// Implement Query trait for batched types
#[macro_export]
macro_rules! impl_query_batch {
    ($i:ty, $c:ident) => {
        impl $crate::db::index::queries::Query for $i {

            const QUERY_STR: &'static str = $c;

            async fn prepare_query(
                session: &std::sync::Arc<scylla::Session>,
                cfg: &$crate::settings::cassandra_db::EnvVars,
            ) -> anyhow::Result<$crate::db::index::queries::QueryKind> {
                $crate::db::index::queries::prepare_batch(
                    session.clone(),
                    $c,
                    cfg,
                    scylla::statement::Consistency::Any,
                    true,
                    false,
                )
                .await
                .map($crate::db::index::queries::QueryKind::Batch)
                .inspect_err(|error| error!(error=%error,"Failed to prepare $c Query."))
                .map_err(|error| anyhow::anyhow!("{error}\n--\n{{$c}}"))
            }
        }

        $crate::impl_display_for_query_type!($i);
    };
}

/// Implement Query trait for statement types
#[macro_export]
macro_rules! impl_query_statement {
    ($i:ty, $c:ident) => {
        impl $crate::db::index::queries::Query for $i {

            const QUERY_STR: &'static str = $c;

            async fn prepare_query(
                session: &std::sync::Arc<scylla::Session>,
                _: &$crate::settings::cassandra_db::EnvVars,
            ) -> anyhow::Result<$crate::db::index::queries::QueryKind> {

                $crate::db::index::queries::prepare_statement(
                    session,
                    $c,
                    scylla::statement::Consistency::All,
                    true,
                )
                    .await
                    .map($crate::db::index::queries::QueryKind::Statement)
                    .inspect_err(|error| error!(error=%error, "Failed to prepare $c query."))
                    .map_err(|error| anyhow::anyhow!("{error}\n--\n{{$c}}"))

            }
        }

        $crate::impl_display_for_query_type!($i);
    };
}

/// Prepare Queries
pub(crate) async fn prepare_queries(
    session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
) -> anyhow::Result<DashMap<TypeId, QueryKind>> {
    // Prepare a query dashmap
    macro_rules! prepare_q {
        ( $( $i:ty),* ) => {
            {
                let queries = vec![
                    $( (<$i as Query>::type_id(), <$i as Query>::prepare_query(session, cfg).await?), )*
                ];
                DashMap::from_iter(queries)
            }
        }
    }
    // WIP: Adding queries as they implement trait
    let queries = prepare_q!(
        // prepared batch queries
        TxiInsertQuery,
        TxoInsertQuery,
        TxoAssetInsert,
        TxoUnstakedInsert,
        TxoUnstakedAssetInsert,
        StakeRegistrationInsertQuery,
        Cip36Insert,
        Cip36InvalidInsert,
        Cip36ForVoteKeyInsert,
        UpdateTxoSpentQuery,
        Rbac509Insert,
        Rbac509InvalidInsert,
        CatalystIdForTxnIdInsert,
        CatalystIdForStakeAddressInsert,
        // prepared statement queries
        GetTxoByStakeAddressQuery,
        GetTxiByTxnHashesQuery,
        GetAssetsByStakeAddressQuery,
        GetRegistrationQuery,
        GetStakeAddrQuery,
        GetStakeAddrFromVoteKeyQuery,
        GetInvalidRegistrationQuery,
        GetAllRegistrationsQuery,
        GetAllInvalidRegistrationsQuery,
        SyncStatusInsertQuery,
        GetCatalystIdForStakeAddress,
        GetCatalystIdForTxnId,
        GetRbac509Registrations,
        GetRbac509InvalidRegistrations,
        // purge queries
        PurgeTxoAdaSelect,
        PurgeTxoAdaDelete,
        PurgeTxoAssetsSelect,
        PurgeTxoAssetsDelete,
        PurgeTxoUnstakedAdaSelect,
        PurgeTxoUnstakedAdaDelete,
        PurgeTxoUnstakedAssetSelect,
        PurgeTxoUnstakedAssetDelete,
        PurgeTxiByHashSelect,
        PurgeTxiByHashDelete,
        PurgeStakeRegistrationSelect,
        PurgeStakeRegistrationDelete,
        PurgeCip36RegistrationSelect,
        PurgeCip36RegistrationDelete,
        PurgeCip36RegistrationInvalidSelect,
        PurgeCip36RegistrationInvalidDelete,
        PurgeCip36RegistrationForVoteKeySelect,
        PurgeCip36RegistrationForVoteKeyDelete,
        PurgeRbacRegistrationSelect,
        PurgeRbacRegistrationDelete,
        PurgeRbacRegistrationInvalidSelect,
        PurgeRbacRegistrationInvalidDelete,
        PurgeCatalystIdForTxnIdSelect,
        PurgeCatalystIdForTxnIdDelete,
        PurgeCatalystIdForStakeAddressSelect,
        PurgeCatalystIdForStakeAddressDelete
    );
    Ok(queries)
}

/// Prepares a statement.
pub(crate) async fn prepare_statement<Q: std::fmt::Display>(
    session: &Arc<Session>, query: Q, consistency: scylla::statement::Consistency, idempotent: bool,
) -> anyhow::Result<PreparedStatement> {
    let mut prepared = session.prepare(format!("{query}")).await?;
    prepared.set_consistency(consistency);
    prepared.set_is_idempotent(idempotent);

    Ok(prepared)
}

/// Prepares all permutations of the batch from 1 to max.
/// It is necessary to do this because batches are pre-sized, they can not be dynamic.
/// Preparing the batches in advance is a very larger performance increase.
pub(crate) async fn prepare_batch<Q: std::fmt::Display>(
    session: Arc<Session>, query: Q, cfg: &cassandra_db::EnvVars,
    consistency: scylla::statement::Consistency, idempotent: bool, logged: bool,
) -> anyhow::Result<SizedBatch> {
    let sized_batches: SizedBatch = DashMap::new();

    // First prepare the query. Only needs to be done once, all queries on a batch are the
    // same.
    let prepared = prepare_statement(&session, query, consistency, idempotent).await?;

    for batch_size in cassandra_db::MIN_BATCH_SIZE..=cfg.max_batch_size {
        let mut batch: Batch = Batch::new(if logged {
            scylla::batch::BatchType::Logged
        } else {
            scylla::batch::BatchType::Unlogged
        });
        batch.set_consistency(consistency);
        batch.set_is_idempotent(idempotent);
        for _ in cassandra_db::MIN_BATCH_SIZE..=batch_size {
            batch.append_statement(prepared.clone());
        }

        sized_batches.insert(batch_size.try_into()?, Arc::new(batch));
    }

    Ok(sized_batches)
}

/// A set of query responses that can fail.
pub(crate) type FallibleQueryResults = anyhow::Result<Vec<QueryResult>>;
/// A set of query responses from tasks that can fail.
pub(crate) type FallibleQueryTasks = Vec<tokio::task::JoinHandle<FallibleQueryResults>>;

/// Execute a Batch query with the given parameters.
///
/// Values should be a Vec of values which implement `SerializeRow` and they MUST be
/// the same, and must match the query being executed.
///
/// This will divide the batch into optimal sized chunks and execute them until all
/// values have been executed or the first error is encountered.
pub(crate) async fn session_execute_batch<T: SerializeRow + Debug, Q: std::fmt::Display>(
    session: Arc<Session>, query_map: &SizedBatch, cfg: Arc<cassandra_db::EnvVars>, query: Q,
    values: Vec<T>,
) -> FallibleQueryResults {
    let mut results: Vec<QueryResult> = Vec::new();
    let mut errors = Vec::new();

    let chunks = values.chunks(cfg.max_batch_size.try_into().unwrap_or(1));
    let query_str = format!("{query}");

    for chunk in chunks {
        let chunk_size: u16 = chunk.len().try_into()?;
        let Some(batch_query) = query_map.get(&chunk_size) else {
            // This should not actually occur.
            bail!("No batch query found for size {}", chunk_size);
        };
        let batch_query_statements = batch_query.value().clone();
        match session.batch(&batch_query_statements, chunk).await {
            Ok(result) => results.push(result),
            Err(err) => {
                let chunk_str = format!("{chunk:?}");
                if let QueryError::ConnectionPoolError(_) = err {
                    set_index_db_liveness(false);
                    error!(error=%err, query=query_str, chunk=chunk_str, "Index DB connection failed. Liveness set to false.");
                    bail!(CassandraSessionError::ConnectionUnavailable { source: err.into() })
                };
                error!(error=%err, query=query_str, chunk=chunk_str, "Query Execution Failed");
                errors.push(err);
                // Defer failure until all batches have been processed.
            },
        }
    }

    if !errors.is_empty() {
        bail!("Query Failed: {query_str}! {errors:?}");
    }

    Ok(results)
}

/// Executes a select query with the given parameters.
///
/// Returns an iterator that iterates over all the result pages that the query
/// returns.
pub(crate) async fn session_execute_iter<P>(
    session: Arc<Session>, prepared_stmt: &PreparedStatement, params: P,
) -> anyhow::Result<QueryPager>
where P: SerializeRow {
    session
        .execute_iter(prepared_stmt.clone(), params)
        .await
        .map_err(|e| {
            if let QueryError::ConnectionPoolError(err) = e {
                set_index_db_liveness(false);
                error!(error = %err, "Index DB connection failed. Liveness set to false.");
                CassandraSessionError::ConnectionUnavailable { source: err.into() }.into()
            } else {
                e.into()
            }
        })
}

/// Executes a single query with the given parameters.
///
/// Returns no data, and an error if the query fails.
pub(crate) async fn session_execute_upsert<P>(
    session: Arc<Session>, prepared_stmt: &PreparedStatement, params: P,
) -> anyhow::Result<()>
where P: SerializeRow {
    session
        .execute_unpaged(prepared_stmt, params)
        .await
        .map_err(|e| {
            match e {
                QueryError::ConnectionPoolError(err) => {
                    set_index_db_liveness(false);
                    error!(error = %err, "Index DB connection failed. Liveness set to false.");
                    CassandraSessionError::ConnectionUnavailable { source: err.into() }.into()
                },
                _ => anyhow::anyhow!(e),
            }
        })?;

    Ok(())
}
