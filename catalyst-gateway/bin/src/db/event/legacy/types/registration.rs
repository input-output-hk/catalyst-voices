//! Registration Types
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, PartialEq, Eq)]
/// Voter Group Id
pub(crate) struct VoterGroupId(pub(crate) String);

#[derive(Debug, Clone, PartialEq)]
/// Voter Info
pub(crate) struct VoterInfo {
    /// Voting power
    pub(crate) voting_power: i64,
    /// Voting group
    pub(crate) voting_group: VoterGroupId,
    /// Delegations power
    pub(crate) delegations_power: i64,
    /// Delegations count
    pub(crate) delegations_count: i64,
    /// Voting power saturation
    pub(crate) voting_power_saturation: f64,
    /// Delegator addresses
    pub(crate) delegator_addresses: Option<Vec<String>>,
}

#[derive(Debug, Clone, PartialEq)]
/// Voter
pub(crate) struct Voter {
    /// Voter info
    pub(crate) info: VoterInfo,
    /// As at
    pub(crate) as_at: DateTime<Utc>,
    /// Last updated
    pub(crate) last_updated: DateTime<Utc>,
    /// Is final
    pub(crate) is_final: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Delegation
pub(crate) struct Delegation {
    /// Voting key
    pub(crate) voting_key: String,
    /// Voting group
    pub(crate) group: VoterGroupId,
    /// Weight
    pub(crate) weight: i32,
    /// Value
    pub(crate) value: i64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Reward Address
pub(crate) struct RewardAddress {
    /// Reward address
    reward_address: String,
    /// Reward payable
    reward_payable: bool,
}

impl RewardAddress {
    /// Mainnet prefix
    const MAINNET_PREFIX: &'static str = "addr";
    /// Testnet prefix
    const TESTNET_PREFIX: &'static str = "addr_test";

    /// validation according [CIP-19](https://github.com/cardano-foundation/CIPs/blob/master/CIP-0019/README.md)
    fn cardano_address_check(address: &str) -> bool {
        address.starts_with(Self::MAINNET_PREFIX) || address.starts_with(Self::TESTNET_PREFIX)
    }

    /// Create a new reward address
    pub(crate) fn new(reward_address: String) -> Self {
        Self {
            reward_payable: Self::cardano_address_check(&reward_address),
            reward_address,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// Delegator
pub(crate) struct Delegator {
    /// Delegations
    pub(crate) delegations: Vec<Delegation>,
    /// Reward address
    pub(crate) reward_address: RewardAddress,
    /// Raw power
    pub(crate) raw_power: i64,
    /// Total power
    pub(crate) total_power: i64,
    /// As at
    pub(crate) as_at: DateTime<Utc>,
    /// Last updated
    pub(crate) last_updated: DateTime<Utc>,
    /// Is final
    pub(crate) is_final: bool,
}
