//! Index certs found in a transaction.

use std::{fmt, sync::Arc};

use cardano_blockchain_types::{MultiEraBlock, Slot, StakeAddress, TxnIndex, VKeyHash};
use ed25519_dalek::VerifyingKey;
use pallas::ledger::primitives::{alonzo, conway};
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::{
        index::{
            queries::{
                FallibleQueryTasks, PreparedQueries, PreparedQuery, Query, QueryKind, SizedBatch,
            },
            session::CassandraSession,
        },
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

impl Query for StakeRegistrationInsertQuery {
    /// Prepare Batch of Insert TXI Index Data Queries
    async fn prepare_query(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<QueryKind> {
        StakeRegistrationInsertQuery::prepare_batch(session, cfg)
            .await
            .map(QueryKind::Batch)
    }
}

impl fmt::Debug for StakeRegistrationInsertQuery {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
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

impl fmt::Display for StakeRegistrationInsertQuery {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{INSERT_STAKE_REGISTRATION_QUERY}")
    }
}

impl StakeRegistrationInsertQuery {
    /// Create a new Insert Query.
    #[allow(clippy::too_many_arguments, clippy::fn_params_excessive_bools)]
    pub fn new(
        stake_address: StakeAddress, slot_no: Slot, txn_index: TxnIndex,
        stake_public_key: VerifyingKey, script: bool, register: bool, deregister: bool,
        cip36: bool, pool_delegation: Option<Vec<u8>>,
    ) -> Self {
        StakeRegistrationInsertQuery {
            stake_address: stake_address.into(),
            slot_no: slot_no.into(),
            txn_index: txn_index.into(),
            stake_public_key: stake_public_key.into(),
            script,
            register: if register {
                MaybeUnset::Set(true)
            } else {
                MaybeUnset::Unset
            },
            deregister: if deregister {
                MaybeUnset::Set(true)
            } else {
                MaybeUnset::Unset
            },
            cip36: if cip36 {
                MaybeUnset::Set(true)
            } else {
                MaybeUnset::Unset
            },
            pool_delegation: if let Some(pool_delegation) = pool_delegation {
                MaybeUnset::Set(pool_delegation)
            } else {
                MaybeUnset::Unset
            },
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

/// Insert Cert Queries
pub(crate) struct CertInsertQuery {
    /// Stake Registration Data captured during indexing.
    stake_reg_data: Vec<StakeRegistrationInsertQuery>,
}

impl CertInsertQuery {
    /// Create new data set for Cert Insert Query Batch.
    pub(crate) fn new() -> Self {
        CertInsertQuery {
            stake_reg_data: Vec::new(),
        }
    }

    /// Prepare Batch of Insert TXI Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        // Note: for now we have one query, but there are many certs, and later we may have more
        // to add here.
        StakeRegistrationInsertQuery::prepare_batch(session, cfg).await
    }

    /// Get the stake address for a hash, return an empty address if one can not be found.
    #[allow(clippy::too_many_arguments)]
    fn stake_address(
        &mut self, cred: &alonzo::StakeCredential, slot_no: Slot, txn: TxnIndex, register: bool,
        deregister: bool, delegation: Option<Vec<u8>>, block: &MultiEraBlock,
    ) {
        let (stake_address, pubkey, script) = match *cred {
            conway::StakeCredential::AddrKeyhash(cred) => {
                let stake_address = StakeAddress::new(block.network(), false, cred.into());
                let addr = block.witness_for_tx(&VKeyHash::from(*cred), txn);
                // Note: it is totally possible for the Registration Certificate to not be
                // witnessed.
                (stake_address, addr, false)
            },
            conway::StakeCredential::Scripthash(h) => {
                (
                    StakeAddress::new(block.network(), true, h.into()),
                    None,
                    true,
                )
            },
        };

        if pubkey.is_none() && !script && deregister {
            error!("Stake Deregistration Certificate {stake_address} is NOT Witnessed.");
        }

        if pubkey.is_none() && !script && delegation.is_some() {
            error!("Stake Delegation Certificate {stake_address} is NOT Witnessed.");
        }

        // This may not be witnessed, its normal but disappointing.
        if let Some(pubkey) = pubkey {
            self.stake_reg_data.push(StakeRegistrationInsertQuery::new(
                stake_address,
                slot_no,
                txn,
                pubkey,
                script,
                register,
                deregister,
                false,
                delegation,
            ));
        }
    }

    /// Index an Alonzo Era certificate into the database.
    fn index_alonzo_cert(
        &mut self, cert: &alonzo::Certificate, slot: Slot, index: TxnIndex, block: &MultiEraBlock,
    ) {
        #[allow(clippy::match_same_arms)]
        match cert {
            alonzo::Certificate::StakeRegistration(cred) => {
                // This may not be witnessed, its normal but disappointing.
                self.stake_address(cred, slot, index, true, false, None, block);
            },
            alonzo::Certificate::StakeDeregistration(cred) => {
                self.stake_address(cred, slot, index, false, true, None, block);
            },
            alonzo::Certificate::StakeDelegation(cred, pool) => {
                self.stake_address(cred, slot, index, false, false, Some(pool.to_vec()), block);
            },
            alonzo::Certificate::PoolRegistration { .. } => {},
            alonzo::Certificate::PoolRetirement(..) => {},
            alonzo::Certificate::GenesisKeyDelegation(..) => {},
            alonzo::Certificate::MoveInstantaneousRewardsCert(_) => {},
        }
    }

    /// Index a certificate from a conway transaction.
    fn index_conway_cert(
        &mut self, cert: &conway::Certificate, slot_no: Slot, txn: TxnIndex, block: &MultiEraBlock,
    ) {
        #[allow(clippy::match_same_arms)]
        match cert {
            conway::Certificate::StakeRegistration(cred) => {
                // This may not be witnessed, its normal but disappointing.
                self.stake_address(cred, slot_no, txn, true, false, None, block);
            },
            conway::Certificate::StakeDeregistration(cred) => {
                self.stake_address(cred, slot_no, txn, false, true, None, block);
            },
            conway::Certificate::StakeDelegation(cred, pool) => {
                self.stake_address(cred, slot_no, txn, false, false, Some(pool.to_vec()), block);
            },
            conway::Certificate::PoolRegistration { .. } => {},
            conway::Certificate::PoolRetirement(..) => {},
            conway::Certificate::Reg(..) => {},
            conway::Certificate::UnReg(..) => {},
            conway::Certificate::VoteDeleg(..) => {},
            conway::Certificate::StakeVoteDeleg(..) => {},
            conway::Certificate::StakeRegDeleg(..) => {},
            conway::Certificate::VoteRegDeleg(..) => {},
            conway::Certificate::StakeVoteRegDeleg(..) => {},
            conway::Certificate::AuthCommitteeHot(..) => {},
            conway::Certificate::ResignCommitteeCold(..) => {},
            conway::Certificate::RegDRepCert(..) => {},
            conway::Certificate::UnRegDRepCert(..) => {},
            conway::Certificate::UpdateDRepCert(..) => {},
        }
    }

    /// Index the certificates in a transaction.
    pub(crate) fn index(
        &mut self, txs: &pallas::ledger::traverse::MultiEraTx<'_>, slot: Slot, index: TxnIndex,
        block: &MultiEraBlock,
    ) {
        #[allow(clippy::match_same_arms)]
        txs.certs().iter().for_each(|cert| {
            match cert {
                pallas::ledger::traverse::MultiEraCert::NotApplicable => {},
                pallas::ledger::traverse::MultiEraCert::AlonzoCompatible(cert) => {
                    self.index_alonzo_cert(cert, slot, index, block);
                },
                pallas::ledger::traverse::MultiEraCert::Conway(cert) => {
                    self.index_conway_cert(cert, slot, index, block);
                },
                _ => {},
            }
        });
    }

    /// Execute the Certificate Indexing Queries.
    ///
    /// Consumes the `self` and returns a vector of futures.
    pub(crate) fn execute(self, session: &Arc<CassandraSession>) -> FallibleQueryTasks {
        let mut query_handles: FallibleQueryTasks = Vec::new();

        let inner_session = session.clone();

        query_handles.push(tokio::spawn(async move {
            inner_session
                .execute_batch(
                    PreparedQuery::StakeRegistrationInsertQuery,
                    self.stake_reg_data,
                )
                .await
        }));

        query_handles
    }
}
