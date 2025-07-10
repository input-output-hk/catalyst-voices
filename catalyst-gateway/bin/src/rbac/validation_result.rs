//! Types related to validation of new RBAC registrations.

use std::collections::HashSet;

use cardano_blockchain_types::StakeAddress;
use catalyst_types::{catalyst_id::CatalystId, problem_report::ProblemReport, uuid::UuidV4};

/// A return value of the `validate_rbac_registration` method.
pub type RbacValidationResult = Result<RbacValidationSuccess, RbacValidationError>;

/// A value returned from the `validate_rbac_registration` on happy path.
///
/// It is used to insert a registration data to the `rbac_registration` table.
pub type RbacValidationSuccess = Vec<RbacUpdate>;

/// An update to RBAC registration chain.
pub struct RbacUpdate {
    /// A Catalyst ID.
    pub catalyst_id: CatalystId,
    /// A list of removed stake addresses.
    ///
    /// If this list is empty, then a chain with this Catalyst ID was updated by a new
    /// transaction. If the list is non-empty, then a transaction to another RBAC chain
    /// take ownership of the listed addressed removing them from this chain.
    pub removed_stake_addresses: HashSet<StakeAddress>,
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
    ///
    /// This can happen if a previous transaction ID in the registration is incorrect.
    UnknownCatalystId,
    /// A different error occurred during validation.
    ///
    /// This error isn't processed specifically and is just logged.
    Other(anyhow::Error),
}

impl From<anyhow::Error> for RbacValidationError {
    fn from(e: anyhow::Error) -> Self {
        RbacValidationError::Other(e)
    }
}
