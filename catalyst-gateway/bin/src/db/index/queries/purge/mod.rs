//! Queries for purging volatile data.

pub(crate) mod catalyst_id_for_stake_address;
pub(crate) mod catalyst_id_for_txn_id;
pub(crate) mod cip36_registration;
pub(crate) mod cip36_registration_for_vote_key;
pub(crate) mod cip36_registration_invalid;
pub(crate) mod rbac509_invalid_registration;
pub(crate) mod rbac509_registration;
pub(crate) mod stake_registration;
pub(crate) mod txi_by_hash;
pub(crate) mod txo_ada;
pub(crate) mod txo_assets;
pub(crate) mod unstaked_txo_ada;
pub(crate) mod unstaked_txo_assets;
