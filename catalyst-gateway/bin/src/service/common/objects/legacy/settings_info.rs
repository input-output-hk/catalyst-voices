//! Define the Settings Info

use poem_openapi::Object;

/// The setting info object.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct SettingsInfo {
    /// Block 0 hash.
    #[oai(
        rename = "block0Hash",
        validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]")
    )]
    block_0_hash: String,
    /// Fees detail.
    #[oai]
    fees: Fees,
    /// Slots per epoch.
    #[oai(
        rename = "slotsPerEpoch",
        validator(max_length = 256, min_length = 1, pattern = "[0-9]+")
    )]
    slots_per_epoch: String,
}

/// The fee object.
#[allow(clippy::missing_docs_in_private_items)]
#[allow(clippy::struct_field_names)]
#[derive(Object, Default)]
pub(crate) struct Fees {
    /// Per certificate fees detail.
    per_certificate_fees: PerCertificateFee,
    /// Per vote certificate fees detail.
    per_vote_certificate_fees: PerVoteCertificateFees,
    /// Constant.
    constant: u32,
    /// Coefficient
    coefficient: u32,
    /// Certificate.
    certificate: u32,
}

/// The per-certificate fee object.
#[allow(clippy::missing_docs_in_private_items)]
#[allow(clippy::struct_field_names)]
#[derive(Object, Default)]
pub(crate) struct PerCertificateFee {
    /// Certificate pool registration.
    certificate_pool_registration: u32,
    /// Certificate stake delegation.
    certificate_stake_delegation: u32,
    /// Certificate owner stake delegation.
    certificate_owner_stake_delegation: u32,
}

/// The per-vote certificate fee object.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct PerVoteCertificateFees {
    /// Certificate vote plan.
    certificate_vote_plan: u32,
    /// Certificate vote cast.
    certificate_vote_cast: u32,
}
