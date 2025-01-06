//! Implementation of the GET `/cardano/cip36` endpoint

use std::{cmp::Reverse, sync::Arc};

use futures::StreamExt;
use poem::http::StatusCode;
use tracing::error;

use super::{
    cardano::{
        cip19_shelley_address::Cip19ShelleyAddress, hash28::HexEncodedHash28, nonce::Nonce,
        txn_index::TxnIndex,
    },
    common::types::generic::error_msg::ErrorMessage,
    response::{
        AllRegistration, Cip36Details, Cip36Registration, Cip36RegistrationList,
        Cip36RegistrationsForVotingPublicKey,
    },
    Ed25519HexEncodedPublicKey, SlotNo,
};
use crate::db::index::{
    queries::registrations::{
        get_from_stake_addr::{GetRegistrationParams, GetRegistrationQuery},
        get_from_stake_hash::{GetStakeAddrParams, GetStakeAddrQuery},
        get_invalid::{GetInvalidRegistrationParams, GetInvalidRegistrationQuery},
    },
    session::CassandraSession,
};

/// Get registration from stake addr
pub async fn get_registration_from_stake_addr(
    stake_pub_key: Ed25519HexEncodedPublicKey, asat: Option<SlotNo>, session: Arc<CassandraSession>,
) -> AllRegistration {
    let registrations = match get_all_registrations_from_stake_pub_key(
        session.clone(),
        stake_pub_key.clone(),
    )
    .await
    {
        Ok(registration) => registration,
        Err(err) => {
            error!(
                id="get_registration_from_stake_addr",
                error=?err,
                "Failed to query stake addr"
            );

            return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                format!("Failed to query stake addr {err:?}"),
                StatusCode::UNPROCESSABLE_ENTITY,
            )]);
        },
    };

    let registration = if let Some(slot_no) = asat {
        match get_registration_given_slot_no(registrations, &slot_no) {
            Ok(registration) => registration,
            Err(err) => {
                error!(
                    id="get_registration_given_slot_no",
                    error=?err,
                    "Failed to get registration given slot no"
                );

                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    format!("Failed to get registration given slot no {err:?}"),
                    StatusCode::UNPROCESSABLE_ENTITY,
                )]);
            },
        }
    } else {
        match sort_latest_registration(registrations) {
            Ok(registration) => registration,
            Err(err) => {
                error!(
                    id="get_latest_registration",
                    error=?err,
                    "Failed to sort latest registration"
                );

                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    format!("Failed to sort latest registration {err:?}"),
                    StatusCode::UNPROCESSABLE_ENTITY,
                )]);
            },
        }
    };

    let slot_no = registration.clone().slot_no;
    let Some(stake_pub_key) = registration.clone().stake_pub_key else {
        return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
            format!("Stake pub key not in registration {stake_pub_key:?}"),
            StatusCode::UNPROCESSABLE_ENTITY,
        )]);
    };

    let Some(vote_pub_key) = registration.clone().vote_pub_key else {
        return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
            format!("Vote pub key not in registration {stake_pub_key:?}"),
            StatusCode::UNPROCESSABLE_ENTITY,
        )]);
    };

    // include any erroneous registrations which occur AFTER the slot# of the last valid
    // registration
    let invalids_report = match get_invalid_registrations(
        stake_pub_key.as_bytes(),
        slot_no.clone(),
        session,
    )
    .await
    {
        Ok(invalids) => invalids,
        Err(err) => {
            error!(
                id="get_latest_registration_from_stake_key_hash_invalid_registrations_for_stake_addr",
                error=?err,
                "Failed to obtain invalid registrations for given stake addr",
            );

            return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                format!("Failed to obtain invalid registrations for given stake addr {err:?}"),
                StatusCode::UNPROCESSABLE_ENTITY,
            )]);
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

