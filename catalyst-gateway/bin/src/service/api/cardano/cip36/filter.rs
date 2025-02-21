//! Implementation of the GET `/cardano/cip36` endpoint

use std::{cmp::Reverse, sync::Arc};

use cardano_blockchain_types::StakeAddress;
use dashmap::DashMap;
use futures::{future, StreamExt};
use rayon::iter::{IntoParallelIterator, ParallelIterator};
use tracing::error;

use super::{
    cardano::{cip19_shelley_address::Cip19ShelleyAddress, nonce::Nonce, txn_index::TxnIndex},
    common::types::generic::error_msg::ErrorMessage,
    response::{
        AllRegistration, Cip36Details, Cip36Registration, Cip36RegistrationList,
        Cip36RegistrationsForVotingPublicKey,
    },
    Ed25519HexEncodedPublicKey, SlotNo,
};
use crate::db::index::{
    queries::registrations::{
        get_all_invalids::{GetAllInvalidRegistrationsParams, GetAllInvalidRegistrationsQuery},
        get_all_registrations::{GetAllRegistrationsParams, GetAllRegistrationsQuery},
        get_from_stake_addr::{GetRegistrationParams, GetRegistrationQuery},
        get_from_stake_address::{GetStakeAddrParams, GetStakeAddrQuery},
        get_from_vote_key::{GetStakeAddrFromVoteKeyParams, GetStakeAddrFromVoteKeyQuery},
        get_invalid::{GetInvalidRegistrationParams, GetInvalidRegistrationQuery},
    },
    session::CassandraSession,
};

/// Get registration given a stake key hash, it can be time specific based on asat param,
/// or the latest registration returned if no asat given.
pub(crate) async fn get_registration_given_stake_key_hash(
    stake_address: StakeAddress, session: Arc<CassandraSession>, asat: Option<SlotNo>,
) -> AllRegistration {
    // Get stake addr associated with given stake hash.
    let mut stake_addr_iter =
        match GetStakeAddrQuery::execute(&session, GetStakeAddrParams::new(stake_address)).await {
            Ok(stake_addr) => stake_addr,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to query stake addr from stake hash {err:?}",
                ));
            },
        };

    if let Some(row_stake_addr) = stake_addr_iter.next().await {
        let row = match row_stake_addr {
            Ok(r) => r,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to query stake addr from stake hash {err:?}",
                ));
            },
        };

        // Stake hash successfully converted into associated stake pub key which we use to lookup
        // registrations.
        let stake_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.stake_public_key.clone())
        {
            Ok(key) => key,
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to type stake address {err:?}",
                ));
            },
        };

        return get_registration_from_stake_addr(stake_pub_key, asat, session, None).await;
    }

    AllRegistration::With(Cip36Registration::NotFound)
}

/// Get registration from stake addr
pub async fn get_registration_from_stake_addr(
    stake_pub_key: Ed25519HexEncodedPublicKey, asat: Option<SlotNo>,
    session: Arc<CassandraSession>, vote_key: Option<Ed25519HexEncodedPublicKey>,
) -> AllRegistration {
    // Get all registrations from given stake pub key.
    let mut registrations =
        match get_all_registrations_from_stake_pub_key(&session.clone(), stake_pub_key.clone())
            .await
        {
            Ok(registration) => registration,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to query stake stake pub key {err:?}",
                ));
            },
        };

    // check registrations are still actively associated with the voting key,
    // and have not been registered to another voting key.
    if let Some(vote_key) = vote_key {
        registrations = check_stake_addr_voting_key_association(registrations, &vote_key);
    }

    // Query requires the registration to be bound by time.
    let registration = if let Some(slot_no) = asat {
        match get_registration_given_slot_no(registrations, slot_no) {
            Ok(registration) => registration,
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to get registration given slot no {err:?}",
                ));
            },
        }
    } else {
        // Query not bound by time, return latest registration.
        match sort_latest_registration(registrations) {
            Ok(registration) => registration,
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to sort latest registration {err:?}",
                ));
            },
        }
    };

    // Registration found, now find invalids.
    let slot_no = registration.clone().slot_no;
    let Some(stake_pub_key) = registration.clone().stake_pub_key else {
        return AllRegistration::internal_error(&anyhow::anyhow!(
            "Stake pub key not in registration {stake_pub_key:?}",
        ));
    };

    let Some(vote_pub_key) = registration.clone().vote_pub_key else {
        return AllRegistration::internal_error(&anyhow::anyhow!(
            "Vote pub key not in registration {stake_pub_key:?}",
        ));
    };

    // include any erroneous registrations which occur AFTER the slot# of the last valid
    // registration
    let invalids_report =
        match get_invalid_registrations(stake_pub_key, Some(slot_no), session).await {
            Ok(invalids) => invalids,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to obtain invalid registrations for given stake pub key {err:?}",
                ));
            },
        };

    AllRegistration::With(Cip36Registration::Ok(poem_openapi::payload::Json(
        Cip36RegistrationList {
            slot: slot_no,
            voting_key: vec![Cip36RegistrationsForVotingPublicKey {
                vote_pub_key,
                registrations: vec![registration.clone()],
            }],
            invalid: invalids_report,
            page: None,
        },
    )))
}

