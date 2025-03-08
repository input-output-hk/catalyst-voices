//! Implementation of the GET `/cardano/cip36` endpoint

use std::sync::Arc;

use cardano_blockchain_types::StakeAddress;
use dashmap::DashMap;
use futures::StreamExt;
use tracing::error;

use super::{
    cardano::{cip19_shelley_address::Cip19ShelleyAddress, nonce::Nonce},
    common::types::generic::error_msg::ErrorMessage,
    response::{Cip36Details, Cip36Registration, Cip36RegistrationList},
    Ed25519HexEncodedPublicKey, SlotNo,
};
use crate::{
    db::index::{
        queries::registrations::{
            get_all_invalids::{GetAllInvalidRegistrationsParams, GetAllInvalidRegistrationsQuery},
            get_all_registrations::{GetAllRegistrationsParams, GetAllRegistrationsQuery},
            get_from_stake_addr::{GetRegistrationParams, GetRegistrationQuery},
            get_invalid::{GetInvalidRegistrationParams, GetInvalidRegistrationQuery},
            get_stake_pk_from_stake_addr::{
                GetStakePublicKeyFromStakeAddrParams, GetStakePublicKeyFromStakeAddrQuery,
            },
            get_stake_pk_from_vote_key::{
                GetStakePublicKeyFromVoteKeyParams, GetStakePublicKeyFromVoteKeyQuery,
            },
        },
        session::CassandraSession,
    },
    service::common::{
        self, objects::generic::pagination::CurrentPage,
        types::generic::query::pagination::Remaining,
    },
};

/// Get registrations given a stake address, it can be time specific based on asat param,
/// or the latest registration returned if no asat given.
pub(crate) async fn get_registrations_given_stake_addr(
    stake_address: StakeAddress, session: Arc<CassandraSession>, asat: Option<SlotNo>,
    page: common::types::generic::query::pagination::Page,
    limit: common::types::generic::query::pagination::Limit, invalid: bool,
) -> anyhow::Result<Cip36Registration> {
    // Get stake public key associated with given stake address.
    let mut stake_pk_iter = GetStakePublicKeyFromStakeAddrQuery::execute(
        &session,
        GetStakePublicKeyFromStakeAddrParams::new(stake_address),
    )
    .await?;

    let Some(row_stake_pk) = stake_pk_iter.next().await else {
        return Ok(Cip36Registration::NotFound);
    };
    let stake_public_key = row_stake_pk?.stake_public_key;

    let all_regs = if invalid {
        get_invalid_registrations(&session, stake_public_key).await?
    } else {
        get_valid_registrations(&session, stake_public_key).await?
    };

    let all_regs = filter_and_sort_registrations(all_regs, asat);

    if all_regs.is_empty() {
        return Ok(Cip36Registration::NotFound);
    }

    let (all_regs, remaining) = paginate_registrations(all_regs, page.into(), limit.into())?;

    let res = Cip36RegistrationList {
        is_valid: !invalid,
        regs: all_regs.into(),
        page: Some(
            CurrentPage {
                page,
                limit,
                remaining,
            }
            .into(),
        ),
    };
    Ok(Cip36Registration::Ok(poem_openapi::payload::Json(res)))
}

