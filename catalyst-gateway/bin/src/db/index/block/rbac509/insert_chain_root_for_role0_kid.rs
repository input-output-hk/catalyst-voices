//! Index RBAC Chain Root For Role 0 Key Insert Query.
use std::{fmt::Debug, sync::Arc};

use ed25519_dalek::VerifyingKey;
use scylla::{SerializeRow, Session};
use to_vec::ToVec;
use tracing::error;

use crate::{
    db::index::{
        block::from_saturating,
        queries::{PreparedQueries, SizedBatch},
    },
    service::common::auth::rbac::role0_kid::Role0Kid,
    settings::cassandra_db::EnvVars,
};

use super::TransactionHash;

/// Index RBAC Chain Root by Role 0 Key
const INSERT_CHAIN_ROOT_FOR_ROLE0_KEY_QUERY: &str =
    include_str!("./cql/insert_chain_root_for_role0_kid.cql");

/// Insert Chain Root For Role 0 Key Query Parameters
#[derive(SerializeRow)]
pub(super) struct Params {
    /// Role 0 Key Hash. 32 bytes.
    role0_kid: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Chain Root Hash. 32 bytes.
    chain_root: Vec<u8>,
    /// Chain root slot number
    chain_root_slot: num_bigint::BigInt,
    /// Chain root transaction index
    chain_root_txn: i16,
    /// Signature Algorithm used by the certificate
    signature_alg: String,
    /// Public Key
    public_key: Vec<u8>,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("role0_key", &self.role0_kid)
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("chain_root", &self.chain_root)
            .finish()
    }
}

impl Params {
    /// Create a new record for this transaction.
    ///
    /// For now ONLY ed25519 is supported
    pub(super) fn new(
        role0_kid: Role0Kid, slot_no: u64, txn: usize, chain_root: TransactionHash,
        chain_root_slot: u64, chain_root_txn: usize, pub_key: VerifyingKey,
    ) -> Self {
        Params {
            role0_kid: role0_kid.to_vec(),
            slot_no: num_bigint::BigInt::from(slot_no),
            txn: from_saturating(txn),
            chain_root: chain_root.to_vec(),
            chain_root_slot: num_bigint::BigInt::from(chain_root_slot),
            chain_root_txn: from_saturating(chain_root_txn),
            signature_alg: "ed25519".to_string(),
            public_key: pub_key.as_bytes().to_vec(),
        }
    }

    /// Prepare Batch of RBAC Registration Index Data Queries
    pub(super) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_CHAIN_ROOT_FOR_ROLE0_KEY_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = insert_queries {
            error!(error=%error,"Failed to prepare Insert Chain Root For Role 0 Key Query.");
        };

        insert_queries
    }
}
