//! A role data.

use std::collections::HashMap;

use poem_openapi::{types::Example, Object};

use crate::service::api::cardano::rbac::registrations_get::{
    key_data::KeyData, payment_data::PaymentData,
};

/// A role data.
#[derive(Object, Debug, Clone)]
pub(crate) struct RbacRoleData {
    #[oai(skip_serializing_if_is_empty)]
    signing_keys: Vec<KeyData>,
    #[oai(skip_serializing_if_is_empty)]
    encryption_keys: Vec<KeyData>,
    #[oai(skip_serializing_if_is_empty)]
    payment_address: Vec<PaymentData>,
    #[oai(skip_serializing_if_is_empty)]
    extended_data: HashMap<u8, Vec<u8>>,
}

impl Example for RbacRoleData {
    fn example() -> Self {
        Self {
            signing_keys: vec![KeyData::example()],
            encryption_keys: vec![],
            payment_address: vec![PaymentData::example()],
            extended_data: Default::default(),
        }
    }
}
