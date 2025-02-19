//! Implementation of the GET `/cardano/cip36` endpoint

use std::{cmp::Reverse, sync::Arc};

use cardano_blockchain_types::StakeAddress;
use futures::StreamExt;

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
        get_all_stakes_and_vote_keys::{
            GetAllStakesAndVoteKeysParams, GetAllStakesAndVoteKeysQuery,
        },
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
        match get_registration_given_slot_no(registrations, &slot_no) {
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
        match get_invalid_registrations(stake_pub_key, Some(slot_no.clone()), session).await {
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
    registrations.sort_by_key(|registration| Reverse(registration.slot_no.clone()));
    registrations.into_iter().next().ok_or(anyhow::anyhow!(
        "Can't sort latest registrations by slot no"
    ))
}

/// Get registration given slot#
fn get_registration_given_slot_no(
    registrations: Vec<Cip36Details>, slot_no: &SlotNo,
) -> anyhow::Result<Cip36Details> {
    registrations
        .into_iter()
        .find(|registration| registration.slot_no == *slot_no)
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
        GetInvalidRegistrationParams::new(stake_pub_key.try_into()?, slot_no.clone()),
    )
    .await?;
    let mut invalid_registrations = Vec::new();
    while let Some(row) = invalid_registrations_iter.next().await {
        let row = row?;

        invalid_registrations.push(Cip36Details {
            slot_no: slot_no.clone(),
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
    let all_stakes_and_vote_keys = match get_all_stake_addrs_and_vote_keys(&session.clone()).await {
        Ok(key_pairs) => key_pairs,
        Err(err) => {
            return AllRegistration::handle_error(&anyhow::anyhow!("Failed to query ALL {err:?}",));
        },
    };

    let mut all_registrations_after_filtering = Vec::new();
    let mut all_invalids_after_filtering = Vec::new();

    // We now have all stake pub keys and vote keys for cip36 registrations.
    // Iterate through them and individually get all valid and invalid registrations.
    // Compose the result into a snapshot.
    // TODO: Optimize: Can be done parallel.
    for (stake_public_key, vote_pub_key) in &all_stakes_and_vote_keys {
        let mut registrations_for_given_stake_pub_key =
            match get_all_registrations_from_stake_pub_key(&session, stake_public_key.clone()).await
            {
                Ok(registrations) => registrations,
                Err(err) => {
                    return AllRegistration::handle_error(&anyhow::anyhow!(
                        "Failed to query ALL {err:?}",
                    ));
                },
            };

        // check the registrations stake pub key are still actively associated with the voting
        // key, and have not been registered to another voting key.
        registrations_for_given_stake_pub_key = check_stake_addr_voting_key_association(
            registrations_for_given_stake_pub_key,
            vote_pub_key,
        );

        // ALL: Snapshot can be constrained into a subset with a time constraint or NOT.
        if let Some(ref slot_no) = slot_no {
            // Any registrations that occurred after this Slot are not included in the list.
            let filtered_registrations =
                slot_filter(registrations_for_given_stake_pub_key, slot_no);

            if filtered_registrations.is_empty() {
                continue;
            }

            all_registrations_after_filtering.push(Cip36RegistrationsForVotingPublicKey {
                vote_pub_key: vote_pub_key.clone(),
                registrations: filtered_registrations,
            });
        } else {
            // No slot filtering, return ALL registrations without constraints.
            all_registrations_after_filtering.push(Cip36RegistrationsForVotingPublicKey {
                vote_pub_key: vote_pub_key.clone(),
                registrations: registrations_for_given_stake_pub_key,
            });
        }

        // include any erroneous registrations which occur AFTER the slot# of the last valid
        // registration or return all if NO slot# declared.
        let invalids_report = match get_invalid_registrations(
            stake_public_key.clone(),
            slot_no.clone(),
            session.clone(),
        )
        .await
        {
            Ok(invalids) => invalids,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to obtain invalid registrations for given stake addr {err:?} in snapshot",
                ));
            },
        };
        all_invalids_after_filtering.push(invalids_report);
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

/// Filter out any registrations that occurred after this Slot no
fn slot_filter(registrations: Vec<Cip36Details>, slot_no: &SlotNo) -> Vec<Cip36Details> {
    registrations
        .into_iter()
        .filter(|registration| registration.slot_no < *slot_no)
        .collect()
}

/// Get all `stake_addr` paired with vote keys [(`stake_addr,vote_key`)] from cip36
/// registrations.
pub async fn get_all_stake_addrs_and_vote_keys(
    session: &Arc<CassandraSession>,
) -> Result<Vec<(Ed25519HexEncodedPublicKey, Ed25519HexEncodedPublicKey)>, anyhow::Error> {
    let mut stake_addr_iter =
        GetAllStakesAndVoteKeysQuery::execute(session, GetAllStakesAndVoteKeysParams {}).await?;

    let mut vote_key_stake_addr_pair = Vec::new();

    while let Some(row) = stake_addr_iter.next().await {
        let row = row?;

        let stake_addr = Ed25519HexEncodedPublicKey::try_from(row.stake_public_key)?;
        let vote_key = Ed25519HexEncodedPublicKey::try_from(row.vote_key)?;

        vote_key_stake_addr_pair.push((stake_addr, vote_key));
    }
    Ok(vote_key_stake_addr_pair)
}
