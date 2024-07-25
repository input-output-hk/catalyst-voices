//! Index a block

use cardano_chain_follower::MultiEraBlock;
use scylla::{batch::Batch, SerializeRow};

use super::session::session;


/// TXO by Stake Address Table Schema
const INSERT_TXO_QUERY: &str = include_str!("./queries/insert_txo.cql");

/// Insert TXO Query Parameters
#[derive(SerializeRow)]
struct TxoInsertParams {
    stake_address: String,
    slot_no: num_bigint::BigInt,
    txn: i16,
    txo: i16,
    address: String,
    value: num_bigint::BigInt,
    txn_hash: Vec<u8>
}

/// Add all data needed from the block into the indexes.
pub(crate) async fn index_block(block: MultiEraBlock) -> anyhow::Result<()>{

    // Get the session.  This should never fail.
    let Some(session) = session(block.immutable()) else {
        anyhow::bail!("Failed to get Index DB Session.  Can not index block.");
    };
 
    // Create a batch statement
    let mut batch: Batch = Default::default();
    let mut values = Vec::<TxoInsertParams>::new();

    batch.append_statement(INSERT_TXO_QUERY);

    // Prepare all statements in the batch at once
    let prepared_batch: Batch = session.prepare_batch(&batch).await?;

    // Run the prepared batch
    session.batch(&prepared_batch, values).await?;  

    Ok(())
}