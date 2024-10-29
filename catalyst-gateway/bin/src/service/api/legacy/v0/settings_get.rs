//! Implementation of the GET /setting endpoint
use poem_openapi::{payload::Json, ApiResponse};

use crate::service::common::responses::WithErrorResponses;

/// Endpoint responses
#[derive(ApiResponse)]
pub(crate) enum Responses {
    /// The default success resposne.
    #[oai(status = 200)]
    Ok(Json<dto::SettingsDto>),
}

/// All responses
pub(crate) type AllResponses = WithErrorResponses<Responses>;

/// The service endpoint
#[allow(clippy::unused_async)]
pub(crate) async fn endpoint() -> AllResponses {
    Responses::Ok(Json(dto::SettingsDto::default())).into()
}

/// The data transfer objects over HTTP
pub(crate) mod dto {
    use poem_openapi::Object;

    #[allow(clippy::missing_docs_in_private_items)]
    #[derive(Object, Default)]
    pub(crate) struct SettingsDto {
        #[oai(
            rename = "block0Hash",
            validator(max_length = 66, min_length = 0, pattern = "[0-9a-f]")
        )]
        block_0_hash: String,
        #[oai]
        fees: Fees,
        #[oai(
            rename = "slotsPerEpoch",
            validator(min_length = 1, pattern = "[0-9]+")
        )]
        slots_per_epoch: String,
    }

    #[allow(clippy::missing_docs_in_private_items)]
    #[allow(clippy::struct_field_names)]
    #[derive(Object, Default)]
    pub(crate) struct Fees {
        per_certificate_fees: PerCertificateFee,
        per_vote_certificate_fees: PerVoteCertificateFees,
        constant: u32,
        coefficient: u32,
        certificate: u32,
    }

    #[allow(clippy::missing_docs_in_private_items)]
    #[allow(clippy::struct_field_names)]
    #[derive(Object, Default)]
    pub(crate) struct PerCertificateFee {
        certificate_pool_registration: u32,
        certificate_stake_delegation: u32,
        certificate_owner_stake_delegation: u32,
    }

    #[allow(clippy::missing_docs_in_private_items)]
    #[derive(Object, Default)]
    pub(crate) struct PerVoteCertificateFees {
        certificate_vote_plan: u32,
        certificate_vote_cast: u32,
    }
}
