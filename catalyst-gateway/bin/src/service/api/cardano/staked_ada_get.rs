//! Implementation of the GET `/staked_ada` endpoint
use std::collections::HashMap;

use anyhow::anyhow;
use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse};

use super::types::SlotNumber;
use crate::{
    db::index::{
        queries::staked_ada::{
            get_txi_by_txn_hash::{GetTxiByTxnHashesQuery, GetTxiByTxnHashesQueryParams},
            get_txo_by_stake_address::{
                GetTxoByStakeAddressQuery, GetTxoByStakeAddressQueryParams,
            },
            update_txo_spent::{UpdateTxoSpentQuery, UpdateTxoSpentQueryParams},
        },
        session::CassandraSession,
    },
    service::common::{
        objects::cardano::{
            network::Network,
            stake_address::StakeAddress,
            stake_info::{FullStakeInfo, StakeInfo},
        },
        responses::WithErrorResponses,
    },
};

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// The amount of ADA staked by the queried stake address, as at the indicated slot.
    #[oai(status = 200)]
    Ok(Json<FullStakeInfo>),
    /// The queried stake address was not found at the requested slot number.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET `/staked_ada`
#[allow(clippy::unused_async, clippy::no_effect_underscore_binding)]
pub(crate) async fn endpoint(
    stake_address: StakeAddress, _provided_network: Option<Network>, slot_num: Option<SlotNumber>,
) -> AllResponses {
    let persistent_res = calculate_stake_info(true, stake_address.clone(), slot_num).await;
    let persistent_stake_info = match persistent_res {
        Ok(stake_info) => stake_info,
        Err(err) => return AllResponses::handle_error(&err),
    };

    let volatile_res = calculate_stake_info(false, stake_address, slot_num).await;
    let volatile_stake_info = match volatile_res {
        Ok(stake_info) => stake_info,
        Err(err) => return AllResponses::handle_error(&err),
    };

    if persistent_stake_info.is_none() && volatile_stake_info.is_none() {
        return Responses::NotFound.into();
    }

    Responses::Ok(Json(FullStakeInfo {
        volatile: volatile_stake_info.unwrap_or_default(),
        persistent: persistent_stake_info.unwrap_or_default(),
    }))
    .into()
}

/// TXO information used when calculating a user's stake info.
struct TxoInfo {
    /// TXO value.
    value: num_bigint::BigInt,
    /// TXO transaction index within the slot.
    txn: i16,
    /// TXO index.
    txo: i16,
    /// TXO transaction slot number.
    slot_no: num_bigint::BigInt,
    /// Whether the TXO was spent.
    spent_slot_no: Option<num_bigint::BigInt>,
}

/// Calculate the stake info for a given stake address.
///
/// This function also updates the spent column if it detects that a TXO was spent
/// between lookups.
async fn calculate_stake_info(
    persistent: bool, stake_address: StakeAddress, slot_num: Option<SlotNumber>,
) -> anyhow::Result<Option<StakeInfo>> {
    let Some(session) = CassandraSession::get(persistent) else {
        anyhow::bail!("Failed to acquire db session");
    };

    let stake_address_bytes = stake_address.payload().as_hash().to_vec();

    let mut txos_by_txn = get_txo_by_txn(&session, stake_address_bytes.clone(), slot_num).await?;
    if txos_by_txn.is_empty() {
        return Ok(None);
    }

    check_and_set_spent(&session, &mut txos_by_txn).await?;
    // TODO: This could be executed in the background, it does not actually matter if it
    // succeeds. This is just an optimization step to reduce the need to query spent
    // TXO's.
    update_spent(&session, stake_address_bytes, &txos_by_txn).await?;

    let stake_info = build_stake_info(txos_by_txn)?;

    Ok(Some(stake_info))
}

