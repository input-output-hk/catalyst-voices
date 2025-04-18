//! Implementation of the GET `../assets` endpoint

use std::{
    collections::{HashMap, HashSet},
    sync::Arc,
};

use cardano_blockchain_types::{Slot, StakeAddress, TransactionId, TxnIndex};
use futures::TryStreamExt;
use poem_openapi::{payload::Json, ApiResponse};
use tracing::debug;

use crate::{
    db::index::{
        queries::staked_ada::{
            get_assets_by_stake_address::{
                GetAssetsByStakeAddressParams, GetAssetsByStakeAddressQuery,
            },
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
            stake_info::{FullStakeInfo, StakeInfo, StakedTxoAssetInfo},
        },
        responses::WithErrorResponses,
        types::{
            cardano::{
                asset_name::AssetName, cip19_stake_address::Cip19StakeAddress, slot_no::SlotNo,
            },
            headers::retry_after::RetryAfterOption,
        },
    },
    settings::Settings,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## Ok
    ///
    /// The amount of ADA staked by the queried stake address, as at the indicated slot.
    #[oai(status = 200)]
    Ok(Json<FullStakeInfo>),
    /// ## Not Found
    ///
    /// The queried stake address was not found at the requested slot number.
    #[oai(status = 404)]
    NotFound,
}

/// All responses.
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// # GET `/staked_ada`
pub(crate) async fn endpoint(
    stake_address: Cip19StakeAddress, provided_network: Option<Network>, slot_num: Option<SlotNo>,
) -> AllResponses {
    if let Some(provided_network) = provided_network {
        if cardano_blockchain_types::Network::from(provided_network) != Settings::cardano_network()
        {
            return Responses::NotFound.into();
        }
    }

    let (persistent_stake_info, txo_state) = {
        let Some(persistent_session) = CassandraSession::get(true) else {
            tracing::error!("Failed to acquire persistent db session");
            return AllResponses::service_unavailable(
                &anyhow::anyhow!("Failed to acquire db session"),
                RetryAfterOption::Default,
            );
        };
        let persistent_res =
            calculate_stake_info(persistent_session, stake_address.clone(), slot_num, None).await;
        match persistent_res {
            Ok(Some((stake_info, txo_state))) => (stake_info, txo_state),
            Ok(None) => return Responses::NotFound.into(),
            Err(err) => return AllResponses::handle_error(&err),
        }
    };

    let volatile_stake_info = {
        let Some(volatile_session) = CassandraSession::get(false) else {
            tracing::error!("Failed to acquire volatile db session");
            return AllResponses::service_unavailable(
                &anyhow::anyhow!("Failed to acquire volatile db session"),
                RetryAfterOption::Default,
            );
        };
        let volatile_res =
            calculate_stake_info(volatile_session, stake_address, slot_num, Some(txo_state)).await;
        match volatile_res {
            Ok(Some((stake_info, _))) => stake_info,
            Ok(None) => return Responses::NotFound.into(),
            Err(err) => return AllResponses::handle_error(&err),
        }
    };

    Responses::Ok(Json(FullStakeInfo {
        volatile: volatile_stake_info.into(),
        persistent: persistent_stake_info.into(),
    }))
    .into()
}

/// TXO asset information.
#[derive(Clone)]
struct TxoAssetInfo {
    /// Asset hash.
    id: Vec<u8>,
    /// Asset name.
    name: AssetName,
    /// Asset amount.
    amount: num_bigint::BigInt,
}

/// TXO information used when calculating a user's stake info.
#[derive(Clone)]
struct TxoInfo {
    /// TXO value.
    value: num_bigint::BigInt,
    /// TXO transaction index within the slot.
    txn_index: TxnIndex,
    /// TXO index.
    txo: i16,
    /// TXO transaction slot number.
    slot_no: Slot,
    /// Whether the TXO was spent.
    spent_slot_no: Option<Slot>,
}

/// Calculate the stake info for a given stake address.
///
/// This function also updates the spent column if it detects that a TXO was spent
/// between lookups.
async fn calculate_stake_info(
    session: Arc<CassandraSession>, stake_address: Cip19StakeAddress, slot_num: Option<SlotNo>,
    txo_base_state: Option<TxoAssetsState>,
) -> anyhow::Result<Option<(StakeInfo, TxoAssetsState)>> {
    let address: StakeAddress = stake_address.try_into()?;
    let adjusted_slot_num = slot_num.unwrap_or(SlotNo::MAXIMUM);

    let (txos, txo_assets) = futures::try_join!(
        get_txo(&session, &address, adjusted_slot_num),
        get_txo_assets(&session, &address, adjusted_slot_num)
    )?;

    let (mut txos, txo_assets) = if let Some(TxoAssetsState {
        txos: base_txos,
        txo_assets: base_assets,
    }) = txo_base_state
    {
        // Extend the base state with current session data (used to calculate volatile data)
        (
            base_txos.into_iter().chain(txos).collect(),
            base_assets.into_iter().chain(txo_assets).collect(),
        )
    } else {
        (txos, txo_assets)
    };

    let params = update_spent(&session, &address, &mut txos).await?;

    // Sets TXOs as spent in the database in the background.
    tokio::spawn(async move {
        if let Err(err) = UpdateTxoSpentQuery::execute(&session, params).await {
            tracing::error!("Failed to update TXO spent info, err: {err}");
        }
    });

    if txos.is_empty() && txo_assets.is_empty() {
        return Ok(None);
    }

    let stake_info = build_stake_info(txos.clone(), txo_assets.clone(), adjusted_slot_num)?;

    Ok(Some((stake_info, TxoAssetsState { txos, txo_assets })))
}

