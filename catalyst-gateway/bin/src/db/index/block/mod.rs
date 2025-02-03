//! Index a block
//! Primary Data Indexing - Upsert operations

pub(crate) mod certs;
pub(crate) mod cip36;
pub(crate) mod rbac509;
pub(crate) mod roll_forward;
pub(crate) mod txi;
pub(crate) mod txo;

use cardano_blockchain_types::MultiEraBlock;
use catalyst_types::hashes::Blake2b256Hash;
use certs::CertInsertQuery;
use cip36::Cip36InsertQuery;
use rbac509::Rbac509InsertQuery;
use tracing::error;
use txi::TxiInsertQuery;
use txo::TxoInsertQuery;

use super::{queries::FallibleQueryTasks, session::CassandraSession};

/// Add all data needed from the block into the indexes.
pub(crate) async fn index_block(block: &MultiEraBlock) -> anyhow::Result<()> {
    // Get the session.  This should never fail.
    let Some(session) = CassandraSession::get(block.is_immutable()) else {
        anyhow::bail!("Failed to get Index DB Session.  Can not index block.");
    };

    let mut cert_index = CertInsertQuery::new();
    let mut cip36_index = Cip36InsertQuery::new();
    let mut rbac509_index = Rbac509InsertQuery::new();

    let mut txi_index = TxiInsertQuery::new();
    let mut txo_index = TxoInsertQuery::new();

    let slot = block.point().slot_or_default();

    // We add all transactions in the block to their respective index data sets.
    for (index, txn) in block.enumerate_txs() {
        let txn_hash = Blake2b256Hash::from(txn.hash()).into();

        // Index the TXIs.
        txi_index.index(&txn, slot);

        // TODO: Index minting.
        // let mint = txs.mints().iter() {};

        // TODO: Index Metadata.
        cip36_index.index(index, slot, block);

        // Index Certificates inside the transaction.
        cert_index.index(&txn, slot, index, block);

        // Index the TXOs.
        txo_index.index(&txn, slot, txn_hash, index);

        // Index RBAC 509 inside the transaction.
        rbac509_index
            .index(&session, txn_hash, index, slot, block)
            .await;
    }

    // We then execute each batch of data from the block.
    // This maximizes batching opportunities.
    let mut query_handles: FallibleQueryTasks = Vec::new();

    query_handles.extend(txo_index.execute(&session));
    query_handles.extend(txi_index.execute(&session));
    query_handles.extend(cert_index.execute(&session));
    query_handles.extend(cip36_index.execute(&session));
    query_handles.extend(rbac509_index.execute(&session));

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
                if let Err(error) = join_res {
                    // IF a query fails, assume everything else is broken.
                    error!(error=%error,"Query Failed");
                    result = Err(error);
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
