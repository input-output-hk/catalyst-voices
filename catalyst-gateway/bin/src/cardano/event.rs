//! Event types for Chain Indexer.

use cardano_blockchain_types::Slot;

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

pub(crate) type EventListenerFn<T> = Box<dyn Fn(&T) + Send + Sync + 'static>;

/// A trait that allows adding and dispatching events to listeners.
pub(crate) trait EventTarget<T: Send + Sync> {
    /// Adds an event listener to the target.
    ///
    /// # Arguments
    /// * `listener` - A function that will be called whenever an event of type `T`
    ///   occurs.
    fn add_event_listener(&mut self, listener: EventListenerFn<T>);

    /// Dispatches an event to all registered listeners.
    ///
    /// # Arguments
    /// * `message` - The event message to be dispatched.
    fn dispatch_event(&self, message: T);
}
