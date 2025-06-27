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
        session::{CassandraSession, CassandraSessionError},
    },
    service::common::{
        objects::cardano::{
            network::Network,
            stake_info::{FullStakeInfo, StakeInfo, StakedTxoAssetInfo},
        },
        responses::WithErrorResponses,
        types::cardano::{
            ada_value::AdaValue, asset_name::AssetName, asset_value::AssetValue,
            cip19_stake_address::Cip19StakeAddress, hash28::HexEncodedHash28, slot_no::SlotNo,
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
    match build_full_stake_info_response(stake_address, provided_network, slot_num).await {
        Ok(None) => Responses::NotFound.into(),
        Ok(Some(full_stake_info)) => Responses::Ok(Json(full_stake_info)).into(),
        Err(err) => AllResponses::handle_error(&err),
    }
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

/// Building a full stake info response from the provided arguments.
async fn build_full_stake_info_response(
    stake_address: Cip19StakeAddress, provided_network: Option<Network>, slot_num: Option<SlotNo>,
) -> anyhow::Result<Option<FullStakeInfo>> {
    if let Some(provided_network) = provided_network {
        if cardano_blockchain_types::Network::from(provided_network) != Settings::cardano_network()
        {
            return Ok(None);
        }
    }
    let persistent_session =
        CassandraSession::get(true).ok_or(CassandraSessionError::FailedAcquiringSession)?;
    let volatile_session =
        CassandraSession::get(false).ok_or(CassandraSessionError::FailedAcquiringSession)?;
    let adjusted_slot_num = slot_num.unwrap_or(SlotNo::MAXIMUM);

    let persistent_txo_state = calculate_assets_state(
        persistent_session,
        stake_address.clone(),
        adjusted_slot_num,
        TxoAssetsState::default(),
    )
    .await?;

    let volatile_txo_state = calculate_assets_state(
        volatile_session,
        stake_address.clone(),
        adjusted_slot_num,
        persistent_txo_state.clone(),
    )
    .await?;

    if volatile_txo_state.is_empty() && persistent_txo_state.is_empty() {
        return Ok(None);
    }
    let persistent_stake_info = build_stake_info(persistent_txo_state, adjusted_slot_num)?;

    let volatile_stake_info = build_stake_info(volatile_txo_state, adjusted_slot_num)?;

    Ok(Some(FullStakeInfo {
        volatile: volatile_stake_info.into(),
        persistent: persistent_stake_info.into(),
    }))
}

/// Calculate the assets state info for a given stake address.
///
/// This function also updates the spent column if it detects that a TXO was spent
/// between lookups.
async fn calculate_assets_state(
    session: Arc<CassandraSession>, stake_address: Cip19StakeAddress, slot_num: SlotNo,
    mut txo_base_state: TxoAssetsState,
) -> anyhow::Result<TxoAssetsState> {
    let address: StakeAddress = stake_address.try_into()?;

    let (mut txos, txo_assets) = futures::try_join!(
        get_txo(&session, &address),
        get_txo_assets(&session, &address, slot_num)
    )?;

    let params = update_spent(&session, &address, &mut txo_base_state.txos, &mut txos).await?;

    // Extend the base state with current session data (used to calculate volatile data)
    let txos = txo_base_state.txos.into_iter().chain(txos).collect();
    let txo_assets: HashMap<_, _> = txo_base_state
        .txo_assets
        .into_iter()
        .chain(txo_assets)
        .collect();

    // Sets TXOs as spent in the database in the background.
    tokio::spawn(async move {
        if let Err(err) = UpdateTxoSpentQuery::execute(&session, params).await {
            tracing::error!("Failed to update TXO spent info, err: {err}");
        }
    });

    Ok(TxoAssetsState { txos, txo_assets })
}

/// `TxoInfo` map type alias
type TxoMap = HashMap<(TransactionId, i16), TxoInfo>;

/// Returns a map of TXO infos for the given stake address.
async fn get_txo(
    session: &CassandraSession, stake_address: &StakeAddress,
) -> anyhow::Result<TxoMap> {
    let txos_stream = GetTxoByStakeAddressQuery::execute(
        session,
        GetTxoByStakeAddressQueryParams::new(stake_address.clone()),
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
type TxoAssetsMap = HashMap<(Slot, TxnIndex, i16), Vec<TxoAssetInfo>>;

/// TXO Assets state
#[derive(Default, Clone)]
struct TxoAssetsState {
    /// TXO Info map
    txos: TxoMap,
    /// TXO Assets map
    txo_assets: TxoAssetsMap,
}

impl TxoAssetsState {
    /// Returns true if underlying `txos` and `txo_assets` are empty, false otherwise
    fn is_empty(&self) -> bool {
        self.txos.is_empty() && self.txo_assets.is_empty()
    }
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
        .try_fold(HashMap::new(), |mut tokens_map: TxoAssetsMap, row| {
            async move {
                let key = (row.slot_no.into(), row.txn_index.into(), row.txo.into());
                match tokens_map.entry(key) {
                    std::collections::hash_map::Entry::Occupied(mut o) => {
                        o.get_mut().push(TxoAssetInfo {
                            id: row.policy_id,
                            name: row.asset_name.into(),
                            amount: row.value,
                        });
                    },
                    std::collections::hash_map::Entry::Vacant(v) => {
                        v.insert(vec![TxoAssetInfo {
                            id: row.policy_id,
                            name: row.asset_name.into(),
                            amount: row.value,
                        }]);
                    },
                }
                Ok(tokens_map)
            }
        })
        .await?;
    Ok(tokens_map)
}

/// Checks if the given TXOs were spent and mark then as such.
/// Separating `base_txos` and `txos` because we dont want to make an update inside the db
/// for the `base_txos` data (it is covering the case when inside the persistent part we
/// have a txo which is spent inside the volatile, so to not incorrectly mix up records
/// from these two tables, inserting some rows from persistent to volatile section).
async fn update_spent(
    session: &CassandraSession, stake_address: &StakeAddress, base_txos: &mut TxoMap,
    txos: &mut TxoMap,
) -> anyhow::Result<Vec<UpdateTxoSpentQueryParams>> {
    let txn_hashes = txos
        .iter()
        .chain(base_txos.iter())
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
            if let Some(txo_info) = base_txos.get_mut(&key) {
                txo_info.spent_slot_no = Some(row.slot_no.into());
            }
        }
    }

    Ok(params)
}

/// Builds an instance of [`StakeInfo`] based on the TXOs given.
fn build_stake_info(mut txo_state: TxoAssetsState, slot_num: SlotNo) -> anyhow::Result<StakeInfo> {
    let slot_num = slot_num.into();
    let mut total_ada_amount = AdaValue::default();
    let mut last_slot_num = SlotNo::default();
    let mut assets = HashMap::<(HexEncodedHash28, AssetName), AssetValue>::new();

    for txo_info in txo_state.txos.into_values() {
        // Filter out spent TXOs.
        if let Some(spent_slot) = txo_info.spent_slot_no {
            if spent_slot <= slot_num {
                continue;
            }
        }

        let value = AdaValue::try_from(txo_info.value)?;
        total_ada_amount = total_ada_amount.saturating_add(value);

        let key = (txo_info.slot_no, txo_info.txn_index, txo_info.txo);
        if let Some(native_assets) = txo_state.txo_assets.remove(&key) {
            for native_asset in native_assets {
                match native_asset.amount.try_into() {
                    Ok(amount) => {
                        match assets.entry((native_asset.id.try_into()?, native_asset.name)) {
                            std::collections::hash_map::Entry::Occupied(mut o) => {
                                *o.get_mut() = o.get().saturating_add(&amount);
                            },
                            std::collections::hash_map::Entry::Vacant(v) => {
                                v.insert(amount);
                            },
                        }
                    },
                    Err(e) => {
                        debug!("Invalid TXO Asset for {key:?}: {e}");
                    },
                }
            }
        }

        let slot_no = txo_info.slot_no.into();
        if last_slot_num < slot_no {
            last_slot_num = slot_no;
        }
    }

    Ok(StakeInfo {
        ada_amount: total_ada_amount,
        slot_number: last_slot_num,
        assets: assets
            .into_iter()
            .map(|((policy_hash, asset_name), amount)| {
                StakedTxoAssetInfo {
                    policy_hash,
                    asset_name,
                    amount,
                }
            })
            .collect::<Vec<_>>()
            .into(),
    })
}
