//! Index a block
//! Primary Data Indexing - Upsert operations

pub(crate) mod certs;
pub(crate) mod cip36;
pub(crate) mod txi;
pub(crate) mod txo;

use cardano_chain_follower::MultiEraBlock;
use certs::CertInsertQuery;
use cip36::Cip36InsertQuery;
use tracing::{debug, error};
use txi::TxiInsertQuery;
use txo::TxoInsertQuery;

use super::{queries::FallibleQueryTasks, session::CassandraSession};
use crate::service::utilities::convert::i16_from_saturating;

/// Add all data needed from the block into the indexes.
pub(crate) async fn index_block(block: &MultiEraBlock) -> anyhow::Result<()> {
    // Get the session.  This should never fail.
    let Some(session) = CassandraSession::get(block.immutable()) else {
        anyhow::bail!("Failed to get Index DB Session.  Can not index block.");
    };

    let mut cert_index = CertInsertQuery::new();
    let mut cip36_index = Cip36InsertQuery::new();

    let mut txi_index = TxiInsertQuery::new();
    let mut txo_index = TxoInsertQuery::new();

    let block_data = block.decode();
    let slot_no = block_data.slot();

    // We add all transactions in the block to their respective index data sets.
    for (txn_index, txs) in block_data.txs().iter().enumerate() {
        let txn = i16_from_saturating(txn_index);

        let txn_hash = txs.hash().to_vec();

        // Index the TXIs.
        txi_index.index(txs, slot_no);

        // TODO: Index minting.
        // let mint = txs.mints().iter() {};

        // TODO: Index Metadata.
        cip36_index.index(txn_index, txn, slot_no, block);

        // Index Certificates inside the transaction.
        cert_index.index(txs, slot_no, txn, block);

        // Index the TXOs.
        txo_index.index(txs, slot_no, &txn_hash, txn);
    }

    // We then execute each batch of data from the block.
    // This maximizes batching opportunities.
    let mut query_handles: FallibleQueryTasks = Vec::new();

    query_handles.extend(txo_index.execute(&session));
    query_handles.extend(txi_index.execute(&session));
    query_handles.extend(cert_index.execute(&session));
    query_handles.extend(cip36_index.execute(&session));

    let mut result: anyhow::Result<()> = Ok(());

    // Wait for operations to complete, and display any errors
    for handle in query_handles {
        if result.is_err() {
            // Try and cancel all futures waiting tasks and return the first error we encountered.
            handle.abort();
            continue;
        }
        match handle.await {
            Ok(join_res) => {
                match join_res {
                    Ok(res) => debug!(res=?res,"Query OK"),
                    Err(error) => {
                        // IF a query fails, assume everything else is broken.
                        error!(error=%error,"Query Failed");
                        result = Err(error);
                    },
                }
            },
            Err(error) => {
                error!(error=%error,"Query Join Failed");
                result = Err(error.into());
            },
        }
    }

    result
}
