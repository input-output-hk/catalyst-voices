//! These types are specifically and only used for Query Parameters
//!
//! They exist due to limitations in the expressiveness of Query parameter constraints in
//! `OpenAPI`

pub(crate) mod as_at;
pub(crate) mod stake_or_voter;

pub(crate) use as_at::AsAt;
