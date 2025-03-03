use cardano_blockchain_types::Slot;

#[derive(Debug, Clone)]
pub(crate) enum ChainIndexerEvent {
    SyncTasksChanged { current_sync_tasks: u16 },
    LiveTipSlotChanged { slot: Slot },
    ImmutableTipSlotChanged { slot: Slot },
    IndexedSlotChanged { slot: Slot },
    LiveDataPurged { count: u64 },
}

pub(crate) trait EventTarget<T> {
    fn add_event_listener(&mut self, listener: fn(message: &T));
    fn dispatch_event(&self, message: T);
}
