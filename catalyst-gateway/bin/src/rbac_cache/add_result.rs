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
}

/// An error returned from the `RbacCache::add` method.
#[allow(clippy::large_enum_variant)]
pub enum RbacCacheAddError {
    /// A registration is invalid (`report.is_problematic()` returns `true`).
    ///
    /// This variant is inserted to the `rbac_invalid_registration` table.
    InvalidRegistration {
        /// A Catalyst ID.
        catalyst_id: CatalystId,
        /// A registration purpose.
        purpose: Option<UuidV4>,
        /// A problem report.
        report: ProblemReport,
    },
    /// Unable to determine a Catalyst ID of the registration.
    UnknownCatalystId,
}
