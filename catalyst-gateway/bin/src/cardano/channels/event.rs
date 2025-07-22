//! multi-consumer, multi-producer Cardano Chain Indexer Events channel.

use cardano_blockchain_types::Slot;

use super::{dispatch_message, receive_msg};

/// Represents various events that can occur in the chain indexer.
/// These events are used to track the state and progress of indexing operations.
#[derive(Debug, Clone)]
pub(crate) enum ChainIndexerEvent {
    /// Event triggered when the synchronization process of the live chain starts.
    SyncLiveChainStarted,
    /// Event triggered when the synchronization process of the immutable chain starts.
    SyncImmutableChainStarted,
    /// Event triggered when the synchronization process of the live chain completes
    /// (live chain synchronization never stops, this event triggers when first tip is
    /// reached).
    SyncLiveChainCompleted,
    /// Event triggered when the synchronization process of the immutable chain completes.
    SyncImmutableChainCompleted,
    /// Event triggered when the number of current synchronization tasks changes.
    SyncTasksChanged {
        /// The current number of synchronization tasks.
        current_sync_tasks: u16,
    },
    /// Event triggered when the live tip slot changes.
    LiveTipSlotChanged {
        /// The immutable tip slot.
        immutable_slot: Slot,
        /// The new live tip slot.
        live_slot: Slot,
    },
    /// Event triggered when the immutable tip slot changes.
    ImmutableTipSlotChanged {
        /// The new immutable tip slot.
        immutable_slot: Slot,
        /// The live tip slot.
        live_slot: Slot,
    },
    /// Event triggered when the indexed slot progresses.
    IndexedSlotProgressed {
        /// The latest indexed slot.
        slot: Slot,
    },
    /// Event triggered when backward data is purged.
    BackwardDataPurged,
    /// Event triggered when forward data is purged.
    ForwardDataPurged {
        /// Number of purged slots.
        purge_slots: u64,
    },
}

/// `ChainIndexerEvent` sender multi-producer channel
#[derive(Debug, Clone)]
pub(crate) struct ChainIndexerEventSender(tokio::sync::broadcast::Sender<ChainIndexerEvent>);
#[derive(Debug)]
/// `ChainIndexerEvent` receiver multi-consumer channel
pub(crate) struct ChainIndexerEventReceiver(tokio::sync::broadcast::Receiver<ChainIndexerEvent>);

impl ChainIndexerEventSender {
    /// Creates a multi-producer channel for processing
    /// `ChainIndexerEvent` events.
    /// To subscribe on processing events and instantiate `ChainIndexerEventReceiver` call
    /// `subscribe` method of the `ChainIndexerEventSender`
    pub(crate) fn new() -> Self {
        Self(tokio::sync::broadcast::channel(1).0)
    }

    /// Dispatches an event to all registered listeners.
    pub(crate) fn dispatch_event(&self, event: ChainIndexerEvent) {
        dispatch_message(&self.0, event);
    }

    /// Creates a new multi-consumer `ChainIndexerEventReceiver` that will receive values
    /// sent **after** this call to `subscribe`.
    pub(crate) fn subscribe(&self) -> ChainIndexerEventReceiver {
        ChainIndexerEventReceiver(self.0.subscribe())
    }
}

impl ChainIndexerEventReceiver {
    /// Receives the next `ChainIndexerEvent` from the channel.
    /// Return `None` if the channel is closed.
    pub(crate) async fn receive_event(&mut self) -> Option<ChainIndexerEvent> {
        receive_msg(&mut self.0).await
    }
}
