//! Simple Cardano Types not defined by Pallas
//!
//! Note: We should not redefine types already defined by Pallas, but use those types.

use pallas_crypto::hash::Hash;

/// Transaction Hash - Blake2b-256 Hash of a transaction
pub(crate) type TransactionHash = Hash<32>;

/// Public Key Hash - Raw Blake2b-224 Hash of a Ed25519 Public Key (Has no discriminator, just the hash)
pub(crate) type PubKeyHash = Hash<28>;

/// RBAC Role0 KID - Raw Blake2b-128 Hash of a RBAC Role0
pub(crate) type Role0Kid = Hash<16>;
