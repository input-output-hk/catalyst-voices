//! Implementation of the GET `/registration/cip36` endpoint

use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse, Object};
use tracing::error;

use crate::{
    db::index::{
        queries::registrations::{
            get_latest_w_stake_addr::{GetLatestRegistrationParams, GetLatestRegistrationQuery},
            get_latest_w_stake_hash::{GetStakeAddrParams, GetStakeAddrQuery},
            get_latest_w_vote_key::{GetStakeAddrFromVoteKeyParams, GetStakeAddrFromVoteKeyQuery},
        },
        session::CassandraSession,
    },
    service::common::responses::WithErrorResponses,
};

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// Cip36 registration
    #[oai(status = 200)]
    Ok(Json<Cip36Info>),
    /// No valid registration found for the provided stake address or stake key hash
    #[oai(status = 404)]
    NotFound,
}

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum ResponsesVoteKey {
    /// Cip36 registration
    #[oai(status = 200)]
    Ok(Json<Vec<Cip36Info>>),
    /// No valid registration found for the provided stake address or stake key hash
    #[oai(status = 404)]
    NotFound,
}

/// Cip36 info
#[derive(Object, Default)]
pub(crate) struct Cip36Info {
    /// Full Stake Address (not hashed, 32 byte ED25519 Public key).
    pub stake_address: Vec<u8>,
    /// Nonce value after normalization.
    pub nonce: u64,
    /// Slot Number the cert is in.
    pub slot_no: u64,
    /// Transaction Index.
    pub txn: i16,
    /// Voting Public Key
    pub vote_key: Vec<u8>,
    /// Full Payment Address (not hashed, 32 byte ED25519 Public key).
    pub payment_address: Vec<u8>,
    /// Is the stake address a script or not.
    pub is_payable: bool,
    /// Is the Registration CIP36 format, or CIP15
    pub cip36: bool,
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;
/// All response vote key
pub(crate) type AllResponsesVoteKey = WithErrorResponses<ResponsesVoteKey>;

/// Get latest registration given stake address
pub(crate) async fn get_latest_registration_from_stake_addr(
    stake_addr: String, persistent: bool,
) -> AllResponses {
    let stake_addr = match hex::decode(stake_addr) {
        Ok(stake_addr) => stake_addr,
        Err(err) => {
            error!("Failed to decode stake addr {:?}", err);
            return Responses::NotFound.into();
        },
    };

    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        return Responses::NotFound.into();
    };

    let mut registrations_iter = match GetLatestRegistrationQuery::execute(
        &session,
        GetLatestRegistrationParams::new(stake_addr),
    )
    .await
    {
        Ok(latest) => latest,
        Err(err) => {
            error!("Failed to query latest registration {:?}", err);
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

        let nonce = if let Some(nonce) = row.nonce.into_parts().1.to_u64_digits().first() {
            *nonce
        } else {
            error!("Issue downcasting nonce");
            return Responses::NotFound.into();
        };

        let slot_no = if let Some(slot_no) = row.slot_no.into_parts().1.to_u64_digits().first() {
            *slot_no
        } else {
            error!("Issue downcasting slot no");
            return Responses::NotFound.into();
        };

        let cip36 = Cip36Info {
            stake_address: row.stake_address,
            nonce,
            slot_no,
            txn: row.txn,
            vote_key: row.vote_key,
            payment_address: row.payment_address,
            is_payable: row.is_payable,
            cip36: row.cip36,
        };

        return Responses::Ok(Json(cip36)).into();
    }

    Responses::NotFound.into()
}

/// Get latest registration given stake key hash
pub(crate) async fn get_latest_registration_from_stake_key_hash(
    stake_hash: String, persistent: bool,
) -> AllResponses {
    let stake_hash = match hex::decode(stake_hash) {
        Ok(stake_hash) => stake_hash,
        Err(err) => {
            error!("Failed to decode stake addr {:?}", err);
            return Responses::NotFound.into();
        },
    };

    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        return Responses::NotFound.into();
    };

    let mut stake_addr_iter =
        match GetStakeAddrQuery::execute(&session, GetStakeAddrParams::new(stake_hash)).await {
            Ok(latest) => latest,
            Err(err) => {
                error!("Failed to query stake addr from stake hash {:?}", err);
                return Responses::NotFound.into();
            },
        };

