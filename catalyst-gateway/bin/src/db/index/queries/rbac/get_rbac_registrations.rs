//! Get RBAC registrations by Catalyst ID.

use std::sync::Arc;

use anyhow::Context;
use cardano_blockchain_types::{Network, Point, Slot, TxnIndex};
use cardano_chain_follower::ChainFollower;
use catalyst_signed_doc::IdUri;
use futures::{TryFutureExt, TryStreamExt};
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};
use scylla::{
    prepared_statement::PreparedStatement, statement::Consistency,
    transport::iterator::TypedRowStream, DeserializeRow, SerializeRow, Session,
};
use tracing::{error, warn};

use crate::db::{
    index::{
        queries::{PreparedQueries, PreparedSelectQuery},
        session::CassandraSession,
    },
    types::{DbCatalystId, DbSlot, DbTransactionId, DbTxnIndex, DbUuidV4},
};

/// Get registrations by Catalyst ID query.
const QUERY: &str = include_str!("../cql/get_rbac_registrations_catalyst_id.cql");

/// Get registrations by Catalyst ID query params.
#[derive(SerializeRow)]
pub(crate) struct QueryParams {
    /// A Catalyst ID.
    pub catalyst_id: DbCatalystId,
}

/// Get registrations by Catalyst ID query.
#[allow(dead_code)]
#[derive(DeserializeRow, Clone)]
pub(crate) struct Query {
    /// Registration transaction id.
    pub txn_id: DbTransactionId,
    /// A block slot number.
    pub slot_no: DbSlot,
    /// A transaction index.
    pub txn_index: DbTxnIndex,
    /// A previous  transaction id.
    pub prv_txn_id: Option<DbTransactionId>,
    /// A registration purpose.
    pub purpose: DbUuidV4,
}

impl Query {
    /// Prepares a query.
    pub(crate) async fn prepare(session: Arc<Session>) -> anyhow::Result<PreparedStatement> {
        PreparedQueries::prepare(session, QUERY, Consistency::All, true)
            .await
            .inspect_err(
                |e| error!(error=%e, "Failed to prepare get RBAC registrations by Catalyst ID query"),
            )
    }

    /// Executes a get registrations by Catalyst ID query.
    pub(crate) async fn execute(
        session: &CassandraSession, params: QueryParams,
    ) -> anyhow::Result<TypedRowStream<Query>> {
        session
            .execute_iter(PreparedSelectQuery::RbacRegistrationsByCatalystId, params)
            .await?
            .rows_stream::<Query>()
            .map_err(Into::into)
    }
}

/// Returns a sorted list of all registrations for the given Catalyst ID from the
/// database.
async fn indexed_registrations(
    session: &CassandraSession, catalyst_id: &IdUri,
) -> anyhow::Result<Vec<Query>> {
    let mut result: Vec<_> = Query::execute(session, QueryParams {
        catalyst_id: catalyst_id.clone().into(),
    })
    .and_then(|r| r.try_collect().map_err(Into::into))
    .await?;

    result.sort_by_key(|r| r.slot_no);
    Ok(result)
}

/// Build a registration chain from the given indexed data.
pub(crate) async fn build_reg_chain(
    session: &CassandraSession, catalyst_id: &IdUri, network: Network,
) -> anyhow::Result<Option<RegistrationChain>> {
    let regs = indexed_registrations(session, catalyst_id).await?;
    let mut regs_iter = regs.iter();
    let Some(root) = regs_iter.next() else {
        return Ok(None);
    };

    let root = registration(network, root.slot_no.into(), root.txn_index.into())
        .await
        .context("Failed to get root registration")?;
    let mut chain = RegistrationChain::new(root).context("Invalid root registration")?;

    for reg in regs_iter {
        // We only store valid registrations in this table, so an error here indicates a bug in
        // our indexing logic.
        let cip509 = registration(network, reg.slot_no.into(), reg.txn_index.into())
            .await
            .with_context(|| {
                format!(
                    "Invalid or missing registration at {:?} block {:?} transaction",
                    reg.slot_no, reg.txn_index,
                )
            })?;
        match chain.update(cip509) {
            Ok(c) => chain = c,
            Err(e) => {
                // This isn't a hard error because while the individual registration can be valid it
                // can be invalid in the context of the whole registration chain.
                warn!(
                    "Unable to apply registration from {:?} block {:?} txn index: {e:?}",
                    reg.slot_no, reg.txn_index
                );
            },
        }
    }

    Ok(Some(chain))
}

/// A helper function to return a RBAC registration from the given block and slot.
async fn registration(network: Network, slot: Slot, txn_index: TxnIndex) -> anyhow::Result<Cip509> {
    let point = Point::fuzzy(slot);
    let block = ChainFollower::get_block(network, point)
        .await
        .context("Unable to get block")?
        .data;
    if block.point().slot_or_default() != slot {
        // The `ChainFollower::get_block` function can return the next consecutive block if
        // it cannot find the exact one. This shouldn't happen, but we need
        // to check anyway.
        return Err(anyhow::anyhow!("Unable to find exact block"));
    }
    Cip509::new(&block, txn_index, &[])
        .context("Invalid RBAC registration")?
        .context("No RBAC registration at this block and txn index")
}
