//! Cardano Specific Types
//!
//! These are temporary types are needed to prevent breakage due to the removal of the
//! Event DB logic for chain-sync.  They should be replaced with proper types in a better
//! place.

use crate::cardano::cip36_registration::VotingInfo;

/// Block time
pub(crate) type DateTime = chrono::DateTime<chrono::offset::Utc>;
/// Slot
pub(crate) type SlotNumber = i64;
/// Transaction id
#[allow(dead_code)]
pub(crate) type TxId = Vec<u8>;
/// Stake credential
#[allow(dead_code)]
pub(crate) type StakeCredential = Vec<u8>;
/// Public voting key
#[allow(dead_code)]
pub(crate) type PublicVotingInfo = VotingInfo;
/// Payment address
#[allow(dead_code)]
pub(crate) type PaymentAddress = Vec<u8>;
/// Nonce
pub(crate) type Nonce = i64;
/// Metadata 61284
#[allow(dead_code)]
pub(crate) type MetadataCip36 = Vec<u8>;
/// Stake amount.
pub(crate) type StakeAmount = i64;