/// Get registration given stake address, latest or based on optional slot no
async fn latest_registration_from_stake_addr(
    stake_pub_key: Ed25519HexEncodedPublicKey, session: Arc<CassandraSession>,
) -> anyhow::Result<Cip36Details> {
    sort_latest_registration(
        get_all_registrations_from_stake_pub_key(session, stake_pub_key).await?,
    )
}

/// Get all cip36 registrations for a given stake address.
async fn get_all_registrations_from_stake_pub_key(
    session: Arc<CassandraSession>, stake_pub_key: Ed25519HexEncodedPublicKey,
) -> Result<Vec<Cip36Details>, anyhow::Error> {
    let mut registrations_iter = GetRegistrationQuery::execute(&session, GetRegistrationParams {
        stake_address: stake_pub_key.try_into()?,
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

        let slot_no = if let Some(slot_no) = row.slot_no.into_parts().1.to_u64_digits().first() {
            *slot_no
        } else {
            continue;
        };

        let cip36 = Cip36Details {
            slot_no: SlotNo::from(slot_no),
            stake_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.stake_address)?),
            vote_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.vote_key)?),
            nonce: Some(Nonce::from(nonce)),
            txn: Some(TxnIndex::try_from(row.txn)?),
            payment_address: Some(Cip19ShelleyAddress::new(hex::encode(row.payment_address))),
            is_payable: row.is_payable,
            cip15: !row.cip36,
            errors: vec![],
        };

        registrations.push(cip36);
    }
    Ok(registrations)
}

/// Sort latest registrations for a given stake address sorting by slot no
fn sort_latest_registration(mut registrations: Vec<Cip36Details>) -> anyhow::Result<Cip36Details> {
    registrations.sort_by_key(|registration| Reverse(registration.slot_no.clone()));
    registrations.into_iter().next().ok_or(anyhow::anyhow!(
        "Can't sort latest registrations by slot no"
    ))
}

/// Get registration given slot no.
fn get_registration_given_slot_no(
    registrations: Vec<Cip36Details>, slot_no: &SlotNo,
) -> anyhow::Result<Cip36Details> {
    registrations
        .into_iter()
        .find(|registration| registration.slot_no == *slot_no)
        .ok_or(anyhow::anyhow!("Unable to get registration given slot no"))
}

/// Get invalid registrations for stake addr after given slot no
async fn get_invalid_registrations(
    stake_pub_key: &[u8], slot_no: SlotNo, session: Arc<CassandraSession>,
) -> anyhow::Result<Vec<Cip36Details>> {
    let mut invalid_registrations_iter = GetInvalidRegistrationQuery::execute(
        &session,
        GetInvalidRegistrationParams::new(stake_pub_key.to_owned(), slot_no.clone()),
    )
    .await?;
    let mut invalid_registrations = Vec::new();
    while let Some(row) = invalid_registrations_iter.next().await {
        let row = row?;

        invalid_registrations.push(Cip36Details {
            slot_no: slot_no.clone(),
            stake_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.stake_address)?),
            vote_pub_key: Some(Ed25519HexEncodedPublicKey::try_from(row.vote_key)?),
            nonce: None,
            txn: None,
            payment_address: Some(Cip19ShelleyAddress::new(hex::encode(row.payment_address))),
            is_payable: row.is_payable,
            cip15: !row.cip36,
            errors: row
                .error_report
                .iter()
                .map(|e| ErrorMessage::from(e.to_string()))
                .collect(),
        });
    }

    Ok(invalid_registrations)
}

/// Stake addresses need to be individually checked to make sure they are still actively
/// associated with the voting key, and have not been registered to another voting key.
fn check_stake_addr_voting_key_association(
    registrations: Vec<Cip36Details>, associated_voting_key: &str,
) -> anyhow::Result<Vec<Cip36Details>> {
    let Ok(associated_key) = Ed25519HexEncodedPublicKey::try_from(associated_voting_key) else {
        return Err(anyhow::anyhow!(
            "Can't sort latest registrations by slot no"
        ));
    };

    Ok(registrations
        .into_iter()
        .filter(|r| {
            r.vote_pub_key
                .clone()
                .unwrap_or(Ed25519HexEncodedPublicKey::examples(0))
                == associated_key
        })
        .collect())
}

