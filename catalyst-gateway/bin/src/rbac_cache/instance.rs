//! An instance of RBAC cache manager.

use std::sync::LazyLock;

use crate::rbac_cache::cache_manager::RbacCacheManager;

/// An instance of RBAC cache manager.
pub static RBAC_CACHE: LazyLock<RbacCacheManager> = LazyLock::new(RbacCacheManager::new);
