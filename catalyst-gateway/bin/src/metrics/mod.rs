//! This module contains submodules related to metrics report and analytics.

use prometheus::{default_registry, Registry};

pub(crate) mod caches;
pub(crate) mod chain_follower;
pub(crate) mod chain_indexer;
pub(crate) mod endpoint;
pub(crate) mod health;
pub(crate) mod memory;
pub(crate) mod rbac;

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
pub(crate) async fn metrics_updater_fn() {
    chain_follower::update();
    memory::update();
    health::update().await;
    caches::update();
    rbac::update();
}