/// Stake addresses need to be individually checked to make sure they are still actively
/// associated with the voting key, and have not been registered to another voting key.
fn check_stake_addr_voting_key_association(
    registrations: Vec<Cip36Details>, associated_voting_key: &Ed25519HexEncodedPublicKey,
) -> Vec<Cip36Details> {
    registrations
        .into_iter()
        .filter(|registration| cross_reference_key(associated_voting_key, registration))
        .collect()
}

/// Check associated voting key matches registration voting key
fn cross_reference_key(
    associated_voting_key: &Ed25519HexEncodedPublicKey, r: &Cip36Details,
) -> bool {
    r.vote_pub_key
        .clone()
        .map(|key| key == *associated_voting_key)
        .is_some()
}

/// Get all cip36 registrations for a given stake address.
async fn get_all_registrations_from_stake_pub_key(
    session: &Arc<CassandraSession>, stake_pub_key: Ed25519HexEncodedPublicKey,
) -> Result<Vec<Cip36Details>, anyhow::Error> {
    let mut registrations_iter = GetRegistrationQuery::execute(session, GetRegistrationParams {
        stake_public_key: stake_pub_key.clone().try_into()?,
    })
    .await?;
    let mut registrations = Vec::new();
    while let Some(row) = registrations_iter.next().await {
        let row = row?;

        let nonce = if let Some(nonce) = row.nonce.into_parts().1.to_u64_digits().first() {
            *nonce
        } else {
            continue;
        };

        let slot_no: u64 = row.slot_no.into();
        let txn: i16 = row.txn_index.into();

        let cip36 = Cip36Details {
            slot_no: slot_no.into(),
            stake_pub_key: Some(stake_pub_key.clone()),
            vote_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.vote_key)?),
            nonce: Some(Nonce::from(nonce)),
            txn: Some(TxnIndex::try_from(txn)?),
            payment_address: Some(Cip19ShelleyAddress::try_from(row.payment_address)?),
            is_payable: row.is_payable,
            cip15: !row.cip36,
            errors: None,
        };

        registrations.push(cip36);
    }
    Ok(registrations)
}

/// Sort latest registrations for a given stake address, sort by slot no and return
/// latest.
fn sort_latest_registration(mut registrations: Vec<Cip36Details>) -> anyhow::Result<Cip36Details> {
    registrations.sort_by_key(|registration| Reverse(registration.slot_no));
    registrations.into_iter().next().ok_or(anyhow::anyhow!(
        "Can't sort latest registrations by slot no"
    ))
}

/// Get registration given slot#
fn get_registration_given_slot_no(
    registrations: Vec<Cip36Details>, slot_no: SlotNo,
) -> anyhow::Result<Cip36Details> {
    registrations
        .into_iter()
        .find(|registration| registration.slot_no == slot_no)
        .ok_or(anyhow::anyhow!("Unable to get registration given slot no"))
}

/// Get invalid registrations for stake addr after given slot#
async fn get_invalid_registrations(
    stake_pub_key: Ed25519HexEncodedPublicKey, slot_no: Option<SlotNo>,
    session: Arc<CassandraSession>,
) -> anyhow::Result<Vec<Cip36Details>> {
    // include any erroneous registrations which occur AFTER the slot# of the last valid
    // registration or return all invalids if NO slot# declared.
    let slot_no = if let Some(slot_no) = slot_no {
        slot_no
    } else {
        SlotNo::from(0)
    };

    let mut invalid_registrations_iter = GetInvalidRegistrationQuery::execute(
        &session,
        GetInvalidRegistrationParams::new(stake_pub_key.try_into()?, slot_no),
    )
    .await?;
    let mut invalid_registrations = Vec::new();
    while let Some(row) = invalid_registrations_iter.next().await {
        let row = row?;

        invalid_registrations.push(Cip36Details {
            slot_no,
            stake_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.stake_public_key)?),
            vote_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.vote_key)?),
            nonce: None,
            txn: None,
            payment_address: Some(Cip19ShelleyAddress::try_from(row.payment_address)?),
            is_payable: row.is_payable,
            cip15: !row.cip36,
            errors: Some(ErrorMessage::from(row.problem_report)),
        });
    }

    Ok(invalid_registrations)
}

