//! Define the Settings Info

use poem_openapi::Object;

/// The setting info object.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct SettingsInfo {
    #[oai(
        rename = "block0Hash",
        validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]")
    )]
    block_0_hash: String,
    #[oai]
    fees: Fees,
    #[oai(
        rename = "slotsPerEpoch",
        validator(max_length = 256, min_length = 1, pattern = "[0-9]+")
    )]
    slots_per_epoch: String,
}

/// The fee information object.
#[allow(clippy::missing_docs_in_private_items)]
#[allow(clippy::struct_field_names)]
#[derive(Object, Default)]
pub(crate) struct Fees {
    #[oai]
    per_certificate_fees: PerCertificateFee,
    #[oai]
    per_vote_certificate_fees: PerVoteCertificateFees,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    constant: u32,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    coefficient: u32,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    certificate: u32,
}

/// The per-certificate fee object.
#[allow(clippy::missing_docs_in_private_items)]
#[allow(clippy::struct_field_names)]
#[derive(Object, Default)]
pub(crate) struct PerCertificateFee {
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    certificate_pool_registration: u32,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    certificate_stake_delegation: u32,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    certificate_owner_stake_delegation: u32,
}

/// The per-vote certificate fee object.
#[allow(clippy::missing_docs_in_private_items)]
#[derive(Object, Default)]
pub(crate) struct PerVoteCertificateFees {
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    certificate_vote_plan: u32,
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    certificate_vote_cast: u32,
}
