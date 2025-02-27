#[derive(Debug, Clone)]
pub(crate) enum ChainIndexerEvent {
    SyncTasksCountUpdated { current_sync_tasks: u16 },
}

pub(crate) trait EventTarget<T> {
    fn add_event_listener(&mut self, listener: fn(message: &T));
    fn dispatch_event(&self, message: T);
}
