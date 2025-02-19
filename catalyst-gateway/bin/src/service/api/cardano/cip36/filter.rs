//! Implementation of the GET `/cardano/cip36` endpoint

use std::{cmp::Reverse, sync::Arc};

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
use crate::{
    db::index::{
        queries::registrations::{
            get_all_stakes_and_vote_keys::{
                GetAllStakesAndVoteKeysParams, GetAllStakesAndVoteKeysQuery,
            },
            get_from_stake_addr::{GetRegistrationParams, GetRegistrationQuery},
            get_invalid::{GetInvalidRegistrationParams, GetInvalidRegistrationQuery},
            get_stake_pk_from_stake_address::{
                GetStakePublicKeyFromStakeAddrParams, GetStakePublicKeyFromStakeAddrQuery,
            },
            get_stake_pk_from_vote_key::{
                GetStakePublicKeyFromVoteKeyParams, GetStakePublicKeyFromVoteKeyQuery,
            },
        },
        session::CassandraSession,
    },
    service::common::{
        self,
        objects::generic::pagination::CurrentPage,
        types::{cardano::hash29::HexEncodedHash29, generic::query::pagination::Remaining},
    },
};

/// Get registration given a stake address, it can be time specific based on asat param,
/// or the latest registration returned if no asat given.
pub(crate) async fn get_registration_given_stake_address(
    stake_addr: HexEncodedHash29, session: Arc<CassandraSession>, asat: Option<SlotNo>,
    page: common::types::generic::query::pagination::Page,
    limit: common::types::generic::query::pagination::Limit,
) -> AllRegistration {
    // Get stake public key associated with given stake address.
    let mut stake_pk_iter = match GetStakePublicKeyFromStakeAddrQuery::execute(
        &session,
        GetStakePublicKeyFromStakeAddrParams::new(stake_addr.into()),
    )
    .await
    {
        Ok(stake_addr) => stake_addr,
        Err(err) => {
            return AllRegistration::handle_error(&anyhow::anyhow!(
                "Failed to query stake public key from stake address {err:?}",
            ));
        },
    };

    // There should be only 1 stake public key associated with a stake address.
    if let Some(row_stake_pk) = stake_pk_iter.next().await {
        let row = match row_stake_pk {
            Ok(r) => r,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to query stake public key from stake address {err:?}",
                ));
            },
        };

        // Stake public key successfully converted into associated stake pub key which we use to
        // lookup registrations.
        let stake_pk = match Ed25519HexEncodedPublicKey::try_from(row.stake_public_key.clone()) {
            Ok(key) => key,
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to convert to type stake public key {err:?}",
                ));
            },
        };

        return get_registration_from_stake_pks(&[stake_pk], asat, session, None, page, limit)
            .await;
    }

    AllRegistration::With(Cip36Registration::NotFound)
}
/// Get registration from stake public keys
pub async fn get_registration_from_stake_pks(
    stake_pks: &[Ed25519HexEncodedPublicKey], asat: Option<SlotNo>, session: Arc<CassandraSession>,
    vote_key: Option<Ed25519HexEncodedPublicKey>,
    page: common::types::generic::query::pagination::Page,
    limit: common::types::generic::query::pagination::Limit,
) -> AllRegistration {
    // Get all registrations from given stake pub keys.
    let mut registrations = Vec::new();
    for stake_pk in stake_pks {
        let stake_pk_registrations = match get_all_registrations_from_stake_pub_key(
            &session.clone(),
            stake_pk.clone(),
        )
        .await
        {
            Ok(registration) => registration,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to query stake public key {err:?}",
                ));
            },
        };
        registrations.extend(stake_pk_registrations);
    }

    // check registrations are still actively associated with the voting key,
    // and have not been registered to another voting key.
    if let Some(vote_key) = vote_key {
        registrations = check_stake_addr_voting_key_association(registrations, &vote_key);
    }

    // Query requires the registration to be bound by time.
    let (slot_no, registrations) = if let Some(slot_no) = asat {
        match get_registration_given_slot_no(registrations, &slot_no) {
            Ok(registration) => (slot_no, registration),
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to get registration given slot no {err:?}",
                ));
            },
        }
    } else {
        // Query not bound by time, return latest registration.
        match sort_latest_registration(registrations) {
            Ok(registration) => (registration.clone().slot_no, [registration].to_vec()),
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to sort latest registration {err:?}",
                ));
            },
        }
    };

    let mut invalid_reg = vec![];
    for stake_pk in stake_pks {
        // include any erroneous registrations which occur AFTER the slot# of the last valid
        // registration
        match get_invalid_registrations(stake_pk.clone(), Some(slot_no.clone()), session.clone())
            .await
        {
            Ok(invalids) => invalid_reg.extend(invalids),
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to obtain invalid registrations for given stake pub key {err:?}",
                ));
            },
        };
    }

    // Get vote public key
    // Possible that vote pub key will not be given from the parameter so need to get from the registration.
    let vote_pub_key = match registrations.first() {
        Some(registration) => {
            match registration.vote_pub_key.clone() {
                Some(vote_pub_key) => vote_pub_key,
                None => {
                    return AllRegistration::internal_error(&anyhow::anyhow!(
                        "Failed to get vote public key from registration",
                    ));
                },
            }
        },
        None => {
            return AllRegistration::internal_error(&anyhow::anyhow!(
                "Failed to obtain registration",
            ));
        },
    };

    // Apply pagination - paginate both the valid and invalid registrations.
    let (valid_reg, invalid_reg, remaining) =
        paginate_registrations(&registrations, &invalid_reg, page.into(), limit.into());

    AllRegistration::With(Cip36Registration::Ok(poem_openapi::payload::Json(
        Cip36RegistrationList {
            slot: slot_no,
            voting_key: vec![Cip36RegistrationsForVotingPublicKey {
                vote_pub_key,
                registrations: valid_reg,
            }],
            invalid: invalid_reg,
            page: Some(CurrentPage {
                page,
                limit,
                remaining,
            }),
        },
    )))
}