/// Get valid cip36 registrations for a given stake public key.
async fn get_valid_registrations(
    session: &CassandraSession, stake_public_key: Vec<u8>,
) -> Result<Vec<Cip36Details>, anyhow::Error> {
    let hex_stake_pk = Ed25519HexEncodedPublicKey::try_from(stake_public_key.as_slice())
        .map_err(|err| anyhow::anyhow!("Failed to convert to type stake public key {err}"))?;

    let mut registrations_iter =
        GetRegistrationQuery::execute(session, GetRegistrationParams { stake_public_key }).await?;

    let mut registrations = Vec::new();
    while let Some(row) = registrations_iter.next().await {
        let row = row?;

        let Ok(nonce) = u64::try_from(row.nonce) else {
            anyhow::bail!("Corrupt valid registration, cannot decode nonce");
        };

        let slot_no: u64 = row.slot_no.into();

        let slot_no = match SlotNo::try_from(slot_no) {
            Ok(slot_no) => slot_no,
            Err(err) => {
                anyhow::bail!("Corrupt valid registration, invalid slot_no {err}");
            },
        };

        let payment_address = match Cip19ShelleyAddress::try_from(row.payment_address) {
            Ok(payment_addr) => Some(payment_addr),
            Err(err) => {
                anyhow::bail!(
                    "Corrupt valid registration, invalid payment_address {err}\n Stake pub key: {}",
                    *hex_stake_pk
                );
            },
        };

        let vote_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.vote_key) {
            Ok(vote_pub_key) => Some(vote_pub_key),
            Err(err) => {
                anyhow::bail!(
                    "Corrupt valid registration, invalid vote_pub_key {err}\n Stake pub key:{:?}",
                    *hex_stake_pk
                );
            },
        };

        let cip36 = Cip36Details {
            slot_no,
            stake_pub_key: Some(hex_stake_pk.clone()),
            vote_pub_key,
            nonce: Some(Nonce::from(nonce)),
            txn_index: Some(row.txn_index.into()),
            payment_address,
            is_payable: row.is_payable.into(),
            cip15: (!row.cip36).into(),
            errors: None,
        };

        registrations.push(cip36);
    }
    Ok(registrations)
}

/// Filter registrations by the provided lost if provided then sort registrations by slot
/// number, nonce, and transaction offset. If `slot_no` is the same, the registration with
/// the highest `nonce` wins. If `nonce` is the same, the registration with the highest
/// `txn_offset` wins. The latest one is considered the only valid registration. The rest
/// are invalid.
fn filter_and_sort_registrations(
    mut registrations: Vec<Cip36Details>, slot_no: Option<SlotNo>,
) -> Vec<Cip36Details> {
    // Filter registrations by the provided lost if provided
    if let Some(slot_no) = slot_no {
        registrations.retain(|registration| registration.slot_no <= slot_no);
    }

    // Sort registrations by slot_no, nonce, and txn_offset in descending order
    registrations.sort_by(|a, b| {
        // Compare by slot_no (descending)
        // Safe to use 0 value,  since ordering in descending order
        b.slot_no
            .cmp(&a.slot_no)
            .then_with(|| {
                b.nonce
                    .clone()
                    .unwrap_or_default()
                    .cmp(&a.nonce.clone().unwrap_or_default())
            }) // If slot_no is the same, compare by nonce (descending)
            .then_with(|| {
                b.txn_index
                    .clone()
                    .unwrap_or_default()
                    .cmp(&a.txn_index.clone().unwrap_or_default())
            }) // If nonce is also the same, compare by txn_offset (descending)
    });

    registrations
}

/// Get invalid registrations for stake public key
async fn get_invalid_registrations(
    session: &CassandraSession, stake_public_key: Vec<u8>,
) -> anyhow::Result<Vec<Cip36Details>> {
    let mut invalid_registrations_iter =
        GetInvalidRegistrationQuery::execute(session, GetInvalidRegistrationParams {
            stake_public_key,
        })
        .await?;
    let mut invalid_registrations = Vec::new();
    while let Some(row) = invalid_registrations_iter.next().await {
        let row = row?;
        let slot_no: u64 = row.slot_no.into();
        let slot_no = match SlotNo::try_from(slot_no) {
            Ok(slot_no) => slot_no,
            Err(err) => {
                error!("Corrupt invalid registration {err}");
                // This should NOT happen, valid registrations should be infallible.
                // If it happens, there is an indexing issue.
                continue;
            },
        };
        let payment_address = Cip19ShelleyAddress::try_from(row.payment_address).ok();
        let vote_pub_key = Ed25519HexEncodedPublicKey::try_from(row.vote_key).ok();
        let stake_pub_key = Ed25519HexEncodedPublicKey::try_from(row.stake_public_key.clone()).ok();

        invalid_registrations.push(Cip36Details {
            slot_no,
            stake_pub_key,
            vote_pub_key,
            nonce: None,
            txn_index: None,
            payment_address,
            is_payable: row.is_payable.into(),
            cip15: (!row.cip36).into(),
            errors: Some(ErrorMessage::from(row.problem_report)),
        });
    }

    Ok(invalid_registrations)
}

