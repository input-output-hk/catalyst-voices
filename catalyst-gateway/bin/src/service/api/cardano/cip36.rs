//! Implementation of the GET `/registration/cip36` endpoint

use std::{cmp::Reverse, sync::Arc};

use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::registrations::{
            get_from_stake_addr::{GetRegistrationParams, GetRegistrationQuery},
            get_from_stake_hash::{GetStakeAddrParams, GetStakeAddrQuery},
            get_from_vote_key::{GetStakeAddrFromVoteKeyParams, GetStakeAddrFromVoteKeyQuery},
            get_invalid::{GetInvalidRegistrationParams, GetInvalidRegistrationQuery},
        },
        session::CassandraSession,
    },
    service::common::responses::WithErrorResponses,
};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum ResponseSingleRegistration {
    /// Cip36 registration
    #[oai(status = 200)]
    Ok(Json<Cip36Reporting>),
    /// No valid registration
    #[oai(status = 404)]
    NotFound,
}

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum ResponseMultipleRegistrations {
    /// Cip36 registration
    #[oai(status = 200)]
    Ok(Json<Cip36ReportingList>),
    /// No valid registration
    #[oai(status = 404)]
    NotFound,
}

/// Cip36 info list
#[derive(Object, Default)]
pub(crate) struct Cip36ReportingList {
    /// List of registrations
    #[oai(validator(max_items = "100000"))]
    cip36: Vec<Cip36Reporting>,
}

/// Cip36 info + invalid reporting
#[derive(Object, Default)]
pub(crate) struct Cip36Reporting {
    /// List of registrations
    #[oai(validator(max_items = "100000"))]
    cip36: Vec<Cip36Info>,
    /// Invalid registration reporting
    #[oai(validator(max_items = "100000"))]
    invalids: Vec<InvalidRegistrationsReport>,
}

/// Cip36 info
#[derive(Object, Default)]
pub(crate) struct Cip36Info {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
    pub stake_address: String,
    /// Nonce value after normalization.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub nonce: u64,
    /// Slot Number the cert is in.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub slot_no: u64,
    /// Transaction Index.
    #[oai(validator(minimum(value = "0"), maximum(value = "9223372036854775807")))]
    pub txn: i16,
    /// Voting Public Key
    #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
    pub vote_key: String,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
    pub payment_address: String,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

/// Invalid registration error reporting
#[derive(Object, Default)]
pub(crate) struct InvalidRegistrationsReport {
    /// Error report
    #[oai(validator(max_items = "100000"))]
    pub error_report: Vec<String>,
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
    pub stake_address: String,
    /// Voting Public Key
    #[oai(validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]"))]
    pub vote_key: String,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    #[oai(validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]"))]
    pub payment_address: String,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

/// Single registration response
pub(crate) type SingleRegistrationResponse = WithErrorResponses<ResponseSingleRegistration>;
/// All responses voting key
pub(crate) type MultipleRegistrationResponse = WithErrorResponses<ResponseMultipleRegistrations>;

/// Get latest registration given a stake address
pub(crate) async fn get_latest_registration_from_stake_addr(
    stake_addr: String, persistent: bool,
) -> SingleRegistrationResponse {
    let stake_addr = match hex::decode(stake_addr) {
        Ok(stake_addr) => stake_addr,
        Err(err) => {
            error!("Failed to decode stake addr {:?}", err);
            return ResponseSingleRegistration::NotFound.into();
        },
    };

    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        return ResponseSingleRegistration::NotFound.into();
    };

    let registration =
        match latest_registration_from_stake_addr(stake_addr.clone(), session.clone()).await {
            Ok(registrations) => registrations,
            Err(err) => {
                error!(
                    "Failed to obtain registrations for given stake addr:{:?} {:?}",
                    hex::encode(stake_addr),
                    err
                );
                return ResponseSingleRegistration::NotFound.into();
            },
        };

    let invalids_report = match get_invalid_registrations(
        registration.stake_address.clone(),
        registration.slot_no.into(),
        session,
    )
    .await
    {
        Ok(invalids) => invalids,
        Err(err) => {
            error!(
                "Failed to obtain invalid registrations for given stake addr:{:?} {:?}",
                hex::encode(stake_addr),
                err
            );
            return ResponseSingleRegistration::NotFound.into();
        },
    };

    let report = Cip36Reporting {
        cip36: vec![registration],
        invalids: invalids_report,
    };

    ResponseSingleRegistration::Ok(Json(report)).into()
}

/// Get latest registration given a stake addr
async fn latest_registration_from_stake_addr(
    stake_addr: Vec<u8>, session: Arc<CassandraSession>,
) -> anyhow::Result<Cip36Info> {
    sort_latest_registration(get_all_registrations_from_stake_addr(session, stake_addr).await?)
}

/// Get all cip36 registrations for a given stake address.
async fn get_all_registrations_from_stake_addr(
    session: Arc<CassandraSession>, stake_addr: Vec<u8>,
) -> Result<Vec<Cip36Info>, anyhow::Error> {
    let mut registrations_iter =
        GetRegistrationQuery::execute(&session, GetRegistrationParams::new(stake_addr)).await?;
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

        let cip36 = Cip36Info {
            stake_address: hex::encode(row.stake_address),
            nonce,
            slot_no,
            txn: row.txn,
            vote_key: hex::encode(row.vote_key),
            payment_address: hex::encode(row.payment_address),
            is_payable: row.is_payable,
            cip36: row.cip36,
        };

        registrations.push(cip36);
    }
    Ok(registrations)
}