/// Paginate the registrations.
// FIXME - Remove this clippy
#[allow(clippy::cast_possible_truncation, clippy::arithmetic_side_effects)]
fn paginate_registrations(
    valid: &[Cip36Details], invalid: &[Cip36Details], page: u32, limit: u32,
) -> (Vec<Cip36Details>, Vec<Cip36Details>, Remaining) {
    // FIXME - fix all the as conversion
    let start_index = (page * limit) as usize;

    // Paginate the valid list first
    let valid_to_show = valid
        .iter()
        .skip(start_index)
        .take(limit as usize)
        .cloned()
        .collect::<Vec<_>>();

    // Calculate how many invalid items to show, if there's space remaining
    let remaining_space = limit.saturating_sub(valid_to_show.len() as u32);
    let invalid_to_show = invalid
        .iter()
        .take(remaining_space as usize)
        .cloned()
        .collect::<Vec<_>>();

    let total_reg = valid.len() + invalid.len();
    let reg_count = valid_to_show.len() + invalid_to_show.len();
    let remaining = Remaining::calculate(page, limit, total_reg as u32, reg_count as u32);

    // Return the paginated valid, invalid lists, and remaining.
    (valid_to_show, invalid_to_show, remaining)
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
) -> anyhow::Result<Vec<Cip36Details>> {
    // FIXME - Possible to have multiple registrations for a given slot#?.
    let r: Vec<_> = registrations
        .into_iter()
        .filter(|registration| registration.slot_no == *slot_no)
        .collect();

    if r.is_empty() {
        Err(anyhow::anyhow!("Unable to get registration given slot no"))
    } else {
        Ok(r)
    }
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
    page: common::types::generic::query::pagination::Page,
    limit: common::types::generic::query::pagination::Limit,
) -> AllRegistration {
    let voting_key: Vec<u8> = match vote_key.clone().try_into() {
        Ok(vote_key) => vote_key,
        Err(err) => {
            return AllRegistration::internal_error(&anyhow::anyhow!(
                "Failed to convert vote key to bytes {err:?}",
            ));
        },
    };

    // Get stake public key associated voting key, voting key can have multiple stake hash.
    // There can be multiple stake public keys associated with a voting key.
    let mut stake_pk_iter = match GetStakePublicKeyFromVoteKeyQuery::execute(
        &session,
        GetStakePublicKeyFromVoteKeyParams::new(voting_key),
    )
    .await
    {
        Ok(stake_pk) => stake_pk,
        Err(err) => {
            return AllRegistration::handle_error(&anyhow::anyhow!(
                "Failed to query stake public key from vote key {err:?}",
            ));
        },
    };

    let mut stake_pks = vec![];
    while let Some(row_stake_pk) = stake_pk_iter.next().await {
        let row = match row_stake_pk {
            Ok(r) => r,
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to query stake public key from vote key {err:?}",
                ));
            },
        };

        // Stake public key successfully converted into associated stake pub key which we
        // use to lookup registrations.
        let stake_pk = match Ed25519HexEncodedPublicKey::try_from(row.stake_public_key.clone()) {
            Ok(key) => key,
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to convert to type stake public key {err:?}",
                ));
            },
        };
        stake_pks.push(stake_pk);
    }
    if stake_pks.is_empty() {
        return AllRegistration::With(Cip36Registration::NotFound);
    }
    return get_registration_from_stake_pks(&stake_pks, asat, session, Some(vote_key), page, limit)
        .await;
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