/// Get registrations given a vote key, time specific based on asat param,
/// or latest registration returned if no asat given.
pub(crate) async fn get_registrations_given_vote_key(
    vote_key: Ed25519HexEncodedPublicKey, session: Arc<CassandraSession>, asat: Option<SlotNo>,
    page: common::types::generic::query::pagination::Page,
    limit: common::types::generic::query::pagination::Limit, invalid: bool,
) -> anyhow::Result<Cip36Registration> {
    let voting_key: Vec<u8> = vote_key
        .try_into()
        .map_err(|err| anyhow::anyhow!("Failed to convert vote key to bytes {err:?}"))?;

    // Get stake public key associated voting key
    let mut stake_pk_iter = GetStakePublicKeyFromVoteKeyQuery::execute(
        &session,
        GetStakePublicKeyFromVoteKeyParams::new(voting_key),
    )
    .await
    .map_err(|err| anyhow::anyhow!("Failed to query stake public key from vote key {err:?}",))?;

    let mut all_regs = Vec::new();
    while let Some(row_stake_pk) = stake_pk_iter.next().await {
        let stake_public_key = row_stake_pk?.stake_public_key;

        let regs = if invalid {
            get_invalid_registrations(&session, stake_public_key.clone()).await?
        } else {
            get_valid_registrations(&session, stake_public_key.clone()).await?
        };

        all_regs.extend(regs);
    }

    let all_regs = filter_and_sort_registrations(all_regs, asat);

    if all_regs.is_empty() {
        return Ok(Cip36Registration::NotFound);
    }

    let (all_regs, remaining) = paginate_registrations(all_regs, page.into(), limit.into())?;

    Ok(Cip36Registration::Ok(poem_openapi::payload::Json(
        Cip36RegistrationList {
            is_valid: !invalid,
            regs: all_regs.into(),
            page: Some(
                CurrentPage {
                    page,
                    limit,
                    remaining,
                }
                .into(),
            ),
        },
    )))
}

/// Get all registrations or constrain if slot# given.
pub async fn snapshot(
    session: Arc<CassandraSession>, asat: Option<SlotNo>, invalid: bool,
) -> anyhow::Result<Cip36Registration> {
    let all_regs = if invalid {
        get_all_invalid_registrations(&session).await?
    } else {
        get_all_valid_registrations(&session).await?
    };

    let all_regs = all_regs.into_iter().flat_map(|(_, reg)| reg).collect();
    let all_regs = filter_and_sort_registrations(all_regs, asat);

    Ok(Cip36Registration::Ok(poem_openapi::payload::Json(
        Cip36RegistrationList {
            is_valid: !invalid,
            regs: all_regs.into(),
            page: None,
        },
    )))
}

