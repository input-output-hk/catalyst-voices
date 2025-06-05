//! A cache for RBAC registrations.

mod add_result;
mod cache;
mod cache_manager;
mod instance;

pub use add_result::{RbacCacheAddError, RbacCacheAddSuccess};
pub use instance::RBAC_CACHE;
