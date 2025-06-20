//! Index RBAC Catalyst ID for public key insert query.

use std::{fmt::Debug, sync::Arc};

use cardano_blockchain_types::Slot;
use catalyst_types::catalyst_id::CatalystId;
use ed25519_dalek::VerifyingKey;
use scylla::{SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbCatalystId, DbPublicKey, DbSlot},
    },
    settings::cassandra_db::EnvVars,
};

/// Index RBAC Catalyst ID by public key.
const QUERY: &str = include_str!("cql/insert_catalyst_id_for_public_key.cql");

/// Insert Catalyst ID for public key query parameters.
#[derive(SerializeRow)]
pub(crate) struct Params {
    /// A public key.
    public_key: DbPublicKey,
    /// A Catalyst short identifier.
    catalyst_id: DbCatalystId,
    /// A block slot number.
    slot_no: DbSlot,
}

impl Debug for Params {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Params")
            .field("public_key", &self.public_key)
            .field("catalyst_id", &self.catalyst_id)
            .field("slot_no", &self.slot_no)
            .finish()
    }
}

impl Params {
    /// Creates a new record for this transaction.
    #[allow(dead_code)]
    pub(crate) fn new(public_key: VerifyingKey, slot_no: Slot, catalyst_id: CatalystId) -> Self {
        Params {
            public_key: public_key.into(),
            slot_no: slot_no.into(),
            catalyst_id: catalyst_id.into(),
        }
    }

    /// Prepares a batch of queries.
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
            .await
            .inspect_err(|error| error!(error=%error, "Failed to prepare 'insert Catalyst ID for public key query'."))
            .map_err(|error| anyhow::anyhow!("{error}\n--\n{QUERY}"))
    }
}
