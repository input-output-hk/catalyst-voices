//! Insert query for `stake_registration` table

use std::{fmt::Debug, sync::Arc};

use ed25519_dalek::VerifyingKey;
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::queries::{PreparedQueries, SizedBatch},
        types::{DbPublicKey, DbSlot, DbStakeAddress, DbTxnIndex},
    },
    settings::cassandra_db,
};

/// Insert stake registration query
#[derive(SerializeRow)]
pub(crate) struct StakeRegistrationInsertQuery {
    /// Stake address (29 bytes).
    stake_address: DbStakeAddress,
    /// Slot Number the cert is in.
    slot_no: DbSlot,
    /// Transaction Index.
    txn_index: DbTxnIndex,
    /// Full Stake Public Key (32 byte Ed25519 Public key, not hashed).
    stake_public_key: DbPublicKey,
    /// Is the stake address a script or not.
    script: bool,
    /// Is the Cardano Certificate Registered
    register: MaybeUnset<bool>,
    /// Is the Cardano Certificate Deregistered
    deregister: MaybeUnset<bool>,
    /// Is the stake address contains CIP36 registration?
    cip36: MaybeUnset<bool>,
    /// Pool Delegation Address
    pool_delegation: MaybeUnset<Vec<u8>>,
}

impl Debug for StakeRegistrationInsertQuery {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> Result<(), std::fmt::Error> {
        let stake_public_key = hex::encode(self.stake_public_key.as_ref());
        let register = match self.register {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(v) => &format!("{v:?}"),
        };
        let deregister = match self.deregister {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(v) => &format!("{v:?}"),
        };
        let cip36 = match self.cip36 {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(v) => &format!("{v:?}"),
        };
        let pool_delegation = match self.pool_delegation {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(ref v) => &hex::encode(v),
        };

        f.debug_struct("StakeRegistrationInsertQuery")
            .field("stake_address", &format!("{}", self.stake_address))
            .field("slot_no", &self.slot_no)
            .field("txn_index", &self.txn_index)
            .field("stake_public_key", &stake_public_key)
            .field("script", &self.script)
            .field("register", &register)
            .field("deregister", &deregister)
            .field("cip36", &cip36)
            .field("pool_delegation", &pool_delegation)
            .finish()
    }
}

/// Insert stake registration
const INSERT_STAKE_REGISTRATION_QUERY: &str = include_str!("./cql/insert_stake_registration.cql");

impl StakeRegistrationInsertQuery {
    /// Create a new Insert Query.
    #[allow(clippy::too_many_arguments)]
    pub fn new<
        StakeAddressT: Into<DbStakeAddress>,
        SlotT: Into<DbSlot>,
        TxIndexT: Into<DbTxnIndex>,
    >(
        stake_address: StakeAddressT, slot_no: SlotT, txn_index: TxIndexT,
        stake_public_key: VerifyingKey, script: bool, register: Option<bool>,
        deregister: Option<bool>, cip36: Option<bool>, pool_delegation: Option<Vec<u8>>,
    ) -> Self {
        StakeRegistrationInsertQuery {
            stake_address: stake_address.into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            stake_public_key: stake_public_key.into(),
            script,
            register: register.map_or(MaybeUnset::Unset, MaybeUnset::Set),
            deregister: deregister.map_or(MaybeUnset::Unset, MaybeUnset::Set),
            cip36: cip36.map_or(MaybeUnset::Unset, MaybeUnset::Set),
            pool_delegation: pool_delegation.map_or(MaybeUnset::Unset, MaybeUnset::Set),
        }
    }

    /// Prepare Batch of Insert stake registration.
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_STAKE_REGISTRATION_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await
        .inspect_err(
            |error| error!(error=%error,"Failed to prepare Insert Stake Registration Query."),
        )
        .map_err(|error| anyhow::anyhow!("{error}\n--\n{INSERT_STAKE_REGISTRATION_QUERY}"))
    }
}
