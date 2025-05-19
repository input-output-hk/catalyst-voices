//! Event types for RBAC Cache Manager.

/// Represents various events that can occur in the RBAC cache manager.
#[derive(Debug, Clone)]
pub(crate) enum RbacCacheManagerEvent {
  Initialized,
  CacheAccessed
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
