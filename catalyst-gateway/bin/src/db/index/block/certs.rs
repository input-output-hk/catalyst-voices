//! Index certs found in a transaction.

use std::{fmt::Debug, sync::Arc};

use cardano_chain_follower::MultiEraBlock;
use pallas::ledger::primitives::{alonzo, conway};
use scylla::{frame::value::MaybeUnset, SerializeRow, Session};
use tracing::error;

use crate::{
    db::index::{
        queries::{FallibleQueryTasks, PreparedQueries, PreparedQuery, SizedBatch},
        session::CassandraSession,
    },
    service::utilities::convert::from_saturating,
    settings::cassandra_db,
};

/// Insert TXI Query and Parameters
#[derive(SerializeRow)]
pub(crate) struct StakeRegistrationInsertQuery {
    /// Stake key hash
    stake_hash: Vec<u8>,
    /// Slot Number the cert is in.
    slot_no: num_bigint::BigInt,
    /// Transaction Index.
    txn: i16,
    /// Full Stake Public Key (32 byte Ed25519 Public key, not hashed).
    stake_address: MaybeUnset<Vec<u8>>,
    /// Is the stake address a script or not.
    script: bool,
    /// Is the Certificate Registered?
    register: MaybeUnset<bool>,
    /// Is the Certificate Deregistered?
    deregister: MaybeUnset<bool>,
    /// Pool Delegation Address
    pool_delegation: MaybeUnset<Vec<u8>>,
}

impl Debug for StakeRegistrationInsertQuery {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::result::Result<(), std::fmt::Error> {
        let stake_address = match self.stake_address {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(ref v) => &hex::encode(v),
        };
        let register = match self.register {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(v) => &format!("{v:?}"),
        };
        let deregister = match self.deregister {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(v) => &format!("{v:?}"),
        };
        let pool_delegation = match self.pool_delegation {
            MaybeUnset::Unset => "UNSET",
            MaybeUnset::Set(ref v) => &hex::encode(v),
        };

        f.debug_struct("StakeRegistrationInsertQuery")
            .field("stake_hash", &hex::encode(hex::encode(&self.stake_hash)))
            .field("slot_no", &self.slot_no)
            .field("txn", &self.txn)
            .field("stake_address", &stake_address)
            .field("script", &self.script)
            .field("register", &register)
            .field("deregister", &deregister)
            .field("pool_delegation", &pool_delegation)
            .finish()
    }
}

/// TXI by Txn hash Index
const INSERT_STAKE_REGISTRATION_QUERY: &str = include_str!("./cql/insert_stake_registration.cql");