/// Sort latest registrations for a given stake address sorting by slot no
fn sort_latest_registration(mut registrations: Vec<Cip36Info>) -> anyhow::Result<Cip36Info> {
    registrations.sort_by_key(|k| Reverse(k.slot_no));
    registrations.into_iter().next().ok_or(anyhow::anyhow!(
        "Can't sort latest registrations by slot no"
    ))
}

/// Get invalid registrations for stake addr after given slot no
async fn get_invalid_registrations(
    stake_addr: String, slot_no: num_bigint::BigInt, session: Arc<CassandraSession>,
) -> anyhow::Result<Vec<InvalidRegistrationsReport>> {
    let stake_addr = hex::decode(stake_addr)?;

    let mut invalid_registrations_iter = GetInvalidRegistrationQuery::execute(
        &session,
        GetInvalidRegistrationParams::new(stake_addr, slot_no),
    )
    .await?;
    let mut invalid_registrations = Vec::new();
    while let Some(row) = invalid_registrations_iter.next().await {
        let row = row?;

        invalid_registrations.push(InvalidRegistrationsReport {
            error_report: row.error_report,
            stake_address: hex::encode(row.stake_address),
            vote_key: hex::encode(row.vote_key),
            payment_address: hex::encode(row.payment_address),
            is_payable: row.is_payable,
            cip36: row.cip36,
        });
    }

    Ok(invalid_registrations)
}

/// Stake addresses need to be individually checked to make sure they are still actively
/// associated with the voting key, and have not been registered to another voting key.
fn check_stake_addr_voting_key_association(
    registrations: Vec<Cip36Info>, associated_voting_key: &str,
) -> Vec<Cip36Info> {
    registrations
        .into_iter()
        .filter(|r| r.vote_key == associated_voting_key)
        .collect()
}

/// Get latest registration given a stake key hash.
pub(crate) async fn get_latest_registration_from_stake_key_hash(
    stake_hash: String, persistent: bool,
) -> SingleRegistrationResponse {
    let stake_hash = match hex::decode(stake_hash) {
        Ok(stake_hash) => stake_hash,
        Err(err) => {
            error!("Failed to decode stake addr {:?}", err);
            return ResponseSingleRegistration::NotFound.into();
        },
    };

    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        return ResponseSingleRegistration::NotFound.into();
    };

    // Get stake addr associated with give stake hash
    let mut stake_addr_iter =
        match GetStakeAddrQuery::execute(&session, GetStakeAddrParams::new(stake_hash)).await {
            Ok(latest) => latest,
            Err(err) => {
                error!("Failed to query stake addr from stake hash {:?}", err);
                return ResponseSingleRegistration::NotFound.into();
            },
        };

    if let Some(row_stake_addr) = stake_addr_iter.next().await {
        let row = match row_stake_addr {
            Ok(r) => r,
            Err(err) => {
                error!("Failed to get latest registration {:?}", err);
                return ResponseSingleRegistration::NotFound.into();
            },
        };

        let registration =
            match latest_registration_from_stake_addr(row.stake_address.clone(), session.clone())
                .await
            {
                Ok(registration) => registration,
                Err(err) => {
                    error!(
                        "Failed to obtain registration for given stake addr:{:?} {:?}",
                        hex::encode(row.stake_address),
                        err
                    );
                    return ResponseSingleRegistration::NotFound.into();
                },
            };

        // include any erroneous registrations which occur AFTER the slot# of the last valid
        // registration
        let invalids_report = match get_invalid_registrations(
            registration.stake_address.clone(),
            registration.slot_no.into(),
            session,
        )
        .await
        {
            Ok(invalids) => invalids,
            Err(err) => {
                error!(
                    "Failed to obtain invalid registrations for given stake addr:{:?} {:?}",
                    hex::encode(registration.stake_address.clone()),
                    err
                );
                return ResponseSingleRegistration::NotFound.into();
            },
        };

        let report = Cip36Reporting {
            cip36: vec![registration],
            invalids: invalids_report,
        };

        return ResponseSingleRegistration::Ok(Json(report)).into();
    }

    ResponseSingleRegistration::NotFound.into()
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
            error!("Failed to decode vote key {:?}", err);
            return ResponseMultipleRegistrations::NotFound.into();
        },
    };

    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
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
            error!("Failed to query stake addr from vote key {:?}", err);
            return ResponseMultipleRegistrations::NotFound.into();
        },
    };

    if let Some(row_stake_addr) = stake_addr_iter.next().await {
        let row = match row_stake_addr {
            Ok(r) => r,
            Err(err) => {
                error!("Failed to get latest registration {:?}", err);
                return ResponseMultipleRegistrations::NotFound.into();
            },
        };

        // We have the stake addr associated with vote key, now get all registrations with the
        // stake addr.
        let registrations =
            match get_all_registrations_from_stake_addr(session.clone(), row.stake_address.clone())
                .await
            {
                Ok(registration) => registration,
                Err(err) => {
                    error!(
                        "Failed to obtain registrations for given stake addr:{:?} {:?}",
                        hex::encode(row.stake_address),
                        err
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
        let mut reports = Cip36ReportingList { cip36: Vec::new() };

        for registration in redacted_registrations {
            let invalids_report = match get_invalid_registrations(
                registration.stake_address.clone(),
                registration.slot_no.into(),
                session.clone(),
            )
            .await
            {
                Ok(invalids) => invalids,
                Err(err) => {
                    error!(
                        "Failed to obtain invalid registrations for given stake addr:{:?} {:?}",
                        hex::encode(registration.stake_address.clone()),
                        err
                    );
                    continue;
                },
            };

            let report = Cip36Reporting {
                cip36: vec![registration],
                invalids: invalids_report,
            };

            reports.cip36.push(report);
        }

        return ResponseMultipleRegistrations::Ok(Json(reports)).into();
    }

    ResponseMultipleRegistrations::NotFound.into()
}
