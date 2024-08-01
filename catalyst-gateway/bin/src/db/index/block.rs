//! Index a block

use std::sync::{Arc, LazyLock};

use anyhow::bail;
use cardano_chain_follower::{ChainFollower, MultiEraBlock, Point};
use moka::future::{Cache, CacheBuilder};
use scylla::SerializeRow;
use tracing::{debug, error, warn};

use super::{queries::PreparedQueries, session::session};
use crate::settings::Settings;

/// This is used to indicate that there is no stake address.
const NO_STAKE_ADDRESS: &[u8] = &[];

/// Insert TXO Query Parameters
#[derive(SerializeRow)]
struct TxoInsertParams {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Actual full TXO Address
    address: String,
    /// Actual TXO Value in lovelace
    value: num_bigint::BigInt,
    /// Transactions hash.
    txn_hash: Vec<u8>,
}

/// Insert TXO Asset Query Parameters
#[derive(SerializeRow)]
struct TxoAssetInsertParams {
    /// Stake Address - Binary 28 bytes. 0 bytes = not staked.
    stake_address: Vec<u8>,
    /// Block Slot Number
    slot_no: num_bigint::BigInt,
    /// Transaction Offset inside the block.
    txn: i16,
    /// Transaction Output Offset inside the transaction.
    txo: i16,
    /// Policy hash of the asset
    policy_id: Vec<u8>,
    /// Policy name of the asset
    policy_name: String,
    /// Value of the asset
    value: num_bigint::BigInt,
    /// Transactions hash.
    txn_hash: Vec<u8>,
}

/// Insert TXI Query Parameters
#[derive(SerializeRow)]
struct TxiInsertParams {
    /// Spent Transactions Hash
    txn_hash: Vec<u8>,
    /// TXO Index spent.
    txo: i16,
    /// Block Slot Number when spend occurred.
    slot_no: num_bigint::BigInt,
}

#[allow(dead_code)]
static POINTER_ADDRESS_CACHE: LazyLock<Cache<Vec<u8>, Arc<Vec<u8>>>> =
    LazyLock::new(|| CacheBuilder::default().max_capacity(1024).build());

/// Dereference the Pointer and return the Stake Address if possible.
/// Returns an error if it can not be found for some reason.
///
/// We probably don't need to support this, but keep code incase we do.
#[allow(dead_code)]
async fn deref_stake_pointer(
    pointer: &pallas::ledger::addresses::Pointer,
) -> anyhow::Result<Arc<Vec<u8>>> {
    // OK, we can look this up because we have a full chain to query, so
    // try.
    let cfg = Settings::follower_cfg();

    let pointer_block_point = Point::fuzzy(pointer.slot());

    let pointer_txn_offset: usize = pointer.tx_idx().try_into().unwrap_or(usize::MAX);
    let pointer_cert_offset: usize = pointer.cert_idx().try_into().unwrap_or(usize::MAX);

    if let Some(pointer_block) = ChainFollower::get_block(cfg.chain, pointer_block_point).await {
        let block_data = pointer_block.block_data().decode();
        if let Some(txn) = block_data.txs().get(pointer_txn_offset) {
            if let Some(cert) = txn.certs().get(pointer_cert_offset) {
                match cert {
                    pallas::ledger::traverse::MultiEraCert::AlonzoCompatible(cert) => {
                        match cert.clone().into_owned() {
                            pallas::ledger::primitives::alonzo::Certificate::StakeRegistration(cred) |
                            pallas::ledger::primitives::alonzo::Certificate::StakeDeregistration(cred) |
                            pallas::ledger::primitives::alonzo::Certificate::StakeDelegation(cred, _) => {
                                match cred {
                                    pallas::ledger::primitives::conway::StakeCredential::AddrKeyhash(hash) |
                                    pallas::ledger::primitives::conway::StakeCredential::Scripthash(hash) => {
                                        return Ok(Arc::new(hash.to_vec()));
                                    },
                                }
                            },
                            _ => {
                                bail!("Alonzo cert type not a stake address.");
                            }
                        }
                    },
                    pallas::ledger::traverse::MultiEraCert::Conway(cert) => {
                        match cert.clone().into_owned() {
                            pallas::ledger::primitives::conway::Certificate::StakeRegistration(cred) |
                            pallas::ledger::primitives::conway::Certificate::StakeDeregistration(cred) |
                            pallas::ledger::primitives::conway::Certificate::StakeDelegation(cred, _) |
                            pallas::ledger::primitives::conway::Certificate::Reg(cred, _) |
                            pallas::ledger::primitives::conway::Certificate::UnReg(cred, _) |
                            pallas::ledger::primitives::conway::Certificate::VoteDeleg(cred, _) |
                            pallas::ledger::primitives::conway::Certificate::StakeVoteDeleg(cred, _, _) |
                            pallas::ledger::primitives::conway::Certificate::StakeRegDeleg(cred, _, _) |
                            pallas::ledger::primitives::conway::Certificate::VoteRegDeleg(cred, _, _) |
                            pallas::ledger::primitives::conway::Certificate::StakeVoteRegDeleg(cred, _, _, _) |
                            pallas::ledger::primitives::conway::Certificate::UpdateDRepCert(cred, _) => {
                                match cred {
                                    pallas::ledger::primitives::conway::StakeCredential::AddrKeyhash(hash)  |
                                    pallas::ledger::primitives::conway::StakeCredential::Scripthash(hash)=> {
                                        return Ok(Arc::new(hash.to_vec()));
                                    },
                                }
                            },
                            _ => {
                                bail!("Conway cert type not a stake address.");
                                },
                        }
                    },
                    _ => {
                        bail!("Certificate type unknown.");
                    },
                }
            }
            bail!(
                "Certificate index not found in block/txn. Treat as if there is no stake address."
            );
        }
        bail!("Pointer Stake address detected, but txn index not found in block. Treat as if there is no stake address.");
    }
    bail!("Pointer Stake address detected, but block not found. Treat as if there is no stake address.");
}

