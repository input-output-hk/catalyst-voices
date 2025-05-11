//! A cache for RBAC registrations.

// TODO(stanislav-tkach): This can and should be removed as soon as `RBAC_CACHE` is used.
#![allow(dead_code)]

mod add_result;
mod cache;
mod cache_manager;
mod instance;

// TODO: Remove when the cache is used.
#[allow(unused_imports)]
pub use instance::RBAC_CACHE;
