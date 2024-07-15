//! Defines the allowable groups for a Voter
use poem_openapi::{types::Example, Enum};

/// Voter Group ID.
#[derive(Enum)]
pub(crate) enum VoterGroupId {
    /// Delegated Representative.
    #[oai(rename = "rep")]
    Rep,

    /// Direct voter.
    #[oai(rename = "direct")]
    Direct,
}

impl Example for VoterGroupId {
    fn example() -> Self {
        Self::Rep
    }
}

impl TryFrom<crate::db::event::legacy::types::registration::VoterGroupId> for VoterGroupId {
    type Error = String;

    fn try_from(
        value: crate::db::event::legacy::types::registration::VoterGroupId,
    ) -> Result<Self, Self::Error> {
        match value.0.as_str() {
            "rep" => Ok(Self::Rep),
            "direct" => Ok(Self::Direct),
            value => Err(format!("Unknown VoterGroupId: {value}")),
        }
    }
}
