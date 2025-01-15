//! This module contains submodules related to metrics report and analytics.

use prometheus::{default_registry, Registry};

pub(crate) mod chain_follower;
pub(crate) mod chain_indexer;
pub(crate) mod endpoint;
pub(crate) mod memory;

/// Initialize Prometheus metrics.
///
/// ## Returns
///
/// Returns the default prometheus registry.
#[must_use]
pub(crate) fn init_prometheus() -> Registry {
    memory::MemoryMetrics::init_metrics_updater();
 
    default_registry().clone()
}
