//! Legacy endpoints

pub(crate) use registration::RegistrationApi;
pub(crate) use v0::V0Api;
pub(crate) use v1::V1Api;

mod registration;
mod v0;
mod v1;

/// Legacy endpoints API
pub(crate) type LegacyApi = (RegistrationApi, V0Api, V1Api);