/// Get registration given a vote key, time specific based on asat param,
/// or latest registration returned if no asat given.
pub(crate) async fn get_registration_given_vote_key(
    vote_key: Ed25519HexEncodedPublicKey, session: Arc<CassandraSession>, asat: Option<SlotNo>,
) -> AllRegistration {
    let voting_key: Vec<u8> = match vote_key.clone().try_into() {
        Ok(vote_key) => vote_key,
        Err(err) => {
            return AllRegistration::internal_error(&anyhow::anyhow!(
                "Failed to convert vote key to bytes {err:?}",
            ));
        },
    };

    // Get stake addr associated voting key.
    let mut stake_addr_iter = match GetStakeAddrFromVoteKeyQuery::execute(
        &session,
        GetStakeAddrFromVoteKeyParams::new(voting_key),
    )
    .await
    {
        Ok(stake_addr) => stake_addr,
        Err(err) => {
            return AllRegistration::handle_error(&anyhow::anyhow!(
                "Failed to query stake addr from vote key {err:?}",
            ));
        },
    };

    if let Some(row_stake_addr) = stake_addr_iter.next().await {
        let row = match row_stake_addr {
            Ok(r) => r,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to query stake addr from vote key {err:?}",
                ));
            },
        };

        // Stake hash successfully converted into associated stake pub key which we use to lookup
        // registrations.
        let stake_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.stake_public_key.clone())
        {
            Ok(key) => key,
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to type stake address {err:?}",
                ));
            },
        };

        return get_registration_from_stake_addr(stake_pub_key, asat, session, Some(vote_key))
            .await;
    }

    AllRegistration::With(Cip36Registration::NotFound)
}

/// ALL
/// Get all registrations or constrain if slot# given.
pub async fn snapshot(session: Arc<CassandraSession>, slot_no: Option<SlotNo>) -> AllRegistration {
    let valid_invalid_queries = future::join(
        get_all_registrations(session.clone()),
        get_all_invalid_registrations(session.clone()),
    );

    let (valid_registrations, invalid_registrations) = valid_invalid_queries.await;

    // Get ALL registrations
    let all_registrations = match valid_registrations {
        Ok(all_registrations) => all_registrations,
        Err(err) => {
            return AllRegistration::handle_error(&anyhow::anyhow!("Failed to query ALL {err:?}",));
        },
    };

    // Get all invalids
    let all_invalid_registrations = match invalid_registrations {
        Ok(invalids) => invalids,
        Err(err) => {
            return AllRegistration::handle_error(&anyhow::anyhow!("Failed to query ALL {err:?}",));
        },
    };

    let mut all_registrations_after_filtering = Vec::new();
    let mut all_invalids_after_filtering = Vec::new();

    for (stake_public_key, registrations) in all_registrations {
        // latest vote key
        let vote_pub_key = match latest_vote_key(registrations.clone()) {
            Ok(vote_key) => vote_key,
            Err(err) => {
                error!("Snapshot: no voting keys with any registration {:?}", err);
                continue;
            },
        };

        // ALL: Snapshot can be constrained into a subset with a time constraint or NOT.
        if let Some(slot_no) = slot_no {
            // Any registrations that occurred after this Slot are not included in the list.
            let filtered_registrations = slot_filter(registrations, slot_no);

            if filtered_registrations.is_empty() {
                continue;
            }

            all_registrations_after_filtering.push(Cip36RegistrationsForVotingPublicKey {
                vote_pub_key,
                registrations: filtered_registrations,
            });
        } else {
            // No slot filtering, return ALL registrations without constraints.
            all_registrations_after_filtering.push(Cip36RegistrationsForVotingPublicKey {
                vote_pub_key,
                registrations,
            });
        }

        // get all invalid registrations for given stake pub key
        let invalid_registrations = match all_invalid_registrations.get(&stake_public_key) {
            Some(invalids) => invalids.clone(),
            None => vec![],
        };

        if let Some(ref slot_no) = slot_no {
            // include any erroneous registrations which occur AFTER the slot# of the last valid
            // registration or return all if NO slot# declared.
            // Any registrations that occurred before this Slot are not included in the list.
            let invalids_report_after_filtering = invalid_filter(invalid_registrations, slot_no);
            all_invalids_after_filtering.push(invalids_report_after_filtering);
        } else {
            all_invalids_after_filtering.push(invalid_registrations);
        }
    }

    AllRegistration::With(Cip36Registration::Ok(poem_openapi::payload::Json(
        Cip36RegistrationList {
            slot: slot_no.unwrap_or(SlotNo::from(0)),
            voting_key: all_registrations_after_filtering,
            invalid: all_invalids_after_filtering.into_iter().flatten().collect(),
            page: None,
        },
    )))
}