/// Make a pointer pretty print.
#[allow(dead_code)]
fn fmt_pointer(pointer: &pallas::ledger::addresses::Pointer) -> String {
    format!(
        "Slot:{},Tx:{},Cert:{}",
        pointer.slot(),
        pointer.tx_idx(),
        pointer.cert_idx()
    )
}

/// Extracts a stake address from a TXO if possible.
/// Returns None if it is not possible.
/// If we want to index, but can not determine a stake key hash, then return a Vec with a
/// single 0 byte.    This is because the index DB needs data in the primary key, so we
/// use a single byte of 0 to indicate    that there is no stake address, and still have a
/// primary key on the table. Otherwise return the stake key hash as a vec of 28 bytes.
fn extract_stake_address(
    txo: &pallas::ledger::traverse::MultiEraOutput<'_>, slot_no: u64, txn_id: &str,
) -> Option<(Vec<u8>, String)> {
    let stake_address = match txo.address() {
        Ok(address) => {
            match address {
                // Byron addresses do not have stake addresses and are not supported.
                pallas::ledger::addresses::Address::Byron(_) => {
                    return None;
                },
                pallas::ledger::addresses::Address::Shelley(address) => {
                    let address_string = match address.to_bech32() {
                        Ok(address) => address,
                        Err(error) => {
                            error!(error=%error, slot=slot_no, txn=txn_id,"Error converting to bech32: skipping.");
                            return None;
                        },
                    };

                    match address.delegation() {
                        pallas::ledger::addresses::ShelleyDelegationPart::Script(hash)
                        | pallas::ledger::addresses::ShelleyDelegationPart::Key(hash) => {
                            (hash.to_vec(), address_string)
                        },
                        pallas::ledger::addresses::ShelleyDelegationPart::Pointer(_pointer) => {
                            // These are not supported from Conway, so we don't support them either.
                            (NO_STAKE_ADDRESS.to_vec(), address_string)
                            /*
                            let pointer_string = fmt_pointer(pointer);
                            info!(
                                slot = slot_no,
                                txn = txn_id,
                                pointer = pointer_string,
                                "Block has stake address pointer"
                            );

                            // First check if its cached, and if not look it up.
                            // Pointer addresses always resolve to the same result, so they are safe
                            // to cache.
                            match POINTER_ADDRESS_CACHE
                                .try_get_with(
                                    pointer.to_vec().clone(),
                                    deref_stake_pointer(pointer),
                                )
                                .await
                            {
                                Ok(hash) => (hash.to_vec(), address_string),
                                Err(error) => {
                                    error!(error=%error, slot=slot_no, txn=txn_id, pointer=pointer_string,
                                        "Error looking up stake address via pointer: Treating as if there is no stake address.");
                                    POINTER_ADDRESS_CACHE
                                        .insert(
                                            pointer.to_vec(),
                                            Arc::new(NO_STAKE_ADDRESS.to_vec()),
                                        )
                                        .await;
                                    (NO_STAKE_ADDRESS.to_vec(), address_string)
                                },
                            }
                            */
                        },
                        pallas::ledger::addresses::ShelleyDelegationPart::Null => {
                            (NO_STAKE_ADDRESS.to_vec(), address_string)
                        },
                    }
                },
                pallas::ledger::addresses::Address::Stake(_) => {
                    // This should NOT appear in a TXO, so report if it does. But don't index it as
                    // a stake address.
                    warn!(
                        slot = slot_no,
                        txn = txn_id,
                        "Unexpected Stake address found in TXO. Refusing to index."
                    );
                    return None;
                },
            }
        },
        Err(error) => {
            // This should not ever happen.
            error!(error=%error, slot = slot_no, txn = txn_id, "Failed to get Address from TXO. Skipping TXO.");
            return None;
        },
    };

    Some(stake_address)
}

