//! Implementation of the GET `/rbac/registrations` endpoint.

pub use response::AllResponses;

mod binary_data;
mod chain_info;
mod extended_data;
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

use cardano_blockchain_types::StakeAddress;
use poem_openapi::payload::Json;

use crate::{
    rbac_cache::RBAC_CACHE,
    service::{
        api::cardano::rbac::registrations_get::{
            chain_info::ChainInfo, registration_chain::RbacRegistrationChain, response::Responses,
            unprocessable_content::RbacUnprocessableContent,
        },
        common::{
            auth::rbac::token::CatalystRBACTokenV1,
            types::cardano::query::cat_id_or_stake::CatIdOrStake,
        },
    },
};

/// Get RBAC registration endpoint.
pub(crate) fn endpoint(
    lookup: Option<CatIdOrStake>, token: Option<CatalystRBACTokenV1>,
) -> AllResponses {
    let (persistent_chain, volatile_chain) = match lookup {
        Some(CatIdOrStake::CatId(id)) => {
            let id = id.into();
            (RBAC_CACHE.get(&id, true), RBAC_CACHE.get(&id, false))
        },
        Some(CatIdOrStake::Address(address)) => {
            let address: StakeAddress = match address.try_into() {
                Ok(a) => a,
                Err(e) => return AllResponses::handle_error(&e),
            };
            (
                RBAC_CACHE.get_by_address(&address, true),
                RBAC_CACHE.get_by_address(&address, false),
            )
        },
        None => {
            match token {
                Some(token) => {
                    (
                        RBAC_CACHE.get(token.catalyst_id(), true),
                        RBAC_CACHE.get(token.catalyst_id(), false),
                    )
                },
                None => {
                    return Responses::UnprocessableContent(Json(RbacUnprocessableContent::new(
                        "Either lookup parameter or token must be provided",
                    )))
                    .into()
                },
            }
        },
    };

    match ChainInfo::new(persistent_chain, volatile_chain) {
        Some(info) => {
            match RbacRegistrationChain::new(&info) {
                Ok(c) => Responses::Ok(Json(Box::new(c))).into(),
                Err(e) => AllResponses::handle_error(&e),
            }
        },
        None => Responses::NotFound.into(),
    }
}
