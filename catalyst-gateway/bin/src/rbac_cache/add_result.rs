//! Types related to the `RbacCache::add` method.

use catalyst_types::{catalyst_id::CatalystId, problem_report::ProblemReport, uuid::UuidV4};

/// A return value of the `RbacCache::add` method.
pub type AddResult = Result<RbacCacheAddSuccess, RbacCacheAddError>;

/// A value returned from the `RbacCache::add` on happy path.
///
/// It is used to insert a registration data to the `rbac_registration` table.
pub struct RbacCacheAddSuccess {
    /// A Catalyst ID.
    pub catalyst_id: CatalystId,
    /// A registration purpose.
    pub purpose: UuidV4,
}

/// An error returned from the `RbacCache::add` method.
///
/// It is used to insert a registration data to the `rbac_invalid_registration` table.
pub struct RbacCacheAddError {
    /// A Catalyst ID.
    pub catalyst_id: Option<CatalystId>,
    /// A registration purpose.
    pub purpose: Option<UuidV4>,
    /// A problem report.
    pub report: ProblemReport,
}