/// Convert a usize to an i16 and saturate at `i16::MAX`
fn usize_to_i16(value: usize) -> i16 {
    value.try_into().unwrap_or(i16::MAX)
}

/// Index the transaction Inputs.
fn index_txi(
    session: &Arc<scylla::Session>, queries: &Arc<PreparedQueries>,
    txs: &pallas::ledger::traverse::MultiEraTx<'_>, slot_no: u64,
) -> Vec<tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>>
{
    let mut query_handles: Vec<
        tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>,
    > = Vec::new();

    // Index the TXI's.
    for txi in txs.inputs() {
        let txn_hash = txi.hash().to_vec();
        let txo: i16 = txi.index().try_into().unwrap_or(i16::MAX);

        let nested_txi_query = queries.txi_insert_query.clone();
        let nested_session = session.clone();
        query_handles.push(tokio::spawn(async move {
            nested_session
                .execute(
                    &nested_txi_query,
                    TxiInsertParams {
                        txn_hash,
                        txo,
                        slot_no: slot_no.into(),
                    },
                )
                .await
        }));
    }

    query_handles
}

/// This TXO is NOT Staked, so index it as such.
#[allow(clippy::too_many_arguments)]
fn index_unstaked_txo(
    session: &Arc<scylla::Session>, stake_address: &[u8], txo_index: usize, address: String,
    value: u64, txo: &pallas::ledger::traverse::MultiEraOutput<'_>, queries: &Arc<PreparedQueries>,
    slot_no: u64, txn_hash: &[u8], txn_index: i16,
) -> Vec<tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>>
{
    let mut query_handles: Vec<
        tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>,
    > = Vec::new();

    let nested_txo_query = queries.txo_insert_query.clone();
    let nested_session = session.clone();
    let nested_txn_hash = txn_hash.to_vec();
    let nested_stake_address = stake_address.to_vec();
    query_handles.push(tokio::spawn(async move {
        nested_session
            .execute(
                &nested_txo_query,
                TxoInsertParams {
                    stake_address: nested_stake_address.clone(),
                    slot_no: slot_no.into(),
                    txn: txn_index,
                    txo: usize_to_i16(txo_index),
                    address,
                    value: value.into(),
                    txn_hash: nested_txn_hash,
                },
            )
            .await
    }));

    let inner_stake_address = stake_address.to_vec();
    for asset in txo.non_ada_assets() {
        let policy_id = asset.policy().to_vec();
        for policy_asset in asset.assets() {
            if policy_asset.is_output() {
                let policy_name = policy_asset.to_ascii_name().unwrap_or_default();
                let value = policy_asset.any_coin();

                let nested_txo_asset_query = queries.txo_asset_insert_query.clone();
                let nested_session = session.clone();
                let nested_txn_hash = txn_hash.to_vec();
                let nested_stake_address = inner_stake_address.clone();
                let nested_policy_id = policy_id.clone();
                query_handles.push(tokio::spawn(async move {
                    nested_session
                        .execute(
                            &nested_txo_asset_query,
                            TxoAssetInsertParams {
                                stake_address: nested_stake_address,
                                slot_no: slot_no.into(),
                                txn: txn_index,
                                txo: usize_to_i16(txo_index),
                                policy_id: nested_policy_id,
                                policy_name,
                                value: value.into(),
                                txn_hash: nested_txn_hash,
                            },
                        )
                        .await
                }));
            } else {
                error!("Minting MultiAsset in TXO.");
            }
        }
    }

    query_handles
}