/// Returns a map of TXO infos by transaction hash for the given stake address.
async fn get_txo_by_txn(
    session: &CassandraSession, stake_address: Vec<u8>, slot_num: Option<SlotNumber>,
) -> anyhow::Result<HashMap<Vec<u8>, HashMap<i16, TxoInfo>>> {
    let mut txos_iter = GetTxoByStakeAddressQuery::execute(
        session,
        GetTxoByStakeAddressQueryParams::new(
            stake_address,
            num_bigint::BigInt::from(slot_num.unwrap_or(i64::MAX)),
        ),
    )
    .await?;

    let mut txos_by_txn = HashMap::new();
    while let Some(row_res) = txos_iter.next().await {
        let row = row_res?;

        // Filter out already known spent TXOs.
        if row.spent_slot.is_some() {
            continue;
        }

        let txn_map = txos_by_txn.entry(row.txn_hash).or_insert(HashMap::new());
        txn_map.insert(row.txo, TxoInfo {
            value: row.value,
            txn: row.txn,
            txo: row.txo,
            slot_no: row.slot_no,
            spent_slot_no: None,
        });
    }

    Ok(txos_by_txn)
}

/// Checks if the given TXOs were spent and mark then as such.
async fn check_and_set_spent(
    session: &CassandraSession, txos_by_txn: &mut HashMap<Vec<u8>, HashMap<i16, TxoInfo>>,
) -> anyhow::Result<()> {
    let txn_hashes = txos_by_txn.keys().cloned().collect::<Vec<_>>();

    for chunk in txn_hashes.chunks(100) {
        let mut txi_iter = GetTxiByTxnHashesQuery::execute(
            session,
            GetTxiByTxnHashesQueryParams::new(chunk.to_vec()),
        )
        .await?;

        while let Some(row_res) = txi_iter.next().await {
            let row = row_res?;

            if let Some(txn_map) = txos_by_txn.get_mut(&row.txn_hash) {
                if let Some(txo_info) = txn_map.get_mut(&row.txo) {
                    if row.slot_no >= num_bigint::BigInt::ZERO {
                        txo_info.spent_slot_no = Some(row.slot_no);
                    }
                }
            }
        }
    }

    Ok(())
}

/// Sets TXOs as spent in the database if they are marked as spent in the map.
async fn update_spent(
    session: &CassandraSession, stake_address: Vec<u8>,
    txos_by_txn: &HashMap<Vec<u8>, HashMap<i16, TxoInfo>>,
) -> anyhow::Result<()> {
    let mut params = Vec::new();
    for txn_map in txos_by_txn.values() {
        for txo_info in txn_map.values() {
            if txo_info.spent_slot_no.is_none() {
                continue;
            }

            if let Some(spent_slot) = &txo_info.spent_slot_no {
                params.push(UpdateTxoSpentQueryParams {
                    stake_address: stake_address.clone(),
                    txn: txo_info.txn,
                    txo: txo_info.txo,
                    slot_no: txo_info.slot_no.clone(),
                    spent_slot: spent_slot.clone(),
                });
            }
        }
    }

    UpdateTxoSpentQuery::execute(session, params).await?;

    Ok(())
}

/// Builds an instance of [`StakeInfo`] based on the TXOs given.
fn build_stake_info(
    txos_by_txn: HashMap<Vec<u8>, HashMap<i16, TxoInfo>>,
) -> anyhow::Result<StakeInfo> {
    let mut stake_info = StakeInfo::default();
    for txn_map in txos_by_txn.into_values() {
        for txo_info in txn_map.into_values() {
            if txo_info.spent_slot_no.is_none() {
                stake_info.amount += i64::try_from(txo_info.value).map_err(|err| anyhow!(err))?;

                let slot_no = i64::try_from(txo_info.slot_no).map_err(|err| anyhow!(err))?;

                if stake_info.slot_number < slot_no {
                    stake_info.slot_number = slot_no;
                }
            }
        }
    }

    Ok(stake_info)
}
