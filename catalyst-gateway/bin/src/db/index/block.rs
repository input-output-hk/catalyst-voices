//! Index a block

use cardano_chain_follower::MultiEraBlock;
use tracing::{debug, error};

use super::{
    index_certs::CertInsertQuery, index_txi::TxiInsertQuery, index_txo::TxoInsertQuery,
    queries::FallibleQueryTasks, session::CassandraSession,
};
use crate::cardano::util::extract_hashed_witnesses;

/// Convert a usize to an i16 and saturate at `i16::MAX`
pub(crate) fn usize_to_i16(value: usize) -> i16 {
    value.try_into().unwrap_or(i16::MAX)
}

/// Add all data needed from the block into the indexes.
#[allow(clippy::similar_names)]
pub(crate) async fn index_block(block: &MultiEraBlock) -> anyhow::Result<()> {
    // Get the session.  This should never fail.
    let Some(session) = CassandraSession::get(block.immutable()) else {
        anyhow::bail!("Failed to get Index DB Session.  Can not index block.");
    };

    let mut cert_index = CertInsertQuery::new();
    let mut txi_index = TxiInsertQuery::new();
    let mut txo_index = TxoInsertQuery::new();

    let block_data = block.decode();
    let slot_no = block_data.slot();

    // We add all transactions in the block to their respective index data sets.
    for (txn_index, txs) in block_data.txs().iter().enumerate() {
        let txn = usize_to_i16(txn_index);

        let txn_hash = txs.hash().to_vec();

        // Hash all the witnesses for easy lookup.
        let witnesses = extract_hashed_witnesses(txs.vkey_witnesses());

        // Index the TXIs.
        txi_index.index(txs, slot_no);

        // TODO: Index minting.
        // let mint = txs.mints().iter() {};

        // TODO: Index Metadata.

        // Index Certificates inside the transaction.
        cert_index.index(txs, slot_no, txn, &witnesses);

        // Index the TXOs.
        txo_index.index(txs, slot_no, &txn_hash, txn);
    }

    // We then execute each batch of data from the block.
    // This maximizes batching opportunities.
    let mut query_handles: FallibleQueryTasks = Vec::new();

    query_handles.extend(txo_index.execute(&session));
    query_handles.extend(txi_index.execute(&session));
    query_handles.extend(cert_index.execute(&session));

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
