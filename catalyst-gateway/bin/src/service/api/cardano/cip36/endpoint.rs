//! Implementation of the GET `/cardano/cip36` endpoint

use poem::http::{HeaderMap, StatusCode};
use tracing::error;

use self::cardano::{hash28::HexEncodedHash28, query::stake_or_voter::StakeAddressOrPublicKey};
use super::{
    cardano::{self},
    filter::{get_registration_given_stake_key_hash, get_registration_given_vote_key, snapshot},
    response, SlotNo,
};
use crate::{
    db::index::session::CassandraSession,
    service::{
        api::cardano::cip36::response::AllRegistration,
        common::{self},
    },
};

/// Process the endpoint operation
pub(crate) async fn cip36_registrations(
    lookup: Option<cardano::query::stake_or_voter::StakeOrVoter>, asat: Option<SlotNo>,
    _page: common::types::generic::query::pagination::Page,
    _limit: common::types::generic::query::pagination::Limit, _headers: &HeaderMap,
) -> response::AllRegistration {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        return AllRegistration::unprocessable_content(vec![poem::Error::from_string(
            "Connection issue",
            StatusCode::UNPROCESSABLE_ENTITY,
        )]);
    };

    if let Some(stake_or_voter) = lookup {
        match StakeAddressOrPublicKey::from(stake_or_voter) {
            StakeAddressOrPublicKey::Address(cip19_stake_address) => {
                // Typically, a stake address will start with 'stake1',
                // We need to convert this to a stake hash as per our data model to then find the,
                // Full Stake Public Key (32 byte Ed25519 Public key, not hashed).
                // We then get the latest registration or from a specific time as optionally
                // specified in the query parameter. This can be represented as either
                // the blockchains slot number or a unix timestamp.
                let stake_hash: HexEncodedHash28 = match cip19_stake_address.try_into() {
                    Ok(stake_hash) => stake_hash,
                    Err(err) => {
                        return response::AllRegistration::unprocessable_content(vec![
                            poem::Error::from_string(
                                format!("Stake addr to stake hash conversion error: {err:?}"),
                                StatusCode::UNPROCESSABLE_ENTITY,
                            ),
                        ]);
                    },
                };

                return get_registration_given_stake_key_hash(stake_hash, session, asat).await;
            },
            StakeAddressOrPublicKey::PublicKey(ed25519_hex_encoded_public_key) => {
                // As above...
                // Except using a voting key.
                return get_registration_given_vote_key(
                    ed25519_hex_encoded_public_key,
                    session,
                    asat,
                )
                .await;
            },
            StakeAddressOrPublicKey::All =>
            // As above...
            // Snapshot replacement, returns all registrations or returns a
            // subset of registrations if constrained by a given time.
            {
                return snapshot(session, asat).await
            },
        };
    };

    // If _for is not defined, use the stake addresses defined for Role0 in the _auth
    // parameter. _auth not yet implemented, so put placeholder for that, and return not
    // found until _auth is implemented.

    response::Cip36Registration::NotFound.into()
}
