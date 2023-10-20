use chrono::{DateTime, Utc};

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct VoterGroupId(pub(crate) String);

#[derive(Debug, Clone, PartialEq)]
pub(crate) struct VoterInfo {
    pub(crate) voting_power: i64,
    pub(crate) voting_group: VoterGroupId,
    pub(crate) delegations_power: i64,
    pub(crate) delegations_count: i64,
    pub(crate) voting_power_saturation: f64,
    pub(crate) delegator_addresses: Option<Vec<String>>,
}

#[derive(Debug, Clone, PartialEq)]
pub(crate) struct Voter {
    pub(crate) voter_info: VoterInfo,
    pub(crate) as_at: DateTime<Utc>,
    pub(crate) last_updated: DateTime<Utc>,
    pub(crate) is_final: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Delegation {
    pub(crate) voting_key: String,
    pub(crate) group: VoterGroupId,
    pub(crate) weight: i32,
    pub(crate) value: i64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct RewardAddress {
    reward_address: String,
    reward_payable: bool,
}

impl RewardAddress {
    const MAINNET_PREFIX: &'static str = "addr";
    const TESTNET_PREFIX: &'static str = "addr_test";

    // validation according CIP-19 https://github.com/cardano-foundation/CIPs/blob/master/CIP-0019/README.md
    fn cardano_address_check(address: &str) -> bool {
        address.starts_with(Self::MAINNET_PREFIX) || address.starts_with(Self::TESTNET_PREFIX)
    }

    pub(crate) fn new(reward_address: String) -> Self {
        Self {
            reward_payable: Self::cardano_address_check(&reward_address),
            reward_address,
        }
    }

    pub(crate) fn reward_address(&self) -> &str {
        &self.reward_address
    }

    pub(crate) fn reward_payable(&self) -> bool {
        self.reward_payable
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Delegator {
    pub(crate) delegations: Vec<Delegation>,
    pub(crate) reward_address: RewardAddress,
    pub(crate) raw_power: i64,
    pub(crate) total_power: i64,
    pub(crate) as_at: DateTime<Utc>,
    pub(crate) last_updated: DateTime<Utc>,
    pub(crate) is_final: bool,
}
