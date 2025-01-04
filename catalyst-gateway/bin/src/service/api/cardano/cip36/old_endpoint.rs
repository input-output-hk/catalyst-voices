//! Implementation of the GET `/cardano/cip36` endpoint

use std::{cmp::Reverse, sync::Arc};

use futures::StreamExt;
use poem::http::StatusCode;
use poem_openapi::{payload::Json, ApiResponse};
use tracing::error;

use super::{
    cardano::{cip19_shelley_address::Cip19ShelleyAddress, nonce::Nonce, txn_index::TxnIndex},
    common::{objects::generic::pagination::CurrentPage, types::generic::error_msg::ErrorMessage},
    response::{
        AllRegistration, Cip36Details, Cip36Registration, Cip36RegistrationList,
        Cip36RegistrationsForVotingPublicKey,
    },
    Ed25519HexEncodedPublicKey, SlotNo,
};
use crate::{
    db::index::{
        queries::registrations::{
            get_from_stake_addr::GetRegistrationQuery,
            get_from_stake_hash::{GetStakeAddrParams, GetStakeAddrQuery},
            get_from_vote_key::{GetStakeAddrFromVoteKeyParams, GetStakeAddrFromVoteKeyQuery},
            get_invalid::{GetInvalidRegistrationParams, GetInvalidRegistrationQuery},
        },
        session::CassandraSession,
    },
    service::common::{
        objects::cardano::cip36::{Cip36Reporting, Cip36ReportingList},
        responses::WithErrorResponses,
    },
};

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum ResponseSingleRegistration {
    /// A CIP36 registration report.
    #[oai(status = 200)]
    Ok(Json<Cip36Reporting>),
    /// No valid registration.
    #[oai(status = 404)]
    NotFound,
}

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum ResponseMultipleRegistrations {
    /// All CIP36 registrations associated with the same Voting Key.
    #[oai(status = 200)]
    Ok(Json<Cip36ReportingList>),
    /// No valid registration.
    #[oai(status = 404)]
    NotFound,
}

/// Single registration response
pub(crate) type SingleRegistrationResponse = WithErrorResponses<ResponseSingleRegistration>;
/// All responses voting key
pub(crate) type MultipleRegistrationResponse = WithErrorResponses<ResponseMultipleRegistrations>;

/// Get latest registration given a stake public key
pub(crate) async fn get_latest_registration_from_stake_addr(
    stake_pub_key: Vec<u8>, persistent: bool,
) -> SingleRegistrationResponse {
    let Some(session) = CassandraSession::get(persistent) else {
        error!(
            id = "get_latest_registration_from_stake_addr",
            "Failed to acquire db session"
        );
        return ResponseSingleRegistration::NotFound.into();
    };

    let registration =
        match latest_registration_from_stake_addr(stake_pub_key.clone(), session.clone()).await {
            Ok(registrations) => registrations,
            Err(err) => {
                error!(
                    id="get_latest_registration_from_stake_addr",
                    error=?err,
                    "Failed to obtain registrations for given stake addr",
                );
                return ResponseSingleRegistration::NotFound.into();
            },
        };

    let raw_invalids =
        get_invalid_registrations(&stake_pub_key, registration.slot_no, session).await;

    let _invalids_report = match raw_invalids {
        Ok(invalids) => invalids,
        Err(err) => {
            error!(
                id="get_latest_registration_from_stake_addr",
                error=?err,
                "Failed to obtain invalid registrations for given stake addr",
            );
            return ResponseSingleRegistration::NotFound.into();
        },
    };

    ResponseSingleRegistration::NotFound.into()
}

/// Get latest registration given a stake addr
async fn latest_registration_from_stake_addr(
    stake_pub_key: Vec<u8>, session: Arc<CassandraSession>,
) -> anyhow::Result<Cip36Details> {
    sort_latest_registration(
        get_all_registrations_from_stake_pub_key(session, stake_pub_key).await?,
    )
}

/// Get all cip36 registrations for a given stake address.
async fn get_all_registrations_from_stake_pub_key(
    session: Arc<CassandraSession>, stake_pub_key: Vec<u8>,
) -> Result<Vec<Cip36Details>, anyhow::Error> {
    let mut registrations_iter =
        GetRegistrationQuery::execute(&session, stake_pub_key.into()).await?;
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
    registrations.sort_by_key(|k| Reverse(k.slot_no.clone()));
    registrations.into_iter().next().ok_or(anyhow::anyhow!(
        "Can't sort latest registrations by slot no"
    ))
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
) -> Vec<Cip36Details> {
    registrations
        .into_iter()
        .filter(|r| {
            r.vote_pub_key.clone().unwrap()
                == Ed25519HexEncodedPublicKey::try_from(associated_voting_key).unwrap()
        })
        .collect()
}