/// This TXO is Staked, so index it as such.
#[allow(clippy::too_many_arguments)]
fn index_staked_txo(
    session: &Arc<scylla::Session>, stake_address: &[u8], txo_index: usize, address: String,
    value: u64, txo: &pallas::ledger::traverse::MultiEraOutput<'_>, queries: &Arc<PreparedQueries>,
    slot_no: u64, txn_hash: &[u8], txn_index: i16,
) -> Vec<tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>>
{
    let mut query_handles: Vec<
        tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>,
    > = Vec::new();

    let nested_txo_query = queries.txo_insert_query.clone();
    let nested_session = session.clone();
    let nested_txn_hash = txn_hash.to_vec();
    let nested_stake_address = stake_address.to_vec();
    query_handles.push(tokio::spawn(async move {
        nested_session
            .execute(
                &nested_txo_query,
                TxoInsertParams {
                    stake_address: nested_stake_address.clone(),
                    slot_no: slot_no.into(),
                    txn: txn_index,
                    txo: usize_to_i16(txo_index),
                    address,
                    value: value.into(),
                    txn_hash: nested_txn_hash,
                },
            )
            .await
    }));

    let inner_stake_address = stake_address.to_vec();
    for asset in txo.non_ada_assets() {
        let policy_id = asset.policy().to_vec();
        for policy_asset in asset.assets() {
            if policy_asset.is_output() {
                let policy_name = policy_asset.to_ascii_name().unwrap_or_default();
                let value = policy_asset.any_coin();

                let nested_txo_asset_query = queries.txo_asset_insert_query.clone();
                let nested_session = session.clone();
                let nested_txn_hash = txn_hash.to_vec();
                let nested_stake_address = inner_stake_address.clone();
                let nested_policy_id = policy_id.clone();
                query_handles.push(tokio::spawn(async move {
                    nested_session
                        .execute(
                            &nested_txo_asset_query,
                            TxoAssetInsertParams {
                                stake_address: nested_stake_address,
                                slot_no: slot_no.into(),
                                txn: txn_index,
                                txo: usize_to_i16(txo_index),
                                policy_id: nested_policy_id,
                                policy_name,
                                value: value.into(),
                                txn_hash: nested_txn_hash,
                            },
                        )
                        .await
                }));
            } else {
                error!("Minting MultiAsset in TXO.");
            }
        }
    }

    query_handles
}

/// Index the transaction Outputs.
fn index_txo(
    session: &Arc<scylla::Session>, queries: &Arc<PreparedQueries>,
    txs: &pallas::ledger::traverse::MultiEraTx<'_>, slot_no: u64, txn_hash: &[u8], txn_index: i16,
) -> Vec<tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>>
{
    let txn_id = hex::encode_upper(txn_hash);

    let mut query_handles: Vec<
        tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>,
    > = Vec::new();

    for (txo_index, txo) in txs.outputs().iter().enumerate() {
        let Some((stake_address, address)) = extract_stake_address(txo, slot_no, &txn_id) else {
            continue;
        };

        let value = txo.lovelace_amount();

        if stake_address == NO_STAKE_ADDRESS {
        } else {
            query_handles.extend(index_staked_txo(
                session,
                &stake_address,
                txo_index,
                address,
                value,
                txo,
                queries,
                slot_no,
                txn_hash,
                txn_index,
            ));
        }
        /*
        let value = txo.lovelace_amount();

        let nested_txo_query = txo_query.clone();
        let nested_session = session.clone();
        let nested_txn_hash = txn_hash.to_vec();
        let nested_stake_address = stake_address.clone();
        query_handles.push(tokio::spawn(async move {
            nested_session
                .execute(
                    &nested_txo_query,
                    TxoInsertParams {
                        stake_address: nested_stake_address,
                        slot_no: slot_no.into(),
                        txn: txn_index,
                        txo: usize_to_i16(txo_index),
                        address,
                        value: value.into(),
                        txn_hash: nested_txn_hash,
                    },
                )
                .await
        }));

        for asset in txo.non_ada_assets() {
            let policy_id = asset.policy().to_vec();
            for policy_asset in asset.assets() {
                if policy_asset.is_output() {
                    let policy_name = policy_asset.to_ascii_name().unwrap_or_default();
                    let value = policy_asset.any_coin();

                    let nested_txo_asset_query = txo_asset_query.clone();
                    let nested_session = session.clone();
                    let nested_txn_hash = txn_hash.to_vec();
                    let nested_stake_address = stake_address.clone();
                    let nested_policy_id = policy_id.clone();
                    query_handles.push(tokio::spawn(async move {
                        nested_session
                            .execute(
                                &nested_txo_asset_query,
                                TxoAssetInsertParams {
                                    stake_address: nested_stake_address,
                                    slot_no: slot_no.into(),
                                    txn: txn_index,
                                    txo: usize_to_i16(txo_index),
                                    policy_id: nested_policy_id,
                                    policy_name,
                                    value: value.into(),
                                    txn_hash: nested_txn_hash,
                                },
                            )
                            .await
                    }));
                } else {
                    error!("Minting MultiAsset in TXO.");
                }
            }
        }
        */
    }
    query_handles
}

