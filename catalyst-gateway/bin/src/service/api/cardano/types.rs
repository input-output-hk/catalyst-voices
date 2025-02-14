//! Cardano Specific Types
//!
//! These are temporary types are needed to prevent breakage due to the removal of the
//! Event DB logic for chain-sync.  They should be replaced with proper types in a better
//! place.

use serde::{Deserialize, Serialize};

/// Pub key
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub(crate) struct PubKey(Vec<u8>);

impl PubKey {
    /// Get bytes
    pub(crate) fn bytes(&self) -> &[u8] {
        &self.0
    }
}

/// The source of voting power for a given registration
///
/// The voting power can either come from:
///  - a single wallet, OR
///  - a set of delegations
#[derive(Serialize, Deserialize)]
#[serde(untagged)]
#[derive(Debug, Clone, PartialEq)]
pub(crate) enum VotingInfo {
    /// Direct voting
    ///
    /// Voting power is based on the staked ada of the given key
    Direct(PubKey),

    /// Delegated voting
    ///
    /// Voting power is based on the staked ada of the delegated keys
    /// order of elements is important and must be preserved.
    Delegated(Vec<(PubKey, i64)>),
}

/// Block time
pub(crate) type DateTime = chrono::DateTime<chrono::offset::Utc>;
/// Transaction id
pub(crate) type TxId = Vec<u8>;
/// Public voting key
pub(crate) type PublicVotingInfo = VotingInfo;
/// Payment address
pub(crate) type PaymentAddress = Vec<u8>;
/// Stake amount.
pub(crate) type StakeAmount = i64;
