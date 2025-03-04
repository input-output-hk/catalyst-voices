//! Event types for Chain Indexer.

use cardano_blockchain_types::Slot;

/// Represents various events that can occur in the chain indexer.
/// These events are used to track the state and progress of indexing operations.
#[derive(Debug, Clone)]
pub(crate) enum ChainIndexerEvent {
    /// Event triggered when the synchronization process starts.
    SyncStarted,
    /// Event triggered when the synchronization process completes.
    SyncCompleted,
    /// Event triggered when the number of current synchronization tasks changes.
    SyncTasksChanged {
        /// The current number of synchronization tasks.
        current_sync_tasks: u16,
    },
    /// Event triggered when the live tip slot changes.
    LiveTipSlotChanged {
        /// The new live tip slot.
        slot: Slot,
    },
    /// Event triggered when the immutable tip slot changes.
    ImmutableTipSlotChanged {
        /// The new immutable tip slot.
        slot: Slot,
    },
    /// Event triggered when the indexed slot progresses.
    IndexedSlotProgressed {
        /// The latest indexed slot.
        slot: Slot,
    },
    /// Event triggered when backward data is purged.
    BackwardDataPurged {
        /// The number of purged data entries.
        count: u64,
    },
    /// Event triggered when forward data is purged.
    ForwardDataPurged {
        /// The number of purged data entries.
        count: u64,
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
