//! Pre-prepare queries for a given session.
//!
//! This improves query execution time.

use scylla::prepared_statement::PreparedStatement;
use tokio::join;
use tracing::error;

use super::session::CassandraSession;

/// TXO by Stake Address Indexing query
const INSERT_TXO_QUERY: &str = include_str!("./queries/insert_txo.cql");
/// TXO Asset by Stake Address Indexing Query
const INSERT_TXO_ASSET_QUERY: &str = include_str!("./queries/insert_txo_asset.cql");
/// TXI by Txn hash Index
const INSERT_TXI_QUERY: &str = include_str!("./queries/insert_txi.cql");

/// Unstaked TXO by Stake Address Indexing query
const INSERT_UNSTAKED_TXO_QUERY: &str = include_str!("./queries/insert_unstaked_txo.cql");
/// Unstaked TXO Asset by Stake Address Indexing Query
const INSERT_UNSTAKED_TXO_ASSET_QUERY: &str =
    include_str!("./queries/insert_unstaked_txo_asset.cql");

/// All prepared queries for a session.
#[allow(clippy::struct_field_names)]
pub(crate) struct PreparedQueries {
    /// TXO Insert query.
    pub txo_insert_query: PreparedStatement,
    /// TXO Asset Insert query.
    pub txo_asset_insert_query: PreparedStatement,
    /// Unstaked TXO Insert query.
    pub unstaked_txo_insert_query: PreparedStatement,
    /// Unstaked TXO Asset Insert query.
    pub unstaked_txo_asset_insert_query: PreparedStatement,
    /// TXI Insert query.
    pub txi_insert_query: PreparedStatement,
}

impl PreparedQueries {
    /// Create new prepared queries for a given session.
    pub(crate) async fn new(session: &CassandraSession) -> anyhow::Result<Self> {
        // Pre-prepare our queries.
        let (txo_query, txo_asset_query, unstaked_txo_query, unstaked_txo_asset_query, txi_query) = join!(
            session.prepare(INSERT_TXO_QUERY),
            session.prepare(INSERT_TXO_ASSET_QUERY),
            session.prepare(INSERT_UNSTAKED_TXO_QUERY),
            session.prepare(INSERT_UNSTAKED_TXO_ASSET_QUERY),
            session.prepare(INSERT_TXI_QUERY),
        );

        if let Err(ref error) = txo_query {
            error!(error=%error,"Failed to prepare Insert TXO Query.");
        };
        if let Err(ref error) = txo_asset_query {
            error!(error=%error,"Failed to prepare Insert TXO Asset Query.");
        };
        if let Err(ref error) = unstaked_txo_query {
            error!(error=%error,"Failed to prepare Insert Unstaked TXO Query.");
        };
        if let Err(ref error) = unstaked_txo_asset_query {
            error!(error=%error,"Failed to prepare Insert Unstaked TXO Asset Query.");
        };
        if let Err(ref error) = txi_query {
            error!(error=%error,"Failed to prepare Insert TXI Query.");
        };

        let mut txo_query = txo_query?;
        let mut txo_asset_query = txo_asset_query?;
        let mut txo_unstaked_query = unstaked_txo_query?;
        let mut txo_unstaked_asset_query = unstaked_txo_asset_query?;
        let mut txi_query = txi_query?;

        // We just want to write as fast as possible, consistency at this stage isn't required.
        txo_query.set_consistency(scylla::statement::Consistency::Any);
        txo_asset_query.set_consistency(scylla::statement::Consistency::Any);
        txo_unstaked_query.set_consistency(scylla::statement::Consistency::Any);
        txo_unstaked_asset_query.set_consistency(scylla::statement::Consistency::Any);
        txi_query.set_consistency(scylla::statement::Consistency::Any);

        // These operations are idempotent, because they are always the same data.
        txo_query.set_is_idempotent(true);
        txo_asset_query.set_is_idempotent(true);
        txo_unstaked_query.set_is_idempotent(true);
        txo_unstaked_asset_query.set_is_idempotent(true);
        txi_query.set_is_idempotent(true);

        Ok(Self {
            txo_insert_query: txo_query,
            txo_asset_insert_query: txo_asset_query,
            unstaked_txo_insert_query: txo_unstaked_query,
            unstaked_txo_asset_insert_query: txo_unstaked_asset_query,
            txi_insert_query: txi_query,
        })
    }
}
