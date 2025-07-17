//! multi-consumer, multi-producer Cardano Chain Indexer State channel.

use std::ops::Sub;

use cardano_blockchain_types::Slot;

use super::{dispatch_message, receive_msg};
use crate::cardano::indexed_status::IndexedStatus;

/// Chain Indexer State structure
#[derive(Debug, Clone)]
#[allow(dead_code)]
pub(crate) struct ChainIndexerState {
    /// The immutable tip slot.
    pub immutable_tip_slot: Slot,

    /// Current Immutable db status of indexed data.
    pub immutable_indexed_status: IndexedStatus,
}

impl ChainIndexerState {
    /// Returns true if the Chain indexer reached immutable tip, so the all immutable data
    /// if fully is indexed. False otherwise.
    pub(crate) fn is_reached_immutable_tip(&self) -> bool {
        // If the immutable part is fully indexed it must be only a one chunk
        if let Some((_, end)) = self.immutable_indexed_status.first() {
            end == &self.immutable_tip_slot && self.immutable_indexed_status.len() == 1
        } else {
            false
        }
    }

    /// Returns true of the immutable part is fully consecutive indexed up to the
    /// provided slot.
    pub(crate) fn is_immutable_fully_indexed_up_to(&self, slot: Slot) -> bool {
        // Looking into the first chunk, which represents a definetly consecutive indexed
        // chunk of blocks.
        if let Some((start, end)) = self.immutable_indexed_status.first() {
            let slot = slot.sub(1.into());
            start <= &slot && &slot <= end
        } else {
            false
        }
    }
}

/// Chain Indexer state sender multi-producer channel
#[derive(Debug, Clone)]
pub(crate) struct ChainIndexerStateSender(tokio::sync::broadcast::Sender<ChainIndexerState>);
#[derive(Debug)]
/// Chain Indexer state receiver multi-consumer channel
pub(crate) struct ChainIndexerStateReceiver(tokio::sync::broadcast::Receiver<ChainIndexerState>);

impl ChainIndexerStateSender {
    /// Creates a multi-producer channel for processing
    /// Chain Indexer state events.
    /// To subscribe on processing events and instantiate `ChainIndexerStateReceiver` call
    /// `subscribe` method of the `ChainIndexerStateSender`
    pub(crate) fn new() -> Self {
        Self(tokio::sync::broadcast::channel(1).0)
    }

    /// Dispatches the latest state to all registered listeners.
    pub(crate) fn dispatch_state(&self, state: ChainIndexerState) {
        dispatch_message(&self.0, state);
    }

    /// Creates a new multi-consumer `ChainIndexerStateReceiver` that will receive values
    /// sent **after** this call to `subscribe`.
    pub(crate) fn subscribe(&self) -> ChainIndexerStateReceiver {
        ChainIndexerStateReceiver(self.0.subscribe())
    }
}

impl ChainIndexerStateReceiver {
    /// Receives the latest Chain Indexer state from the channel.
    /// Return `None` if the channel is closed.
    pub(crate) async fn latest_state(&mut self) -> Option<ChainIndexerState> {
        receive_msg(&mut self.0).await
    }
}
