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
    chain_follower::init_metrics_reporter();
    memory::init_metrics_reporter();
    rbac_cache::init_metrics_reporter();

    default_registry().clone()
}

pub(crate) fn metrics_updater_fn() {
    rbac_cache::update();
}
