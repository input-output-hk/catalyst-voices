//! Types related to validation of new RBAC registrations.

use std::collections::HashSet;

use cardano_blockchain_types::StakeAddress;
use catalyst_types::{catalyst_id::CatalystId, problem_report::ProblemReport, uuid::UuidV4};
use ed25519_dalek::VerifyingKey;

/// A return value of the `validate_rbac_registration` method.
pub type RbacValidationResult = Result<RbacValidationSuccess, RbacValidationError>;

/// A value returned from the `validate_rbac_registration` on happy path.
///
/// It contains information for updating `rbac_registration`,
/// `catalyst_id_for_public_key`, `catalyst_id_for_stake_address` and
/// `catalyst_id_for_txn_id` tables.
pub struct RbacValidationSuccess {
    /// A Catalyst ID of the chain this registration belongs to.
    pub catalyst_id: CatalystId,
    /// A list of stake addresses that were added to the chain.
    pub stake_addresses: HashSet<StakeAddress>,
    /// A list of role public keys used in this registration.
    pub public_keys: HashSet<VerifyingKey>,
    /// A list of updates to other chains containing Catalyst IDs and removed stake
    /// addresses.
    ///
    /// A new RBAC registration can take ownership of stake addresses of other chains.
    pub modified_chains: Vec<(CatalystId, HashSet<StakeAddress>)>,
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
