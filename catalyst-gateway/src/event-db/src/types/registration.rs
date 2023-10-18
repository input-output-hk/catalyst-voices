use chrono::{DateTime, Utc};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct VoterGroupId(pub String);

#[derive(Debug, Clone, PartialEq)]
pub struct VoterInfo {
    pub voting_power: i64,
    pub voting_group: VoterGroupId,
    pub delegations_power: i64,
    pub delegations_count: i64,
    pub voting_power_saturation: f64,
    pub delegator_addresses: Option<Vec<String>>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct Voter {
    pub voter_info: VoterInfo,
    pub as_at: DateTime<Utc>,
    pub last_updated: DateTime<Utc>,
    pub is_final: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Delegation {
    pub voting_key: String,
    pub group: VoterGroupId,
    pub weight: i32,
    pub value: i64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RewardAddress {
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

    pub fn new(reward_address: String) -> Self {
        Self {
            reward_payable: Self::cardano_address_check(&reward_address),
            reward_address,
        }
    }

    pub fn reward_address(&self) -> &str {
        &self.reward_address
    }

    pub fn reward_payable(&self) -> bool {
        self.reward_payable
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Delegator {
    pub delegations: Vec<Delegation>,
    pub reward_address: RewardAddress,
    pub raw_power: i64,
    pub total_power: i64,
    pub as_at: DateTime<Utc>,
    pub last_updated: DateTime<Utc>,
    pub is_final: bool,
}
