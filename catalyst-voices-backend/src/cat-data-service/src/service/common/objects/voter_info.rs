//! Define individual Voter Information
//!
use super::{delegate_public_key::DelegatePublicKey, voter_group_id::VoterGroupId};
use poem_openapi::{types::Example, Object};

/// Voter Info
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct VoterInfo {
    /// Voter's voting power.
    /// This is the true voting power, subject to minimum voting power and max cap.
    #[oai(validator(minimum(value = "0")))]
    voting_power: i64,

    voting_group: VoterGroupId,

    /// Total voting power delegated to this voter.
    /// This is not capped and not subject to minimum voting power.
    #[oai(validator(minimum(value = "0")))]
    delegations_power: i64,

    /// Number of registration which delegated to this voter.
    #[oai(validator(minimum(value = "0")))]
    delegations_count: i64,

    /// Voting power's share of the total voting power.
    /// Can be used to gauge potential voting power saturation.
    /// This value is NOT saturated however, and gives the raw share of total registered voting power.
    #[oai(validator(minimum(value = "0"), maximum(value = "100")))]
    voting_power_saturation: f64,

    /// List of stake public key addresses which delegated to this voting key.
    #[oai(skip_serializing_if_is_none = true)]
    delegator_addresses: Option<Vec<DelegatePublicKey>>,
}

impl Example for VoterInfo {
    fn example() -> Self {
        Self {
            voting_power: 0,
            voting_group: VoterGroupId::example(),
            delegations_power: 0,
            delegations_count: 0,
            voting_power_saturation: 0.0,
            delegator_addresses: Some(vec![DelegatePublicKey::example()]),
        }
    }
}

impl TryFrom<event_db::types::registration::VoterInfo> for VoterInfo {
    type Error = String;
    fn try_from(value: event_db::types::registration::VoterInfo) -> Result<Self, Self::Error> {
        Ok(Self {
            voting_power: value.voting_power,
            voting_group: value.voting_group.try_into()?,
            delegations_power: value.delegations_power,
            delegations_count: value.delegations_count,
            voting_power_saturation: value.voting_power_saturation,
            delegator_addresses: value
                .delegator_addresses
                .map(|val| val.into_iter().map(Into::into).collect()),
        })
    }
}
