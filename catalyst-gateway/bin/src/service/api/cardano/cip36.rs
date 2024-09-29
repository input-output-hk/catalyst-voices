//! Implementation of the GET `/registration/cip36` endpoint

use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::registrations::get_latest_registration_w_stake_addr::{
            GetLatestRegistrationParams, GetLatestRegistrationQuery,
        },
        session::CassandraSession,
    },
    service::common::responses::WithErrorResponses,
};

/// Endpoint responses
#[derive(ApiResponse)]
#[allow(dead_code)]
pub(crate) enum Responses {
    /// The registration information for the stake address queried.
    #[oai(status = 200)]
    Ok(Json<Cip36Info>),
    /// No valid registration found for the provided stake address
    /// and provided slot number.
    #[oai(status = 404)]
    NotFound,
}

/// User's cardano stake info.
#[derive(Object, Default)]
pub(crate) struct Cip36Info {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_address: Vec<u8>,
    /// Nonce value after normalization.
    pub nonce: i64,
    /// Slot Number the cert is in.
    pub slot_no: i64,
    /// Transaction Index.
    pub txn: i16,
    /// Voting Public Key
    pub vote_key: Vec<u8>,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    pub payment_address: Vec<u8>,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Raw nonce value.
    pub raw_nonce: i64,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get latest registration given a stake key hash or stake address
pub(crate) async fn latest_registration(persistent: bool) -> AllResponses {
    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        return Responses::NotFound.into();
    };

    let stake_addr =
        match hex::decode("76e7ac0e460b6cdecea4be70479dab13c4adbd117421259a9b36caac007394de") {
            Ok(k) => k,
            Err(_err) => return Responses::NotFound.into(),
        };

    let mut registrations_iter = match GetLatestRegistrationQuery::execute(
        &session,
        GetLatestRegistrationParams::new(stake_addr),
    )
    .await
    {
        Ok(latest) => latest,
        Err(err) => {
            error!("Failed to get latest registration {:?}", err);
            return Responses::NotFound.into();
        },
    };

    if let Some(row_res) = registrations_iter.next().await {
        let row = match row_res {
            Ok(r) => r,
            Err(err) => {
                error!("Failed to get latest registration {:?}", err);
                return Responses::NotFound.into();
            },
        };

        let cip36 = Cip36Info {
            stake_address: row.stake_address,
            nonce: 1,
            slot_no: 1,
            txn: row.txn,
            vote_key: row.vote_key,
            payment_address: row.payment_address,
            is_payable: row.is_payable,
            raw_nonce: 1,
            cip36: row.cip36,
        };

        return Responses::Ok(Json(cip36)).into();
    }

    Responses::NotFound.into()
}
