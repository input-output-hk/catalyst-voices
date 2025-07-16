//! Metrics for Cache-related metrics.

pub(crate) mod native_assets;
pub(crate) mod txo_assets;

/// Update Cache metrics
pub(crate) fn update() {
    native_assets::update();
    txo_assets::update();
}
