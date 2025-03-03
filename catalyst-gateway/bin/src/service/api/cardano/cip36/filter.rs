//! Implementation of the GET `/cardano/cip36` endpoint

use std::{cmp::Reverse, sync::Arc};

use cardano_blockchain_types::StakeAddress;
use dashmap::DashMap;
use futures::{future, StreamExt};
use rayon::iter::{IntoParallelIterator, ParallelIterator};
use tracing::error;

use super::{
    cardano::{cip19_shelley_address::Cip19ShelleyAddress, nonce::Nonce},
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

/// Get registration given a stake address, it can be time specific based on asat param,
/// or the latest registration returned if no asat given.
pub(crate) async fn get_registration_given_stake_addr(
    stake_address: StakeAddress, session: Arc<CassandraSession>, asat: Option<SlotNo>,
    page: common::types::generic::query::pagination::Page,
    limit: common::types::generic::query::pagination::Limit,
) -> AllRegistration {
    // Get stake public key associated with given stake address.
    let mut stake_pk_iter = match GetStakePublicKeyFromStakeAddrQuery::execute(
        &session,
        GetStakePublicKeyFromStakeAddrParams::new(stake_address),
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

        let registrations = if let Some(slot_no) = asat {
            match get_registrations_given_slot_no(stake_pk_registrations, &slot_no) {
                Ok(registrations) => registrations,
                Err(err) => {
                    return AllRegistration::internal_error(&anyhow::anyhow!(
                        "Failed to get registrations given slot no {err:?}",
                    ));
                },
            }
        // No time bound
        } else {
            stake_pk_registrations
        };

        let (valid_reg, mut invalid_reg) = match sort_latest_registration(registrations) {
            Ok((valid_reg, invalid_reg)) => (valid_reg, invalid_reg),
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to sort latest registration {err:?}",
                ));
            },
        };

        // Registration found, now find invalids.
        let slot_no = valid_reg.clone().slot_no;
        let Some(stake_pub_key) = valid_reg.clone().stake_pub_key else {
            return AllRegistration::internal_error(&anyhow::anyhow!(
                "Stake public key not in registration",
            ));
        };

        let Some(vote_pub_key) = valid_reg.clone().vote_pub_key else {
            return AllRegistration::internal_error(&anyhow::anyhow!(
                "Vote key not in registration",
            ));
        };

        match get_invalid_registrations(stake_pub_key, Some(slot_no), session).await {
            Ok(invalids) => invalid_reg.extend(invalids),
            Err(err) => {
                return AllRegistration::handle_error(&anyhow::anyhow!(
                    "Failed to obtain invalid registrations for given stake pub key {err:?}",
                ));
            },
        }

        return AllRegistration::With(Cip36Registration::Ok(poem_openapi::payload::Json(
            Cip36RegistrationList {
                slot: slot_no,
                voting_key: vec![Cip36RegistrationsForVotingPublicKey {
                    vote_pub_key,
                    registrations: valid_reg.into(),
                }]
                .into(),
                invalid: invalid_reg.into(),
                page: Some(
                    CurrentPage {
                        page,
                        limit,
                        remaining,
                    }
                    .into(),
                ),
            },
        )));
    }

    AllRegistration::With(Cip36Registration::NotFound)
}

// /// Get registration from stake public keys
// pub async fn get_registration_from_stake_pks(
//     stake_pks: &[Ed25519HexEncodedPublicKey], asat: Option<SlotNo>, session:
// Arc<CassandraSession>,     vote_key: Option<Ed25519HexEncodedPublicKey>,
//     page: common::types::generic::query::pagination::Page,
//     limit: common::types::generic::query::pagination::Limit,
// ) -> AllRegistration {
//     // Get all registrations from given stake pub keys.
//     let mut all_regs = Vec::new();
//     for stake_pk in stake_pks {
//         let stake_pk_registrations = match get_all_registrations_from_stake_pub_key(
//             &session.clone(),
//             stake_pk.clone(),
//         )
//         .await
//         {
//             Ok(registration) => registration,
//             Err(err) => {
//                 return AllRegistration::handle_error(&anyhow::anyhow!(
//                     "Failed to query stake public key {err:?}",
//                 ));
//             },
//         };
//         all_regs.extend(stake_pk_registrations);
//     }

