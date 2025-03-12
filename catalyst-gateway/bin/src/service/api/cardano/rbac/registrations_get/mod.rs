//! Implementation of the GET `/rbac/registrations` endpoint.

mod cip509;
mod rbac_reg;
mod reg_chain;
mod unprocessable_content;

use anyhow::{anyhow, Context};
use cardano_blockchain_types::{Point, StakeAddress};
use cardano_chain_follower::ChainFollower;
use catalyst_types::id_uri::IdUri;
use cip509::Cip509List;
use futures::StreamExt;
use poem_openapi::{payload::Json, ApiResponse};
use rbac_reg::{RbacReg, RbacRegistration, RbacRegistrations};
use reg_chain::RegChain;
use tracing::error;
use unprocessable_content::RbacUnprocessableContent;

use crate::{
    db::index::{
        queries::rbac::{
            get_catalyst_id_from_stake_address::{
                Query as CatalystIdQuery, QueryParams as CatalystIdQueryParams,
            },
            get_rbac_registrations::{Query as RbacQuery, QueryParams as RbacQueryParams},
        },
        session::CassandraSession,
    },
    service::common::{
        responses::WithErrorResponses,
        types::{
            cardano::query::cat_id_or_stake::CatIdOrStake, headers::retry_after::RetryAfterOption,
        },
    },
    settings::Settings,
};

/// Endpoint responses.
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// ## Ok
    ///
    /// Success returns a list of registration transaction ids.
    #[oai(status = 200)]
    Ok(Json<Box<RbacRegistrations>>),

    /// No valid registration.
    #[oai(status = 404)]
    NotFound,

    /// Response for unprocessable content.
    #[oai(status = 422)]
    UnprocessableContent(Json<RbacUnprocessableContent>),
}

pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// Get RBAC registration endpoint.
pub(crate) async fn endpoint(
    lookup: Option<CatIdOrStake>, auth_catalyst_id: Option<IdUri>, detailed: bool,
) -> AllResponses {
    let Some(session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow::anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    let catalyst_id = match lookup {
        Some(CatIdOrStake::CatId(v)) => v.into(),
        Some(CatIdOrStake::Address(address)) => {
            let address = match address.try_into() {
                Ok(a) => a,
                Err(e) => return AllResponses::handle_error(&e),
            };
            match catalyst_id_from_stake(&session, address).await {
                Ok(Some(v)) => v,
                Ok(None) => return Responses::NotFound.into(),
                Err(e) => return AllResponses::handle_error(&e),
            }
        },
        None => {
            match auth_catalyst_id {
                Some(id) => id,
                None => {
                    return Responses::UnprocessableContent(Json(RbacUnprocessableContent::new(
                        "Either lookup parameter or token must be provided",
                    )))
                    .into()
                },
            }
        },
    };

    let registrations = match registrations(&session, &catalyst_id).await {
        Ok(v) => v,
        Err(e) => return AllResponses::handle_error(&e),
    };
    match build_rbac_reg(registrations, detailed) {
        Ok(Some(reg)) => {
            Responses::Ok(Json(Box::new(RbacRegistrations {
                catalyst_id: catalyst_id.into(),
                finalized: Some(reg),
                volatile: None,
            })))
            .into()
        },
        Ok(None) => Responses::NotFound.into(),
        Err(e) => AllResponses::handle_error(&e),
    }
}

/// Returns a Catalyst ID for the given stake address.
async fn catalyst_id_from_stake(
    session: &CassandraSession, address: StakeAddress,
) -> anyhow::Result<Option<IdUri>> {
    let mut iter = CatalystIdQuery::execute(session, CatalystIdQueryParams {
        stake_address: address.into(),
    })
    .await
    .context("Failed to query Catalyst ID from stake address {e:?}")?;

    match iter.next().await {
        Some(Ok(v)) => Ok(Some(v.catalyst_id.into())),
        Some(Err(e)) => {
            Err(anyhow!(
                "Failed to query Catalyst ID from stake address {e:?}"
            ))
        },
        None => Ok(None),
    }
}

/// Returns a list of `Cip509` for the given Catalyst ID.
async fn registrations(
    session: &CassandraSession, catalyst_id: &IdUri,
) -> anyhow::Result<Vec<rbac_registration::cardano::cip509::Cip509>> {
    let network = Settings::cardano_network();

    let mut iter = RbacQuery::execute(session, RbacQueryParams {
        catalyst_id: catalyst_id.clone().into(),
    })
    .await?;

    let mut result = Vec::new();
    while let Some(reg) = iter.next().await.transpose()? {
        let point = Point::fuzzy(reg.slot_no.into());
        let block = ChainFollower::get_block(network, point)
            .await
            .context("Unable to get block")?
            .data;
        if block.point().slot_or_default() != reg.slot_no.into() {
            // The `ChainFollower::get_block` function can return the next consecutive block if it
            // cannot find the exact one. This shouldn't happen, but we need to check anyway.
            return Err(anyhow!("Unable to find exact block"));
        }
        let reg =
            rbac_registration::cardano::cip509::Cip509::new(&block, reg.txn_index.into(), &[])
                .context("Invalid RBAC registration")?
                .context("No RBAC registration at this block and txn index")?;
        result.push(reg);
    }
    Ok(result)
}

/// Build a response `RbacRegistration` from the provided CIP 509 registrations lists
fn build_rbac_reg(
    mut regs: Vec<rbac_registration::cardano::cip509::Cip509>, detailed: bool,
) -> anyhow::Result<Option<RbacReg>> {
    // sort registrations in the ascending order from the oldest to the latest
    regs.sort_by(|a, b| {
        let a = a.origin().point();
        let b = b.origin().point();
        a.cmp(b)
    });

    let details: Cip509List = if detailed {
        regs.iter()
            .map(TryInto::try_into)
            .collect::<anyhow::Result<Vec<_>>>()?
            .into()
    } else {
        Vec::new().into()
    };
    let chain = build_chain(regs);
    if details.is_empty() && chain.is_none() {
        return Ok(None);
    }
    Ok(Some(RbacRegistration { chain, details }.into()))
}

/// Try to build a `RegistrationChain` from the provided registration list
fn build_chain(regs: Vec<rbac_registration::cardano::cip509::Cip509>) -> Option<RegChain> {
    let mut regs_iter = regs.into_iter();
    while let Some(try_first) = regs_iter.next() {
        if let Ok(mut chain) =
            rbac_registration::registration::cardano::RegistrationChain::new(try_first)
        {
            for reg in regs_iter {
                let Ok(updated_chain) = chain.update(reg) else {
                    continue;
                };
                chain = updated_chain;
            }
            return Some(chain.into());
        }
        continue;
    }
    None
}