/// Add all data needed from the block into the indexes.
#[allow(clippy::similar_names)]
pub(crate) async fn index_block(block: &MultiEraBlock) -> anyhow::Result<()> {
    // Get the session.  This should never fail.
    let Some((session, queries)) = session(block.immutable()) else {
        anyhow::bail!("Failed to get Index DB Session.  Can not index block.");
    };

    // As our indexing operations span multiple partitions, they can not be batched.
    // So use tokio threads to allow multiple writes to be dispatched simultaneously.
    let mut query_handles: Vec<
        tokio::task::JoinHandle<Result<scylla::QueryResult, scylla::transport::errors::QueryError>>,
    > = Vec::new();

    let block_data = block.decode();
    let slot_no = block_data.slot();

    for (txn_index, txs) in block_data.txs().iter().enumerate() {
        let txn_hash = txs.hash().to_vec();

        // Index the TXI's.
        query_handles.extend(index_txi(&session, &queries, txs, slot_no));

        // TODO: Index minting.
        // let mint = txs.mints().iter() {};

        // TODO: Index Metadata.

        // TODO: Index Stake address hash to stake address reverse lookups.
        // Actually Index Certs, first ones to index are stake addresses.
        let x = txs.required_signers();
        let x = txs.vkey_witnesses();
        txs.certs().iter().for_each(|cert| {
            match cert {
                pallas::ledger::traverse::MultiEraCert::NotApplicable => todo!(),
                pallas::ledger::traverse::MultiEraCert::AlonzoCompatible(cert) => {
                    match cert.clone().into_owned() {
                        pallas::ledger::primitives::alonzo::Certificate::StakeRegistration(_) => todo!(),
                        pallas::ledger::primitives::alonzo::Certificate::StakeDeregistration(_) => todo!(),
                        pallas::ledger::primitives::alonzo::Certificate::StakeDelegation(_, _) => todo!(),
                        pallas::ledger::primitives::alonzo::Certificate::PoolRegistration { operator, vrf_keyhash, pledge, cost, margin, reward_account, pool_owners, relays, pool_metadata } => todo!(),
                        pallas::ledger::primitives::alonzo::Certificate::PoolRetirement(_, _) => todo!(),
                        pallas::ledger::primitives::alonzo::Certificate::GenesisKeyDelegation(_, _, _) => todo!(),
                        pallas::ledger::primitives::alonzo::Certificate::MoveInstantaneousRewardsCert(_) => todo!(),
                    }
                },
                pallas::ledger::traverse::MultiEraCert::Conway(cert) => {
                    match cert.clone().into_owned() {
                        pallas::ledger::primitives::conway::Certificate::StakeRegistration(_) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::StakeDeregistration(_) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::StakeDelegation(_, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::PoolRegistration { operator, vrf_keyhash, pledge, cost, margin, reward_account, pool_owners, relays, pool_metadata } => todo!(),
                        pallas::ledger::primitives::conway::Certificate::PoolRetirement(_, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::Reg(_, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::UnReg(_, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::VoteDeleg(_, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::StakeVoteDeleg(_, _, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::StakeRegDeleg(_, _, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::VoteRegDeleg(_, _, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::StakeVoteRegDeleg(_, _, _, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::AuthCommitteeHot(_, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::ResignCommitteeCold(_, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::RegDRepCert(_, _, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::UnRegDRepCert(_, _) => todo!(),
                        pallas::ledger::primitives::conway::Certificate::UpdateDRepCert(_, _) => todo!(),
                    }
                },
                _ => todo!(),
            }
        });

        // Index the TXO's.
        query_handles.extend(index_txo(
            &session,
            &queries,
            txs,
            slot_no,
            &txn_hash,
            usize_to_i16(txn_index),
        ));
    }

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
                        result = Err(error.into());
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
