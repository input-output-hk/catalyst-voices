//! A role payment address information.

use cardano_chain_follower::pallas_addresses::ShelleyAddress;
use poem_openapi::{Object, types::Example};

use crate::service::common::types::{
    cardano::{cip19_shelley_address::Cip19ShelleyAddress, slot_no::SlotNo, txn_index::TxnIndex},
    generic::{boolean::BooleanFlag, date_time::DateTime},
};

/// A role payment address information.
#[derive(Object, Debug, Clone)]
#[oai(example)]
pub struct PaymentData {
    /// Indicates if the data is persistent or volatile.
    is_persistent: BooleanFlag,
    /// A time when the address was added.
    time: DateTime,
    /// A block slot number.
    slot: SlotNo,
    /// A transaction index.
    txn_index: TxnIndex,
    /// An option payment address.
    address: Option<Cip19ShelleyAddress>,
}

impl PaymentData {
    /// Creates a new `PaymentData` instance.
    pub fn new(
        is_persistent: bool,
        time: DateTime,
        slot: SlotNo,
        txn_index: TxnIndex,
        address: Option<ShelleyAddress>,
    ) -> anyhow::Result<Self> {
        let address = address.map(Cip19ShelleyAddress::try_from).transpose()?;

        Ok(Self {
            is_persistent: is_persistent.into(),
            time,
            slot,
            txn_index,
            address,
        })
    }
}

impl Example for PaymentData {
    fn example() -> Self {
        Self {
            is_persistent: BooleanFlag::example(),
            time: DateTime::example(),
            slot: SlotNo::example(),
            txn_index: TxnIndex::example(),
            address: Some(Cip19ShelleyAddress::example()),
        }
    }
}