    if let Some(row_stake_addr) = stake_addr_iter.next().await {
        let row = match row_stake_addr {
            Ok(r) => r,
            Err(err) => {
                error!("Failed to get latest registration {:?}", err);
                return Responses::NotFound.into();
            },
        };

        let mut registrations_iter = match GetLatestRegistrationQuery::execute(
            &session,
            GetLatestRegistrationParams::new(row.stake_address),
        )
        .await
        {
            Ok(latest) => latest,
            Err(err) => {
                error!("Failed to query latest registration {:?}", err);
                return Responses::NotFound.into();
            },
        };

        if let Some(row_latest_registration) = registrations_iter.next().await {
            let row = match row_latest_registration {
                Ok(r) => r,
                Err(err) => {
                    error!("Failed to get latest registration {:?}", err);
                    return Responses::NotFound.into();
                },
            };

            let nonce = if let Some(nonce) = row.nonce.into_parts().1.to_u64_digits().first() {
                *nonce
            } else {
                error!("Issue downcasting nonce");
                return Responses::NotFound.into();
            };

            let slot_no = if let Some(slot_no) = row.slot_no.into_parts().1.to_u64_digits().first()
            {
                *slot_no
            } else {
                error!("Issue downcasting slot no");
                return Responses::NotFound.into();
            };

            let cip36 = Cip36Info {
                stake_address: row.stake_address,
                nonce,
                slot_no,
                txn: row.txn,
                vote_key: row.vote_key,
                payment_address: row.payment_address,
                is_payable: row.is_payable,

                cip36: row.cip36,
            };

            return Responses::Ok(Json(cip36)).into();
        }
    }

    Responses::NotFound.into()
}

/// Get latest registration given vote key
pub(crate) async fn get_latest_registration_from_vote_key(
    vote_key: String, persistent: bool,
) -> AllResponsesVoteKey {
    let vote_key = match hex::decode(vote_key) {
        Ok(vote_key) => vote_key,
        Err(err) => {
            error!("Failed to decode vote key {:?}", err);
            return ResponsesVoteKey::NotFound.into();
        },
    };

    let Some(session) = CassandraSession::get(persistent) else {
        error!("Failed to acquire db session");
        return ResponsesVoteKey::NotFound.into();
    };

    let mut stake_addr_iter = match GetStakeAddrFromVoteKeyQuery::execute(
        &session,
        GetStakeAddrFromVoteKeyParams::new(vote_key),
    )
    .await
    {
        Ok(latest) => latest,
        Err(err) => {
            error!("Failed to query stake addr from vote key {:?}", err);
            return ResponsesVoteKey::NotFound.into();
        },
    };

    if let Some(row_stake_addr) = stake_addr_iter.next().await {
        let row = match row_stake_addr {
            Ok(r) => r,
            Err(err) => {
                error!("Failed to get latest registration {:?}", err);
                return ResponsesVoteKey::NotFound.into();
            },
        };

        let mut registrations_iter = match GetLatestRegistrationQuery::execute(
            &session,
            GetLatestRegistrationParams::new(row.stake_address),
        )
        .await
        {
            Ok(latest) => latest,
            Err(err) => {
                error!("Failed to query latest registration {:?}", err);
                return ResponsesVoteKey::NotFound.into();
            },
        };

        // list of stake address registrations currently associated with a given voting key
        let mut stake_addrs = Vec::new();
        while let Some(row_latest_registration) = registrations_iter.next().await {
            let row = match row_latest_registration {
                Ok(r) => r,
                Err(err) => {
                    error!("Failed to get latest registration {:?}", err);
                    return ResponsesVoteKey::NotFound.into();
                },
            };

            let nonce = if let Some(nonce) = row.nonce.into_parts().1.to_u64_digits().first() {
                *nonce
            } else {
                error!("Issue downcasting nonce");
                return ResponsesVoteKey::NotFound.into();
            };

            let slot_no = if let Some(slot_no) = row.slot_no.into_parts().1.to_u64_digits().first()
            {
                *slot_no
            } else {
                error!("Issue downcasting slot no");
                return ResponsesVoteKey::NotFound.into();
            };

            let cip36 = Cip36Info {
                stake_address: row.stake_address,
                nonce,
                slot_no,
                txn: row.txn,
                vote_key: row.vote_key,
                payment_address: row.payment_address,
                is_payable: row.is_payable,

                cip36: row.cip36,
            };

            stake_addrs.push(cip36);
        }

        return ResponsesVoteKey::Ok(Json(stake_addrs)).into();
    }

    ResponsesVoteKey::NotFound.into()
}
