//! Implementation of the GET `/cardano/cip36` endpoint

use std::time::Duration;

use poem::http::HeaderMap;
use tokio::time::sleep;

use super::{
    cardano::{self},
    response, NoneOrRBAC, SlotNo,
};
use crate::service::common::{self};

/// Process the endpoint operation
pub(crate) async fn cip36_registrations(
    _lookup: Option<cardano::query::stake_or_voter::StakeOrVoter>, _asat: Option<SlotNo>,
    _page: common::types::generic::query::pagination::Page,
    _limit: common::types::generic::query::pagination::Limit, _auth: NoneOrRBAC,
    _headers: &HeaderMap,
) -> response::AllRegistration {
    // Dummy sleep, remove it
    sleep(Duration::from_millis(1)).await;

    // Todo: refactor the below into a single operation here.

    // If _asat is None, then get the latest slot number from the chain follower and use that.
    // If _for is not defined, use the stake addresses defined for Role0 in the _auth
    // parameter. _auth not yet implemented, so put placeholder for that, and return not
    // found until _auth is implemented.

    response::Cip36Registration::NotFound.into()
}
