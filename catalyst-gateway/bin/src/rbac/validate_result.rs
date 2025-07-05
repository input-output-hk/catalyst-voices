//! Types related to validation of new RBAC registrations.

use catalyst_types::{catalyst_id::CatalystId, problem_report::ProblemReport, uuid::UuidV4};

/// A return value of the `validate_rbac_registration` method.
pub type RbacValidationResult = Result<RbacValidationSuccess, RbacValidationError>;

/// A value returned from the `validate_rbac_registration` on happy path.
///
/// It is used to insert a registration data to the `rbac_registration` table.
pub struct RbacValidationSuccess {
    /// A Catalyst ID.
    pub catalyst_id: CatalystId,
}

/// An error returned from the `validate_rbac_registration` method.
#[allow(clippy::large_enum_variant)]
pub enum RbacValidationError {
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
