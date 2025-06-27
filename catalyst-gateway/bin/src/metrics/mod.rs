//! This module contains submodules related to metrics report and analytics.

use prometheus::{default_registry, Registry};

pub(crate) mod chain_follower;
pub(crate) mod chain_indexer;
pub(crate) mod endpoint;
pub(crate) mod memory;
pub(crate) mod rbac_cache;

/// Initialize Prometheus metrics.
///
/// ## Returns
///
/// Returns the default prometheus registry.
#[must_use]
pub(crate) fn init_prometheus() -> Registry {
    default_registry().clone()
}

/// Updates metrics to current values.
pub(crate) fn metrics_updater_fn() {
    chain_follower::update();
    memory::update();
    rbac_cache::update();
}