//     // check registrations are still actively associated with the voting key,
//     // and have not been registered to another voting key.
//     if let Some(vote_key) = vote_key {
//         all_regs = check_stake_addr_voting_key_association(all_regs, &vote_key);
//     }

//     // Query requires the registration to be bound by time.
//     let registrations = if let Some(slot_no) = asat {
//         match get_registrations_given_slot_no(all_regs, &slot_no) {
//             Ok(registrations) => registrations,
//             Err(err) => {
//                 return AllRegistration::internal_error(&anyhow::anyhow!(
//                     "Failed to get registrations given slot no {err:?}",
//                 ));
//             },
//         }
//     // No time bound
//     } else {
//         all_regs
//     };

//     // FIXME: error
//     let (valid_reg, mut invalid_reg) = match sort_latest_registration(registrations) {
//         Ok((valid_reg, invalid_reg)) => (valid_reg, invalid_reg),
//         Err(err) => {
//             return AllRegistration::internal_error(&anyhow::anyhow!(
//                 "Failed to sort latest registration {err:?}",
//             ));
//         },
//     };

//     // Registration found, now find invalids.
//     let slot_no = valid_reg.clone().slot_no;
//     let Some(stake_pub_key) = valid_reg.clone().stake_pub_key else {
//         return AllRegistration::internal_error(&anyhow::anyhow!(
//             "Stake public key not in registration",
//         ));
//     };

//     let Some(vote_pub_key) = valid_reg.clone().vote_pub_key else {
//         return AllRegistration::internal_error(&anyhow::anyhow!("Vote key not in
// registration",));     };

//     // include any erroneous registrations which occur AFTER the slot# of the last
// valid     // registration
//     match get_invalid_registrations(stake_pub_key, Some(slot_no), session).await {
//         Ok(invalids) => invalid_reg.extend(invalids),
//         Err(err) => {
//             return AllRegistration::handle_error(&anyhow::anyhow!(
//                 "Failed to obtain invalid registrations for given stake pub key
// {err:?}",             ));
//         },
//     }

//     // Apply pagination - paginate both the valid and invalid registrations.
//     // FIXME: if there is only 1 valid reg, page only invalid?
//     let (valid_reg, invalid_reg, remaining) =
//         paginate_registrations(&valid_reg, &invalid_reg, page.into(), limit.into());

//     AllRegistration::With(Cip36Registration::Ok(poem_openapi::payload::Json(
//         Cip36RegistrationList {
//             slot: slot_no,
//             voting_key: vec![Cip36RegistrationsForVotingPublicKey {
//                 vote_pub_key,
//                 registrations: valid_reg.into(),
//             }]
//             .into(),
//             invalid: invalid_reg.into(),
//             page: Some(
//                 CurrentPage {
//                     page,
//                     limit,
//                     remaining,
//                 }
//                 .into(),
//             ),
//         },
//     )))
// }