/// Get latest registration given a stake key hash.
pub(crate) async fn get_latest_registration_from_stake_key_hash(
    stake_hash: String, persistent: bool,
) -> AllRegistration {
    let stake_hash = match hex::decode(stake_hash) {
        Ok(stake_hash) => stake_hash,
        Err(err) => {
            error!(id="get_latest_registration_from_stake_key_hash_stake_hash",error=?err, "Failed to decode stake hash");
            // return ResponseSingleRegistration::NotFound.into();
            return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                "Invalid Stake Address or Voter Key",
                StatusCode::UNPROCESSABLE_ENTITY,
            )]);
        },
    };

    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        let _err = anyhow::anyhow!("Failed to acquire db session");
        // return SingleRegistrationResponse::service_unavailable(&err,
        // RetryAfterOption::Default);
        return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
            "Invalid Stake Address or Voter Key",
            StatusCode::UNPROCESSABLE_ENTITY,
        )]);
    };

    // Get stake addr associated with give stake hash
    let mut stake_addr_iter =
        match GetStakeAddrQuery::execute(&session, GetStakeAddrParams::new(stake_hash)).await {
            Ok(latest) => latest,
            Err(err) => {
                error!(
                    id="get_latest_registration_from_stake_key_hash_query_stake_addr",
                    error=?err,
                    "Failed to query stake addr from stake hash"
                );
                // return ResponseSingleRegistration::NotFound.into();
                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    "Invalid Stake Address or Voter Key",
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
                // return ResponseSingleRegistration::NotFound.into();
                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    "Invalid Stake Address or Voter Key",
                    StatusCode::UNPROCESSABLE_ENTITY,
                )]);
            },
        };

        let registration = match latest_registration_from_stake_addr(
            row.stake_address.clone(),
            session.clone(),
        )
        .await
        {
            Ok(registration) => registration,
            Err(err) => {
                error!(
                    id="get_latest_registration_from_stake_key_hash_registration_for_stake_addr",
                    error=?err,
                    "Failed to obtain registration for given stake addr",
                );
                // return ResponseSingleRegistration::NotFound.into();
                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    "Invalid Stake Address or Voter Key",
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
                // return ResponseSingleRegistration::NotFound.into();
                return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
                    "Invalid Stake Address or Voter Key",
                    StatusCode::UNPROCESSABLE_ENTITY,
                )]);
            },
        };

        let r = Cip36RegistrationsForVotingPublicKey {
            vote_pub_key: registration.vote_pub_key.clone().unwrap(),
            registrations: vec![registration.clone()],
        };

        let a = Cip36RegistrationList {
            slot: registration.slot_no,
            voting_key: vec![r],
            invalid: invalids_report,
            page: CurrentPage::new(1, 1, 1).unwrap(),
        };

        return AllRegistration::With(Cip36Registration::Ok(poem_openapi::payload::Json(a)));
    }

    AllRegistration::unprocessable_content(vec![poem::Error::from_string(
        "Invalid Stake Address or Voter Key",
        StatusCode::UNPROCESSABLE_ENTITY,
    )])
}

/// Returns the list of stake address registrations currently associated with a given
/// voting key and returns any erroneous registrations which occur AFTER the slot# of the
/// last valid registration.
pub(crate) async fn get_associated_vote_key_registrations(
    vote_key: String, persistent: bool,
) -> MultipleRegistrationResponse {
    let vote_key = match hex::decode(vote_key) {
        Ok(vote_key) => vote_key,
        Err(err) => {
            error!(
                id="get_associated_vote_key_registrations_vote_key",
                error=?err,
                "Failed to decode vote key"
            );
            return ResponseMultipleRegistrations::NotFound.into();
        },
    };

    let Some(session) = CassandraSession::get(persistent) else {
        error!(
            id = "get_associated_vote_key_registrations_db_session",
            "Failed to acquire db session"
        );
        return ResponseMultipleRegistrations::NotFound.into();
    };

    let mut stake_addr_iter = match GetStakeAddrFromVoteKeyQuery::execute(
        &session,
        GetStakeAddrFromVoteKeyParams::new(vote_key.clone()),
    )
    .await
    {
        Ok(latest) => latest,
        Err(err) => {
            error!(
                id="get_associated_vote_key_registrations_query_stake_addr_from_vote_key",
                error=?err,
                "Failed to query stake addr from vote key"
            );
            return ResponseMultipleRegistrations::NotFound.into();
        },
    };

    if let Some(row_stake_addr) = stake_addr_iter.next().await {
        let row = match row_stake_addr {
            Ok(r) => r,
            Err(err) => {
                error!(
                    id="get_associated_vote_key_registrations_latest_registration",
                    error=?err,
                    "Failed to get latest registration"
                );
                return ResponseMultipleRegistrations::NotFound.into();
            },
        };

        // We have the stake addr associated with vote key, now get all registrations with the
        // stake addr.
        let registrations = match get_all_registrations_from_stake_pub_key(
            session.clone(),
            row.stake_address.clone(),
        )
        .await
        {
            Ok(registration) => registration,
            Err(err) => {
                error!(
                    id="get_associated_vote_key_registrations_get_registrations_for_stake_addr",
                    error=?err,
                    "Failed to obtain registrations for given stake addr",
                );
                return ResponseMultipleRegistrations::NotFound.into();
            },
        };

        // check registrations (stake addrs) are still actively associated with the voting key,
        // and have not been registered to another voting key.
        let redacted_registrations =
            check_stake_addr_voting_key_association(registrations, &hex::encode(vote_key));

        // Report includes registration info and  any erroneous registrations which occur AFTER
        // the slot# of the last valid registration
        let reports = Cip36ReportingList::new();

        for registration in redacted_registrations {
            let _invalids_report = match get_invalid_registrations(
                &row.stake_address,
                registration.slot_no,
                session.clone(),
            )
            .await
            {
                Ok(invalids) => invalids,
                Err(err) => {
                    error!(
                        id="get_associated_vote_key_registrations_invalid_registrations_for_stake_addr",
                        error=?err,
                        "Failed to obtain invalid registrations for given stake addr",
                    );
                    continue;
                },
            };
        }

        return ResponseMultipleRegistrations::Ok(Json(reports)).into();
    }

    ResponseMultipleRegistrations::NotFound.into()
}
