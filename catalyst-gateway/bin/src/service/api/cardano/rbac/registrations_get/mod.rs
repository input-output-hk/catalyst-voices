//! Implementation of the GET `/rbac/registrations` endpoint.

use anyhow::Context;
use catalyst_types::catalyst_id::CatalystId;
use futures::TryStreamExt;
use itertools::Itertools;
pub use response::AllResponses;

mod binary_data;
mod extended_data;
mod invalid_registration;
mod invalid_registration_list;
mod key_data;
mod key_data_list;
mod key_type;
mod payment_data;
mod payment_data_list;
mod purpose_list;
mod registration_chain;
mod response;
mod role_data;
mod role_map;
mod unprocessable_content;

use futures::TryFutureExt;
use poem_openapi::payload::Json;
use tokio::try_join;

use crate::{
    db::index::{
        queries::rbac::get_rbac_invalid_registrations::Query as RbacInvalidQuery,
        session::CassandraSession,
    },
    rbac::latest_rbac_chain,
    service::{
        api::cardano::rbac::registrations_get::{
            registration_chain::RbacRegistrationChain, response::Responses,
            unprocessable_content::RbacUnprocessableContent,
        },
        common::{
            auth::rbac::token::CatalystRBACTokenV1,
            types::{cardano::query::cat_id_or_stake::CatIdOrStake, generic::boolean::BooleanFlag},
        },
    },
};

/// Get RBAC registration endpoint.
pub(crate) async fn endpoint(
    lookup: Option<CatIdOrStake>, token: Option<CatalystRBACTokenV1>,
    show_all_invalid: Option<BooleanFlag>,
) -> AllResponses {
    if lookup.is_none() && token.is_none() {
        return Responses::UnprocessableContent(Json(RbacUnprocessableContent::new(
            "Either lookup parameter or token must be provided",
        )))
        .into();
    }

    // Box::pin is used here because of the future size (`clippy::large_futures` lint).
    match Box::pin(reg_chain(
        lookup,
        token,
        show_all_invalid.unwrap_or_default().into(),
    ))
    .await
    {
        Err(e) => AllResponses::handle_error(&e),
        Ok(Some(c)) => Responses::Ok(Json(Box::new(c))).into(),
        Ok(None) => Responses::NotFound.into(),
    }
}

/// Returns a registration chain.
async fn reg_chain(
    lookup: Option<CatIdOrStake>, token: Option<CatalystRBACTokenV1>, show_all_invalid: bool,
) -> anyhow::Result<Option<RbacRegistrationChain>> {
    let persistent_session =
        CassandraSession::get(true).context("Failed to get persistent Cassandra session")?;
    let volatile_session =
        CassandraSession::get(false).context("Failed to get volatile Cassandra session")?;

    let Some(id) = catalyst_id(lookup, token, &persistent_session, &volatile_session).await? else {
        return Ok(None);
    };

    let (info, invalid_persistent, invalid_volatile) = try_join!(
        latest_rbac_chain(&id),
        invalid_registrations(id.clone(), &persistent_session),
        invalid_registrations(id.clone(), &volatile_session),
    )?;
    let first_invalid_slot = if show_all_invalid {
        0.into()
    } else {
        info.as_ref()
            .map(|i| i.chain.current_point().slot_or_default())
            .unwrap_or_default()
    };

    let invalid = invalid_persistent
        .into_iter()
        .chain(invalid_volatile)
        .filter(|r| r.slot_no >= first_invalid_slot.into())
        // Note: the sort order is reversed here `|a, b| b.cmp(a)` because by default the ascending
        // order is used, and we want the opposite (latest slots first).
        .sorted_by(|a, b| (b.slot_no, b.txn_index).cmp(&(a.slot_no, a.txn_index)))
        .map(Into::into)
        .collect::<Vec<_>>()
        .into();

    RbacRegistrationChain::new(id.into(), info.as_ref(), invalid)
}

/// Returns a Catalyst ID corresponding to the given stake address.
async fn catalyst_id(
    lookup: Option<CatIdOrStake>, token: Option<CatalystRBACTokenV1>,
    persistent_session: &CassandraSession, volatile_session: &CassandraSession,
) -> anyhow::Result<Option<CatalystId>> {
    use crate::db::index::queries::rbac::get_catalyst_id_from_stake_address::Query;

    Ok(Some(match lookup {
        Some(CatIdOrStake::CatId(id)) => id.into(),
        Some(CatIdOrStake::Address(address)) => {
            let address = address.try_into().context("Invalid stake address")?;
            match Query::latest(volatile_session, &address).await? {
                Some(id) => id,
                None => {
                    match Query::latest(persistent_session, &address).await? {
                        Some(id) => id,
                        None => return Ok(None),
                    }
                },
            }
        },
        None => {
            // This error is properly handled above and shouldn't occur here.
            token
                .context("Either lookup parameter or token must be provided")?
                .catalyst_id()
                .to_owned()
        },
    }))
}

/// Returns a list of invalid registrations.
async fn invalid_registrations(
    id: CatalystId, session: &CassandraSession,
) -> anyhow::Result<Vec<RbacInvalidQuery>> {
    use crate::db::index::queries::rbac::get_rbac_invalid_registrations::{Query, QueryParams};

    Query::execute(session, QueryParams {
        catalyst_id: id.into(),
    })
    .and_then(|r| r.try_collect().map_err(Into::into))
    .await
}
