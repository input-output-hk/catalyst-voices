//! A cache of RBAC chains.

use catalyst_types::catalyst_id::CatalystId;
use rbac_registration::registration::cardano::RegistrationChain;

use crate::{
    db::index::session::CassandraSession,
    metrics::rbac::{rbac_persistent_chains_cache_hits_inc, rbac_persistent_chains_cache_miss_inc},
};

/// Add (or update) a persistent chain to the cache.
pub fn cache_persistent_rbac_chain(id: CatalystId, chain: RegistrationChain) {
    CassandraSession::get(true).inspect(|session| {
        session.caches().rbac_persistent_chains().insert(id, chain);
    });
}

/// Returns a cached persistent chain by the given Catalyst ID.
pub fn cached_persistent_rbac_chain(
    session: &CassandraSession, id: &CatalystId,
) -> Option<RegistrationChain> {
    let cache = session.caches().rbac_persistent_chains();
    if !cache.is_enabled() {
        return None;
    }
    cache
        .get(id)
        .inspect(|_| {
            rbac_persistent_chains_cache_hits_inc();
        })
        .or_else(|| {
            rbac_persistent_chains_cache_miss_inc();
            None
        })
}