impl StakeRegistrationInsertQuery {
    /// Create a new Insert Query.
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        stake_hash: Vec<u8>, slot_no: u64, txn: i16, stake_address: Vec<u8>, script: bool,
        register: bool, deregister: bool, pool_delegation: Option<Vec<u8>>,
    ) -> Self {
        StakeRegistrationInsertQuery {
            stake_hash,
            slot_no: slot_no.into(),
            txn,
            stake_address: if stake_address.is_empty() {
                MaybeUnset::Unset
            } else {
                MaybeUnset::Set(stake_address)
            },
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
            pool_delegation: if let Some(pool_delegation) = pool_delegation {
                MaybeUnset::Set(pool_delegation)
            } else {
                MaybeUnset::Unset
            },
        }
    }

    /// Prepare Batch of Insert TXI Index Data Queries
    pub(crate) async fn prepare_batch(
        session: &Arc<Session>, cfg: &cassandra_db::EnvVars,
    ) -> anyhow::Result<SizedBatch> {
        let insert_queries = PreparedQueries::prepare_batch(
            session.clone(),
            INSERT_STAKE_REGISTRATION_QUERY,
            cfg,
            scylla::statement::Consistency::Any,
            true,
            false,
        )
        .await;

        if let Err(ref error) = insert_queries {
            error!(error=%error,"Failed to prepare Insert Stake Registration Query.");
        };

        insert_queries
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
        &mut self, cred: &alonzo::StakeCredential, slot_no: u64, txn: i16, register: bool,
        deregister: bool, delegation: Option<Vec<u8>>, block: &MultiEraBlock,
    ) {
        let default_addr = Vec::new();
        let (key_hash, pubkey, script) = match cred {
            pallas::ledger::primitives::conway::StakeCredential::AddrKeyhash(cred) => {
                let addr = block
                    .witness_for_tx(cred, from_saturating(txn))
                    .unwrap_or(default_addr);
                // Note: it is totally possible for the Registration Certificate to not be
                // witnessed.
                (cred.to_vec(), addr.clone(), false)
            },
            pallas::ledger::primitives::conway::StakeCredential::ScriptHash(script) => {
                (script.to_vec(), default_addr, true)
            },
        };

        if pubkey.is_empty() && !script && deregister {
            error!(
                "Stake Deregistration Certificate {:?} is NOT Witnessed.",
                key_hash
            );
        }

        if pubkey.is_empty() && !script && delegation.is_some() {
            error!(
                "Stake Delegation Certificate {:?} is NOT Witnessed.",
                key_hash
            );
        }

        // This may not be witnessed, its normal but disappointing.
        self.stake_reg_data.push(StakeRegistrationInsertQuery::new(
            key_hash, slot_no, txn, pubkey, script, register, deregister, delegation,
        ));
    }

    /// Index an Alonzo Era certificate into the database.
    fn index_alonzo_cert(
        &mut self, cert: &alonzo::Certificate, slot_no: u64, txn: i16, block: &MultiEraBlock,
    ) {
        #[allow(clippy::match_same_arms)]
        match cert {
            pallas::ledger::primitives::alonzo::Certificate::StakeRegistration(cred) => {
                // This may not be witnessed, its normal but disappointing.
                self.stake_address(cred, slot_no, txn, true, false, None, block);
            },
            pallas::ledger::primitives::alonzo::Certificate::StakeDeregistration(cred) => {
                self.stake_address(cred, slot_no, txn, false, true, None, block);
            },
            pallas::ledger::primitives::alonzo::Certificate::StakeDelegation(cred, pool) => {
                self.stake_address(cred, slot_no, txn, false, false, Some(pool.to_vec()), block);
            },
            pallas::ledger::primitives::alonzo::Certificate::PoolRegistration { .. } => {},
            pallas::ledger::primitives::alonzo::Certificate::PoolRetirement(..) => {},
            pallas::ledger::primitives::alonzo::Certificate::GenesisKeyDelegation(..) => {},
            pallas::ledger::primitives::alonzo::Certificate::MoveInstantaneousRewardsCert(_) => {},
        }
    }

    /// Index a certificate from a conway transaction.
    fn index_conway_cert(
        &mut self, cert: &conway::Certificate, slot_no: u64, txn: i16, block: &MultiEraBlock,
    ) {
        #[allow(clippy::match_same_arms)]
        match cert {
            pallas::ledger::primitives::conway::Certificate::StakeRegistration(cred) => {
                // This may not be witnessed, its normal but disappointing.
                self.stake_address(cred, slot_no, txn, true, false, None, block);
            },
            pallas::ledger::primitives::conway::Certificate::StakeDeregistration(cred) => {
                self.stake_address(cred, slot_no, txn, false, true, None, block);
            },
            pallas::ledger::primitives::conway::Certificate::StakeDelegation(cred, pool) => {
                self.stake_address(cred, slot_no, txn, false, false, Some(pool.to_vec()), block);
            },
            pallas::ledger::primitives::conway::Certificate::PoolRegistration { .. } => {},
            pallas::ledger::primitives::conway::Certificate::PoolRetirement(..) => {},
            pallas::ledger::primitives::conway::Certificate::Reg(..) => {},
            pallas::ledger::primitives::conway::Certificate::UnReg(..) => {},
            pallas::ledger::primitives::conway::Certificate::VoteDeleg(..) => {},
            pallas::ledger::primitives::conway::Certificate::StakeVoteDeleg(..) => {},
            pallas::ledger::primitives::conway::Certificate::StakeRegDeleg(..) => {},
            pallas::ledger::primitives::conway::Certificate::VoteRegDeleg(..) => {},
            pallas::ledger::primitives::conway::Certificate::StakeVoteRegDeleg(..) => {},
            pallas::ledger::primitives::conway::Certificate::AuthCommitteeHot(..) => {},
            pallas::ledger::primitives::conway::Certificate::ResignCommitteeCold(..) => {},
            pallas::ledger::primitives::conway::Certificate::RegDRepCert(..) => {},
            pallas::ledger::primitives::conway::Certificate::UnRegDRepCert(..) => {},
            pallas::ledger::primitives::conway::Certificate::UpdateDRepCert(..) => {},
        }
    }

    /// Index the certificates in a transaction.
    pub(crate) fn index(
        &mut self, txs: &pallas::ledger::traverse::MultiEraTxWithRawAuxiliary<'_>, slot_no: u64,
        txn: i16, block: &MultiEraBlock,
    ) {
        #[allow(clippy::match_same_arms)]
        txs.certs().iter().for_each(|cert| {
            match cert {
                pallas::ledger::traverse::MultiEraCert::NotApplicable => {},
                pallas::ledger::traverse::MultiEraCert::AlonzoCompatible(cert) => {
                    self.index_alonzo_cert(cert, slot_no, txn, block);
                },
                pallas::ledger::traverse::MultiEraCert::Conway(cert) => {
                    self.index_conway_cert(cert, slot_no, txn, block);
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
