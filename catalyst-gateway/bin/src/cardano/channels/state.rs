//! multi-consumer, multi-producer Cardano Chain Indexer State channel.

use super::{dispatch_message, receive_msg};

/// Chain Indexer state sender multi-producer channel
#[derive(Debug, Clone)]
pub(crate) struct ChainIndexerStateSender(tokio::sync::broadcast::Sender<()>);
#[derive(Debug)]
/// Chain Indexer state receiver multi-consumer channel
pub(crate) struct ChainIndexerStateReceiver(tokio::sync::broadcast::Receiver<()>);

impl ChainIndexerStateSender {
    /// Creates a multi-producer channel for processing
    /// Chain Indexer state events.
    /// To subscribe on processing events and instantiate `ChainIndexerStateReceiver` call
    /// `subscribe` method of the `ChainIndexerStateSender`
    pub(crate) fn new() -> Self {
        Self(tokio::sync::broadcast::channel(1).0)
    }

    /// Updates to the latest state to all registered listeners.
    pub(crate) fn update_state(&self, state: ()) {
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
    pub(crate) async fn latest_state(&mut self) -> Option<()> {
        receive_msg(&mut self.0).await
    }
}
