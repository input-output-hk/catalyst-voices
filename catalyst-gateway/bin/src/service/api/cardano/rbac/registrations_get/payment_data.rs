//! A role payment address information.

use chrono::{DateTime, Utc};
use pallas::ledger::addresses::ShelleyAddress;
use poem_openapi::{types::Example, Object};

use crate::service::common::types::{
    cardano::cip19_shelley_address::Cip19ShelleyAddress,
    generic::{boolean::BooleanFlag, date_time::DateTime as ServiceDateTime},
};

/// A role payment address information.
#[derive(Object, Debug, Clone)]
pub struct PaymentData {
    /// Indicates if the data is persistent or volatile.
    is_persistent: BooleanFlag,
    /// A time when the address was added.
    time: ServiceDateTime,
    /// An option payment address.
    address: Option<Cip19ShelleyAddress>,
}

impl PaymentData {
    /// Creates a new `PaymentData` instance.
    pub fn new(is_persistent: bool, time: DateTime<Utc>, address: Option<ShelleyAddress>) -> Self {
        Self {
            is_persistent: is_persistent.into(),
            time: time.into(),
            address: address.map(|a| a.try_into().ok()).flatten(),
        }
    }
}

impl Example for PaymentData {
    fn example() -> Self {
        Self {
            is_persistent: BooleanFlag::example(),
            time: ServiceDateTime::example(),
            address: Some(Cip19ShelleyAddress::example()),
        }
    }
}
