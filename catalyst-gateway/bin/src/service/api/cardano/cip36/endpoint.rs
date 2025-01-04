//! Implementation of the GET `/cardano/cip36` endpoint

use poem::http::{HeaderMap, StatusCode};
use tracing::{error, info};

use self::cardano::{hash28::HexEncodedHash28, query::stake_or_voter::StakeAddressOrPublicKey};
use super::{
    cardano::{self},
    old_endpoint::get_latest_registration_from_stake_key_hash,
    response, NoneOrRBAC, SlotNo,
};
use crate::service::common::{self};

/// Process the endpoint operation
#[allow(clippy::unused_async)]
pub(crate) async fn cip36_registrations(
    lookup: Option<cardano::query::stake_or_voter::StakeOrVoter>, asat: Option<SlotNo>,
    _page: common::types::generic::query::pagination::Page,
    _limit: common::types::generic::query::pagination::Limit, _auth: NoneOrRBAC,
    _headers: &HeaderMap,
) -> response::AllRegistration {
    if let Some(_slot) = asat {
    } else {
        // If _asat is None, then get the latest slot number from the chain follower and
        // use that.
    }

    if let Some(stake_or_voter) = lookup {
        match StakeAddressOrPublicKey::from(stake_or_voter) {
            StakeAddressOrPublicKey::Address(cip19_stake_address) => {
                // Convert stake address into stake key hash
                let stake_hash: HexEncodedHash28 = match cip19_stake_address.try_into() {
                    Ok(stake_hash) => stake_hash,
                    Err(err) => {
                        error!("stake addr to stake hash {:?}", err);
                        return response::AllRegistration::unprocessable_content(vec![
                            poem::Error::from_string(
                                "Invalid Stake Address or Voter Key",
                                StatusCode::UNPROCESSABLE_ENTITY,
                            ),
                        ]);
                    },
                };

                // Get stake public key from stake hash
                match get_latest_registration_from_stake_key_hash(stake_hash.to_string(), true)
                    .await
                {
                    common::responses::WithErrorResponses::With(resp) => resp,
                    common::responses::WithErrorResponses::Error(_error_responses) => {
                        return response::AllRegistration::unprocessable_content(vec![
                            poem::Error::from_string(
                                "Invalid Stake Address or Voter Key",
                                StatusCode::UNPROCESSABLE_ENTITY,
                            ),
                        ]);
                    },
                }
            },
            StakeAddressOrPublicKey::PublicKey(_ed25519_hex_encoded_public_key) => {
                info!("stake public key conor");
                return response::AllRegistration::unprocessable_content(vec![
                    poem::Error::from_string(
                        "Invalid Stake Address or Voter Key",
                        StatusCode::UNPROCESSABLE_ENTITY,
                    ),
                ]);
            },
            StakeAddressOrPublicKey::All => {
                info!("stake address conor all");
                return response::AllRegistration::unprocessable_content(vec![
                    poem::Error::from_string(
                        "Invalid Stake Address or Voter Key",
                        StatusCode::UNPROCESSABLE_ENTITY,
                    ),
                ]);
            },
        };
    };

    // If _for is not defined, use the stake addresses defined for Role0 in the _auth
    // parameter. _auth not yet implemented, so put placeholder for that, and return not
    // found until _auth is implemented.

    // return 404 for auth
    // distill down to stake addr or list of stake addr
    // stake addr hash for cip36 registratioin

    response::Cip36Registration::NotFound.into()
}
