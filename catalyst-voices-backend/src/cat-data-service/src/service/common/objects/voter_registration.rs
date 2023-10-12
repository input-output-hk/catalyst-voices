//! Define information about the Voters Registration.
use super::voter_info::VoterInfo;
use chrono::{DateTime, Utc};
use poem_openapi::{types::Example, Object};

/// Voter's registration info.
#[derive(Object)]
#[oai(example = true)]
pub(crate) struct VoterRegistration {
    voter_info: VoterInfo,

    /// Date and time the latest snapshot represents.
    as_at: DateTime<Utc>,

    /// Date and time for the latest update to this snapshot information.
    last_updated: DateTime<Utc>,

    /// `True` - this is the final snapshot which will be used for voting power in the event.
    /// `False` - this is an interim snapshot, subject to change.
    #[oai(rename = "final")]
    is_final: bool,
}

impl Example for VoterRegistration {
    fn example() -> Self {
        Self {
            voter_info: VoterInfo::example(),
            as_at: Utc::now(),
            last_updated: Utc::now(),
            is_final: true,
        }
    }
}

impl TryFrom<event_db::types::registration::Voter> for VoterRegistration {
    type Error = String;
    fn try_from(value: event_db::types::registration::Voter) -> Result<Self, Self::Error> {
        Ok(Self {
            voter_info: value.voter_info.try_into()?,
            as_at: value.as_at,
            last_updated: value.last_updated,
            is_final: value.is_final,
        })
    }
}
