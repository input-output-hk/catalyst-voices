//! Event types for RBAC Cache Manager.

use std::time::Duration;

/// Represents various events that can occur in the RBAC cache manager.
#[derive(Debug, Clone)]
pub(crate) enum RbacCacheManagerEvent {
    Initialized {
        start_up_time: Duration,
    },
    RbacRegistrationChainAdded {
        is_persistent: bool,
    },
    CacheAccessed {
        latency: Duration,
        is_persistent: bool,
        is_found: bool,
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
    fn add_event_listener(&self, listener: EventListenerFn<T>);

    /// Dispatches an event to all registered listeners.
    ///
    /// # Arguments
    /// * `message` - The event message to be dispatched.
    fn dispatch_event(&self, message: T);
}
