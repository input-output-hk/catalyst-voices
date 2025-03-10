//! Index certs found in a transaction.

use std::sync::Arc;

use cardano_blockchain_types::{MultiEraBlock, Slot, StakeAddress, TxnIndex, VKeyHash};
use pallas::ledger::primitives::{alonzo, conway};
use tracing::error;

use super::stake_reg::StakeRegistrationInsertQuery;
use crate::db::index::{
    queries::{FallibleQueryTasks, PreparedQuery},
    session::CassandraSession,
};

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

    /// Get the stake address for a hash, return an empty address if one can not be found.
    #[allow(clippy::too_many_arguments)]
    fn stake_address(
        &mut self, cred: &alonzo::StakeCredential, slot_no: Slot, txn: TxnIndex,
        register: Option<bool>, deregister: Option<bool>, cip36: Option<bool>,
        delegation: Option<Vec<u8>>, block: &MultiEraBlock,
    ) {
        let (stake_address, pubkey, script) = match cred {
            conway::StakeCredential::AddrKeyhash(cred) => {
                let stake_address = StakeAddress::new(block.network(), false, (*cred).into());
                let addr = block.witness_for_tx(&VKeyHash::from(*cred), txn);
                // Note: it is totally possible for the Registration Certificate to not be
                // witnessed.
                (stake_address, addr, false)
            },
            conway::StakeCredential::Scripthash(h) => {
                (
                    StakeAddress::new(block.network(), true, (*h).into()),
                    None,
                    true,
                )
            },
        };

        if pubkey.is_none() && !script && deregister.is_some_and(|v| v) {
            error!("Stake Deregistration Certificate {stake_address} is NOT Witnessed.");
        }

        if pubkey.is_none() && !script && delegation.is_some() {
            error!("Stake Delegation Certificate {stake_address} is NOT Witnessed.");
        }

        // This may not be witnessed, its normal but disappointing.
        self.stake_reg_data.push(StakeRegistrationInsertQuery::new(
            stake_address,
            slot_no,
            txn,
            pubkey,
            script,
            register,
            deregister,
            cip36,
            delegation,
        ));
    }

    /// Index an Alonzo Era certificate into the database.
    fn index_alonzo_cert(
        &mut self, cert: &alonzo::Certificate, slot: Slot, index: TxnIndex, block: &MultiEraBlock,
    ) {
        #[allow(clippy::match_same_arms)]
        match cert {
            alonzo::Certificate::StakeRegistration(cred) => {
                // This may not be witnessed, its normal but disappointing.
                self.stake_address(cred, slot, index, Some(true), None, None, None, block);
            },
            alonzo::Certificate::StakeDeregistration(cred) => {
                self.stake_address(cred, slot, index, None, Some(true), None, None, block);
            },
            alonzo::Certificate::StakeDelegation(cred, pool) => {
                self.stake_address(
                    cred,
                    slot,
                    index,
                    None,
                    None,
                    None,
                    Some(pool.to_vec()),
                    block,
                );
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
                self.stake_address(cred, slot_no, txn, Some(true), None, None, None, block);
            },
            conway::Certificate::StakeDeregistration(cred) => {
                self.stake_address(cred, slot_no, txn, None, Some(true), None, None, block);
            },
            conway::Certificate::StakeDelegation(cred, pool) => {
                self.stake_address(
                    cred,
                    slot_no,
                    txn,
                    None,
                    None,
                    None,
                    Some(pool.to_vec()),
                    block,
                );
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
