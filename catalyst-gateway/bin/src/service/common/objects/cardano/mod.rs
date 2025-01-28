//! Defines API schemas of Cardano Objects.
//!
//! These Objects MUST be used in multiple places for multiple things to be considered
//! common. They should not be simple types. but actual objects.
//! Simple types belong in `common/types`.

pub(crate) mod hash;
pub(crate) mod registration_info;
pub(crate) mod slot_info;
pub(crate) mod stake_info;
pub(crate) mod sync_state;