/// Get all cip36 registrations.
pub async fn get_all_registrations(
    session: Arc<CassandraSession>,
) -> Result<DashMap<Ed25519HexEncodedPublicKey, Vec<Cip36Details>>, anyhow::Error> {
    let mut registrations_iter =
        GetAllRegistrationsQuery::execute(&session, GetAllRegistrationsParams {}).await?;

    let registrations_map: DashMap<Ed25519HexEncodedPublicKey, Vec<Cip36Details>> = DashMap::new();

    while let Some(row) = registrations_iter.next().await {
        let row = row?;

        let nonce = if let Some(nonce) = row.nonce.into_parts().1.to_u64_digits().first() {
            *nonce
        } else {
            continue;
        };

        let slot_no = if let Some(slot_no) = row.slot_no.into_parts().1.to_u64_digits().first() {
            *slot_no
        } else {
            continue;
        };

        let cip36 = Cip36Details {
            slot_no: SlotNo::from(slot_no),
            stake_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(
                row.stake_address.clone(),
            )?),
            vote_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.vote_key)?),
            nonce: Some(Nonce::from(nonce)),
            txn: Some(TxnIndex::try_from(row.txn)?),
            payment_address: Some(Cip19ShelleyAddress::try_from(row.payment_address)?),
            is_payable: row.is_payable,
            cip15: !row.cip36,
            errors: None,
        };

        if let Some(mut v) = registrations_map.get_mut(&Ed25519HexEncodedPublicKey::try_from(
            row.stake_address.clone(),
        )?) {
            v.push(cip36);
            continue;
        };

        registrations_map.insert(
            Ed25519HexEncodedPublicKey::try_from(row.stake_address)?,
            vec![cip36],
        );
    }

    Ok(registrations_map)
}

/// Get all invalid registrations
async fn get_all_invalid_registrations(
    session: Arc<CassandraSession>,
) -> Result<DashMap<Ed25519HexEncodedPublicKey, Vec<Cip36Details>>, anyhow::Error> {
    let invalids_map: DashMap<Ed25519HexEncodedPublicKey, Vec<Cip36Details>> = DashMap::new();

    let mut invalid_registrations_iter =
        GetAllInvalidRegistrationsQuery::execute(&session, GetAllInvalidRegistrationsParams {})
            .await?;

    while let Some(row) = invalid_registrations_iter.next().await {
        let row = row?;

        let slot_no = if let Some(slot_no) = row.slot_no.into_parts().1.to_u64_digits().first() {
            *slot_no
        } else {
            continue;
        };

        let invalid = Cip36Details {
            slot_no: SlotNo::from(slot_no),
            stake_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(
                row.stake_address.clone(),
            )?),
            vote_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.vote_key)?),
            nonce: None,
            txn: None,
            payment_address: Some(Cip19ShelleyAddress::try_from(row.payment_address)?),
            is_payable: row.is_payable,
            cip15: !row.cip36,
            errors: Some(ErrorMessage::from(format!("{:?}", row.error_report))),
        };

        if let Some(mut v) = invalids_map.get_mut(&Ed25519HexEncodedPublicKey::try_from(
            row.stake_address.clone(),
        )?) {
            v.push(invalid);
            continue;
        };

        invalids_map.insert(
            Ed25519HexEncodedPublicKey::try_from(row.stake_address)?,
            vec![invalid],
        );
    }

    Ok(invalids_map)
}

/// Filter out any registrations that occurred after this Slot no
fn slot_filter(registrations: Vec<Cip36Details>, slot_no: SlotNo) -> Vec<Cip36Details> {
    registrations
        .into_iter()
        .filter(|registration| registration.slot_no < slot_no)
        .collect()
}

/// Stake addr may have multiple registrations and multiple vote key associations, filter
/// out latest vote key.
fn latest_vote_key(
    mut registrations: Vec<Cip36Details>,
) -> anyhow::Result<Ed25519HexEncodedPublicKey> {
    registrations.sort_by_key(|registration| Reverse(registration.slot_no.clone()));
    for registration in registrations {
        if let Some(vote_key) = registration.vote_pub_key {
            return Ok(vote_key);
        }
    }

    Err(anyhow::anyhow!(
        "No vote keys associated with any registration"
    ))
}

/// Filter out any invalid registrations that occurred before this Slot no
fn invalid_filter(registrations: Vec<Cip36Details>, slot_no: &SlotNo) -> Vec<Cip36Details> {
    registrations
        .into_par_iter()
        .filter(|registration| registration.slot_no > *slot_no)
        .collect()
}
