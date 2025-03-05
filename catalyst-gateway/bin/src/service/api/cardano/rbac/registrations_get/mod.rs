//! Implementation of the GET `/rbac/registrations` endpoint.

mod cip509;
mod rbac_reg;
mod reg_chain;
mod unprocessable_content;

use catalyst_types::id_uri::IdUri;
use cip509::Cip509List;
use poem_openapi::{payload::Json, ApiResponse};
use rbac_reg::{RbacRegistration, RbacRegistrations};
use reg_chain::RegistrationChain;
use tracing::error;
use unprocessable_content::RbacUnprocessableContent;

use crate::{
    db::index::session::CassandraSession,
    service::common::{
        responses::WithErrorResponses,
        types::{
            cardano::query::cat_id_or_stake::CatIdOrStake, headers::retry_after::RetryAfterOption,
        },
    },
};

/// Endpoint responses.
#[derive(ApiResponse)]
#[allow(dead_code)]
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
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint(
    lookup: Option<CatIdOrStake>, auth_catalyst_id: Option<IdUri>, _detailed: bool,
) -> AllResponses {
    let Some(_session) = CassandraSession::get(true) else {
        error!("Failed to acquire db session");
        let err = anyhow::anyhow!("Failed to acquire db session");
        return AllResponses::service_unavailable(&err, RetryAfterOption::Default);
    };

    if let Some(_lookup) = lookup {}
    if let Some(_auth_catalyst_id) = auth_catalyst_id {}

    Responses::NotFound.into()
}

/// Build a response `RbacRegistration` from the provided CIP 509 registrations lists
#[allow(dead_code)]
pub(crate) fn build_rbac_reg(
    mut regs: Vec<rbac_registration::cardano::cip509::Cip509>, detailed: bool,
) -> anyhow::Result<Option<RbacRegistration>> {
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
    Ok(Some(RbacRegistration { chain, details }))
}

/// Try to build a `RegistrationChain` from the provided registration list
pub(crate) fn build_chain(
    regs: Vec<rbac_registration::cardano::cip509::Cip509>,
) -> Option<RegistrationChain> {
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
