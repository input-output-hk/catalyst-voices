//! Utilities for obtaining a RBAC registration chain (`RegistrationChain`).

use anyhow::Result;
use cardano_blockchain_types::StakeAddress;
use catalyst_types::catalyst_id::CatalystId;
use rbac_registration::registration::cardano::RegistrationChain;

use crate::db::index::queries::rbac::get_catalyst_id_from_stake_address::Query as CatalystIdQuery;

/// Returns a registration chain by the given Catalyst ID.
pub async fn rbac_chain(id: &CatalystId) -> Result<Option<RegistrationChain>> {
    //
}

/// Returns a registration chain by the given stake address.
pub async fn rbac_chain_by_address(address: &StakeAddress) -> Result<Option<RegistrationChain>> {
    CatalystIdQuery::latest()
    // let
}

// TODO: FIXME:
// rbac_chain_latest + rbac_chain_persistent?
