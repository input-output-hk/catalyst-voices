#[derive(Debug, Clone)]
pub(crate) enum ChainIndexerEvent {
    SyncTasksCountUpdated {
      current_sync_tasks: u16
    },
}

pub(crate) trait EventTarget<T> {
  fn add_event_listener(listener: fn(message: T));
  fn remove_event_listener(listener: fn(message: T));
}
