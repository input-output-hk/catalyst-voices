//! A cache for RBAC registrations.

// The whole module will be eventually removed anyway.
#![allow(dead_code)]

mod add_result;
mod cache;
mod cache_manager;
pub mod event;
mod instance;

pub use add_result::{RbacCacheAddError, RbacCacheAddSuccess};
pub use instance::RBAC_CACHE;