/// Get latest registration given a stake key hash.
#[allow(clippy::too_many_lines)]
pub(crate) async fn get_latest_registration_from_stake_key_hash(
    stake_hash: HexEncodedHash28, session: Arc<CassandraSession>,
) -> AllRegistration {
    // Get stake addr associated with give stake hash
    let mut stake_addr_iter = match GetStakeAddrQuery::execute(
        &session,
        GetStakeAddrParams::new(stake_hash.into()),
    )
    .await
    {
        Ok(latest) => latest,
        Err(err) => {
            error!(
                id="get_latest_registration_from_stake_key_hash_query_stake_addr",
                error=?err,
                "Failed to query stake addr from stake hash"
            );

            return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                format!("Failed to query stake addr from stake hash {err:?}"),
                StatusCode::UNPROCESSABLE_ENTITY,
            )]);
        },
    };

    if let Some(row_stake_addr) = stake_addr_iter.next().await {
        let row = match row_stake_addr {
            Ok(r) => r,
            Err(err) => {
                error!(
                    id="get_latest_registration_from_stake_key_hash_latest_registration",
                    error=?err,
                    "Failed to get latest registration"
                );

                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    format!("Failed to get latest registration {err:?}"),
                    StatusCode::UNPROCESSABLE_ENTITY,
                )]);
            },
        };

        let stake_pub_key = match Ed25519HexEncodedPublicKey::try_from(row.stake_address.clone()) {
            Ok(key) => key,
            Err(err) => {
                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    format!("Failed to type stake address {err:?}"),
                    StatusCode::UNPROCESSABLE_ENTITY,
                )]);
            },
        };

        let registration = match latest_registration_from_stake_addr(stake_pub_key, session.clone())
            .await
        {
            Ok(registration) => registration,
            Err(err) => {
                error!(
                    id="get_latest_registration_from_stake_key_hash_registration_for_stake_addr",
                    error=?err,
                    "Failed to obtain registration for given stake addr",
                );

                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    format!("Failed to obtain registration for given stake addr {err:?}"),
                    StatusCode::UNPROCESSABLE_ENTITY,
                )]);
            },
        };

        // include any erroneous registrations which occur AFTER the slot# of the last valid
        // registration
        let invalids_report = match get_invalid_registrations(
            &row.stake_address,
            registration.slot_no.clone(),
            session,
        )
        .await
        {
            Ok(invalids) => invalids,
            Err(err) => {
                error!(
                    id="get_latest_registration_from_stake_key_hash_invalid_registrations_for_stake_addr",
                    error=?err,
                    "Failed to obtain invalid registrations for given stake addr",
                );

                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    format!("Failed to obtain invalid registrations for given stake addr {err:?}"),
                    StatusCode::UNPROCESSABLE_ENTITY,
                )]);
            },
        };

        let Some(vote_pub_key) = registration.clone().vote_pub_key else {
            return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                "Vote pub key does not exist".to_string(),
                StatusCode::UNPROCESSABLE_ENTITY,
            )]);
        };

        return AllRegistration::With(Cip36Registration::Ok(poem_openapi::payload::Json(
            Cip36RegistrationList {
                slot: registration.clone().slot_no,
                voting_key: vec![Cip36RegistrationsForVotingPublicKey {
                    vote_pub_key,
                    registrations: vec![registration.clone()],
                }],
                invalid: invalids_report,
                page: None,
            },
        )));
    }

    AllRegistration::unprocessable_content(vec![poem::Error::from_string(
        "Stake hash does not exist",
        StatusCode::UNPROCESSABLE_ENTITY,
    )])
}