/// Stake addresses need to be individually checked to make sure they are still actively
/// associated with the voting key, and have not been registered to another voting key.
fn check_stake_addr_voting_key_association(
    registrations: Vec<Cip36Details>, associated_voting_key: &Ed25519HexEncodedPublicKey,
) -> Vec<Cip36Details> {
    registrations
        .into_par_iter()
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

        let slot_no = match SlotNo::try_from(slot_no) {
            Ok(slot_no) => slot_no,
            Err(err) => {
                error!("Corrupt valid registration {:?}", err);
                // This should NOT happen, valid registrations should be infallible.
                // If it happens, there is an indexing issue.
                continue;
            },
        };

        let payment_address = match Cip19ShelleyAddress::try_from(row.payment_address) {
            Ok(payment_addr) => Some(payment_addr),
            Err(err) => {
                // This should NOT happen, valid registrations should be infallible.
                // If it happens, there is an indexing issue.
                error!(
                    "Corrupt valid registration {:?}\n Stake pub key:{:?}",
                    err, stake_pub_key
                );
                continue;
            },
        };

        let vote_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.vote_key) {
            Ok(vote_pub_key) => Some(vote_pub_key),
            Err(err) => {
                error!(
                    "Corrupt valid registration {:?}\n Stake pub key:{:?}",
                    err, stake_pub_key
                );
                continue;
            },
        };

        let cip36 = Cip36Details {
            slot_no,
            stake_pub_key: Some(stake_pub_key.clone()),
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

/// Sort latest registrations for a given stake address by slot number, nonce, and
/// transaction offset. If `slot_no` is the same, the registration with the highest
/// `nonce` wins. If `nonce` is the same, the registration with the highest `txn_offset`
/// wins. Return the valid registration and the rest as invalid.
fn sort_latest_registration(
    mut registrations: Vec<Cip36Details>,
) -> anyhow::Result<(Cip36Details, Vec<Cip36Details>)> {
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

    // Get the latest registration (the first element after sorting)
    let valid_reg = registrations.first().ok_or_else(|| {
        anyhow::anyhow!("Can't sort latest registrations: no registrations found")
    })?;

    // The rest are invalid registrations
    let invalid_registrations = registrations[1..].to_vec();

    Ok((valid_reg.clone(), invalid_registrations))
}

/// Get registration given slot#
fn get_registrations_given_slot_no(
    registrations: Vec<Cip36Details>, slot_no: &SlotNo,
) -> anyhow::Result<Vec<Cip36Details>> {
    // Possible to have multiple registrations for a given slot#?.
    let r: Vec<_> = registrations
        .into_iter()
        .filter(|registration| registration.slot_no == *slot_no)
        .collect();

    if r.is_empty() {
        Err(anyhow::anyhow!("Unable to get registrations given slot no"))
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
    let slot_no = slot_no.unwrap_or_default();

    let mut invalid_registrations_iter = GetInvalidRegistrationQuery::execute(
        &session,
        GetInvalidRegistrationParams::new(stake_pub_key.try_into()?, slot_no),
    )
    .await?;
    let mut invalid_registrations = Vec::new();
    while let Some(row) = invalid_registrations_iter.next().await {
        let row = row?;

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

    // Get stake public key associated voting key
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

    // There can be multiple stake public keys associated with a voting key.
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

    // Should return multiple valid registration because voting key can have multiple current
    // stake address registered

    // Get all registrations from given stake pub keys.
    let mut all_regs = Vec::new();
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
        all_regs.extend(stake_pk_registrations);
    }

    all_regs = check_stake_addr_voting_key_association(all_regs, &vote_key);

    // Query requires the registration to be bound by time
    // Multiple stake pk registration can be in the same slot.
    let registrations = if let Some(slot_no) = asat {
        match get_registrations_given_slot_no(all_regs, &slot_no) {
            Ok(registrations) => registrations,
            Err(err) => {
                return AllRegistration::internal_error(&anyhow::anyhow!(
                    "Failed to get registrations given slot no {err:?}",
                ));
            },
        }
    // No time bound
    } else {
        // FIXME: If no time bound, will it get the latest registrations of each stake pks?
        all_regs
    };

    return todo!();
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
                registrations: filtered_registrations.into(),
            });
        } else {
            // No slot filtering, return ALL registrations without constraints.
            all_registrations_after_filtering.push(Cip36RegistrationsForVotingPublicKey {
                vote_pub_key,
                registrations: registrations.into(),
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
            let invalids_report_after_filtering = invalid_filter(invalid_registrations, *slot_no);
            all_invalids_after_filtering.push(invalids_report_after_filtering);
        } else {
            all_invalids_after_filtering.push(invalid_registrations);
        }
    }

    AllRegistration::With(Cip36Registration::Ok(poem_openapi::payload::Json(
        Cip36RegistrationList {
            slot: slot_no.unwrap_or_default(),
            voting_key: all_registrations_after_filtering.into(),
            invalid: all_invalids_after_filtering
                .into_par_iter()
                .flatten()
                .collect::<Vec<_>>()
                .into(),
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

        let slot_no = match SlotNo::try_from(slot_no) {
            Ok(slot_no) => slot_no,
            Err(err) => {
                error!("Corrupt valid registration {:?}", err);
                // This should NOT happen, valid registrations should be infallible.
                // If it happens, there is an indexing issue.
                continue;
            },
        };

        let stake_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.stake_public_key.clone())
        {
            Ok(stake_pub_key) => Some(stake_pub_key),
            Err(err) => {
                error!("Corrupt valid registration {:?}", err);
                // This should NOT happen, valid registrations should be infallible.
                // If it happens, there is an indexing issue.
                continue;
            },
        };

        let payment_address = match Cip19ShelleyAddress::try_from(row.payment_address) {
            Ok(payment_addr) => Some(payment_addr),
            Err(err) => {
                error!(
                    "Corrupt valid registration {:?}\n Stake pub key:{:?}",
                    err, stake_pub_key
                );
                continue;
            },
        };

        let vote_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.vote_key) {
            Ok(vote_pub_key) => Some(vote_pub_key),
            Err(err) => {
                error!(
                    "Corrupt valid registration {:?}\n Stake pub key:{:?}",
                    err, stake_pub_key
                );
                continue;
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

/// Filter out any registrations that occurred after this Slot no
fn slot_filter(registrations: Vec<Cip36Details>, slot_no: SlotNo) -> Vec<Cip36Details> {
    registrations
        .into_par_iter()
        .filter(|registration| registration.slot_no < slot_no)
        .collect()
}

/// Stake addr may have multiple registrations and multiple vote key associations, filter
/// out latest vote key.
fn latest_vote_key(
    mut registrations: Vec<Cip36Details>,
) -> anyhow::Result<Ed25519HexEncodedPublicKey> {
    registrations.sort_by_key(|registration| Reverse(registration.slot_no));
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
fn invalid_filter(registrations: Vec<Cip36Details>, slot_no: SlotNo) -> Vec<Cip36Details> {
    registrations
        .into_par_iter()
        .filter(|registration| registration.slot_no > slot_no)
        .collect()
}

/// Paginate the registrations.
fn paginate_registrations(
    valid: &[Cip36Details], invalid: &[Cip36Details], page: u32, limit: u32,
) -> (Vec<Cip36Details>, Vec<Cip36Details>, Remaining) {
    let start_index: usize = page.saturating_mul(limit).try_into().unwrap_or_default();

    // Paginate the valid list first
    let valid_to_show = valid
        .iter()
        .skip(start_index)
        .take(limit.try_into().unwrap_or_default())
        .cloned()
        .collect::<Vec<_>>();

    // Calculate how many invalid items to show, if there's space remaining
    let remaining_space = limit.saturating_sub(valid_to_show.len().try_into().unwrap_or_default());
    let invalid_to_show = invalid
        .iter()
        .take(remaining_space.try_into().unwrap_or_default())
        .cloned()
        .collect::<Vec<_>>();

    let total_reg: u32 = valid
        .len()
        .saturating_add(invalid.len())
        .try_into()
        .unwrap_or_default();
    let reg_count: u32 = valid_to_show
        .len()
        .saturating_add(invalid_to_show.len())
        .try_into()
        .unwrap_or_default();
    let remaining = Remaining::calculate(page, limit, total_reg, reg_count);

    // Return the paginated valid, invalid lists, and remaining.
    (valid_to_show, invalid_to_show, remaining)
}