/// `TxoInfo` map type alias
type TxoMap = HashMap<(TransactionId, i16), TxoInfo>;

/// Returns a map of TXO infos for the given stake address.
async fn get_txo(
    session: &CassandraSession, stake_address: &StakeAddress, slot_num: SlotNo,
) -> anyhow::Result<TxoMap> {
    let txos_stream = GetTxoByStakeAddressQuery::execute(
        session,
        GetTxoByStakeAddressQueryParams::new(stake_address.clone(), slot_num.into()),
    )
    .await?;

    let txo_map = txos_stream
        .map_err(Into::<anyhow::Error>::into)
        .try_fold(HashMap::new(), |mut txo_map, row| {
            async move {
                let key = (row.txn_id.into(), row.txo.into());
                txo_map.insert(key, TxoInfo {
                    value: row.value,
                    txn_index: row.txn_index.into(),
                    txo: row.txo.into(),
                    slot_no: row.slot_no.into(),
                    spent_slot_no: row.spent_slot.map(Into::into),
                });
                Ok(txo_map)
            }
        })
        .await?;
    Ok(txo_map)
}

/// TXO Assets map type alias
type TxoAssetsMap = HashMap<(Slot, TxnIndex, i16), TxoAssetInfo>;

/// TXO Assets state
struct TxoAssetsState {
    /// TXO Info map
    txos: TxoMap,
    /// TXO Assets map
    txo_assets: TxoAssetsMap,
}

/// Returns a map of txo asset infos for the given stake address.
async fn get_txo_assets(
    session: &CassandraSession, stake_address: &StakeAddress, slot_num: SlotNo,
) -> anyhow::Result<TxoAssetsMap> {
    let assets_txos_stream = GetAssetsByStakeAddressQuery::execute(
        session,
        GetAssetsByStakeAddressParams::new(stake_address.clone(), slot_num.into()),
    )
    .await?;

    let tokens_map = assets_txos_stream
        .map_err(Into::<anyhow::Error>::into)
        .try_fold(HashMap::new(), |mut tokens_map, row| {
            async move {
                let key = (row.slot_no.into(), row.txn_index.into(), row.txo.into());
                tokens_map.insert(key, TxoAssetInfo {
                    id: row.policy_id,
                    name: row.asset_name.into(),
                    amount: row.value,
                });
                Ok(tokens_map)
            }
        })
        .await?;
    Ok(tokens_map)
}

/// Checks if the given TXOs were spent and mark then as such.
async fn update_spent(
    session: &CassandraSession, stake_address: &StakeAddress, txos: &mut TxoMap,
) -> anyhow::Result<Vec<UpdateTxoSpentQueryParams>> {
    let txn_hashes = txos
        .iter()
        .filter(|(_, txo)| txo.spent_slot_no.is_none())
        .map(|((tx_id, _), _)| *tx_id)
        .collect::<HashSet<_>>()
        .into_iter()
        .collect::<Vec<_>>();

    let mut params = Vec::new();

    for chunk in txn_hashes.chunks(100) {
        let mut txi_stream = GetTxiByTxnHashesQuery::execute(
            session,
            GetTxiByTxnHashesQueryParams::new(chunk.to_vec()),
        )
        .await?;

        while let Some(row) = txi_stream.try_next().await? {
            let key = (row.txn_id.into(), row.txo.into());
            if let Some(txo_info) = txos.get_mut(&key) {
                params.push(UpdateTxoSpentQueryParams {
                    stake_address: stake_address.clone().into(),
                    txn_index: txo_info.txn_index.into(),
                    txo: txo_info.txo.into(),
                    slot_no: txo_info.slot_no.into(),
                    spent_slot: row.slot_no,
                });

                txo_info.spent_slot_no = Some(row.slot_no.into());
            }
        }
    }

    Ok(params)
}

/// Builds an instance of [`StakeInfo`] based on the TXOs given.
fn build_stake_info(
    txos: TxoMap, mut tokens: TxoAssetsMap, slot_num: SlotNo,
) -> anyhow::Result<StakeInfo> {
    let slot_num = slot_num.into();
    let mut stake_info = StakeInfo::default();
    for txo_info in txos.into_values() {
        // Filter out spent TXOs.
        if let Some(spent_slot) = txo_info.spent_slot_no {
            if spent_slot <= slot_num {
                continue;
            }
        }

        let value = u64::try_from(txo_info.value)?;
        stake_info.ada_amount = stake_info
            .ada_amount
            .checked_add(value)
            .ok_or_else(|| {
                anyhow::anyhow!(
                    "Total stake amount overflow: {} + {value}",
                    stake_info.ada_amount
                )
            })?
            .into();

        let key = (txo_info.slot_no, txo_info.txn_index, txo_info.txo);
        if let Some(native_token) = tokens.remove(&key) {
            match native_token.amount.try_into() {
                Ok(amount) => {
                    stake_info.assets.push(StakedTxoAssetInfo {
                        policy_hash: native_token.id.try_into()?,
                        asset_name: native_token.name,
                        amount,
                    });
                },
                Err(e) => {
                    debug!("Invalid TXO Asset for {key:?}: {e}");
                },
            }
        }

        let slot_no = txo_info.slot_no.into();
        if stake_info.slot_number < slot_no {
            stake_info.slot_number = slot_no;
        }
    }

    Ok(stake_info)
}
