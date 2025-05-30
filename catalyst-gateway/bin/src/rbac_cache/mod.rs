//! A cache for RBAC registrations.

// TODO(stanislav-tkach): This can and should be removed as soon as `RBAC_CACHE` is used.
#![allow(dead_code)]

mod add_result;
mod cache;
mod cache_manager;
mod instance;

pub use add_result::{RbacCacheAddError, RbacCacheAddSuccess};
pub use instance::RBAC_CACHE;