/// Get all valid cip36 registrations.
async fn get_all_valid_registrations(
    session: &CassandraSession,
) -> Result<DashMap<Ed25519HexEncodedPublicKey, Vec<Cip36Details>>, anyhow::Error> {
    let mut registrations_iter =
        GetAllRegistrationsQuery::execute(session, GetAllRegistrationsParams {}).await?;

    let registrations_map: DashMap<Ed25519HexEncodedPublicKey, Vec<Cip36Details>> = DashMap::new();

    while let Some(row) = registrations_iter.next().await {
        let row = row?;

        let Ok(nonce) = u64::try_from(row.nonce) else {
            anyhow::bail!("Corrupt valid registration, cannot decode nonce");
        };

        let Ok(slot_no) = u64::try_from(row.slot_no) else {
            anyhow::bail!("Corrupt valid registration, cannot decode slot_no");
        };

        let slot_no = match SlotNo::try_from(slot_no) {
            Ok(slot_no) => slot_no,
            Err(err) => {
                anyhow::bail!("Corrupt valid registration, invalid slot_no {err}");
            },
        };

        let stake_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.stake_public_key.clone())
        {
            Ok(stake_pub_key) => Some(stake_pub_key),
            Err(err) => {
                anyhow::bail!("Corrupt valid registration, invalid stake_pub_key {err}");
            },
        };

        let payment_address = match Cip19ShelleyAddress::try_from(row.payment_address) {
            Ok(payment_addr) => Some(payment_addr),
            Err(err) => {
                anyhow::bail!("Corrupt valid registration, invalid payment_address {err}\n Stake pub key:{stake_pub_key:?}");
            },
        };

        let vote_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.vote_key) {
            Ok(vote_pub_key) => Some(vote_pub_key),
            Err(err) => {
                anyhow::bail!("Corrupt valid registration, invalid vote_pub_key {err}\n Stake pub key:{stake_pub_key:?}");
            },
        };

        let cip36 = Cip36Details {
            slot_no,
            stake_pub_key,
            vote_pub_key,
            nonce: Some(Nonce::from(nonce)),
            txn_index: Some(row.txn_index.into()),
            payment_address,
            is_payable: row.is_payable.into(),
            cip15: (!row.cip36).into(),
            errors: None,
        };

        if let Some(mut v) = registrations_map.get_mut(&Ed25519HexEncodedPublicKey::try_from(
            row.stake_public_key.clone(),
        )?) {
            v.push(cip36);
            continue;
        };

        registrations_map.insert(
            Ed25519HexEncodedPublicKey::try_from(row.stake_public_key)?,
            vec![cip36],
        );
    }

    Ok(registrations_map)
}

/// Get all invalid registrations
async fn get_all_invalid_registrations(
    session: &CassandraSession,
) -> Result<DashMap<Ed25519HexEncodedPublicKey, Vec<Cip36Details>>, anyhow::Error> {
    let invalids_map: DashMap<Ed25519HexEncodedPublicKey, Vec<Cip36Details>> = DashMap::new();

    let mut invalid_registrations_iter =
        GetAllInvalidRegistrationsQuery::execute(session, GetAllInvalidRegistrationsParams {})
            .await?;

    while let Some(row) = invalid_registrations_iter.next().await {
        let row = row?;

        let Ok(slot_no) = u64::try_from(row.slot_no) else {
            anyhow::bail!("Corrupt valid registration, cannot decode slot_no");
        };

        let slot_no = SlotNo::try_from(slot_no).unwrap_or_default();

        let payment_addr = Cip19ShelleyAddress::try_from(row.payment_address).ok();

        let vote_pub_key = Ed25519HexEncodedPublicKey::try_from(row.vote_key).ok();

        let stake_pub_key = Ed25519HexEncodedPublicKey::try_from(row.stake_public_key.clone()).ok();

        let invalid = Cip36Details {
            slot_no,
            stake_pub_key,
            vote_pub_key,
            nonce: None,
            txn_index: None,
            payment_address: payment_addr,
            is_payable: row.is_payable.into(),
            cip15: (!row.cip36).into(),
            errors: Some(ErrorMessage::from(row.problem_report)),
        };

        if let Some(mut v) = invalids_map.get_mut(&Ed25519HexEncodedPublicKey::try_from(
            row.stake_public_key.clone(),
        )?) {
            v.push(invalid);
            continue;
        };

        invalids_map.insert(
            Ed25519HexEncodedPublicKey::try_from(row.stake_public_key)?,
            vec![invalid],
        );
    }

    Ok(invalids_map)
}

/// Paginate the registrations.
#[allow(dead_code)]
fn paginate_registrations(
    regs: Vec<Cip36Details>, page: u32, limit: u32,
) -> anyhow::Result<(Vec<Cip36Details>, Remaining)> {
    let total_reg = regs.len();

    let page_usize: usize = page.try_into()?;
    let limit_usize: usize = limit.try_into()?;
    let start_index: usize = page_usize.saturating_mul(limit_usize);
    let paginated_regs: Vec<_> = regs
        .into_iter()
        .skip(start_index)
        .take(limit_usize)
        .collect();
    let reg_count = paginated_regs.len();

    let remaining = Remaining::calculate(page, limit, total_reg.try_into()?, reg_count.try_into()?);

    // Return the paginated valid, and remaining.
    Ok((paginated_regs, remaining))
}
