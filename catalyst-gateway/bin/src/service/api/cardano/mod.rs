//! Cardano API endpoints

pub(crate) mod cip36;
pub(crate) mod rbac;
pub(crate) mod staking;

/// All Cardano API Endpoints
pub(crate) type CardanoApi = (rbac::Api, staking::Api, cip36::Api);
