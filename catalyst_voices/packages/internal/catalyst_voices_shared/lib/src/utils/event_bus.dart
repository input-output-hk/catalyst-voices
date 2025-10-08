import 'dart:async';

/// A simple event bus for decoupled communication between components.
///
/// The event bus allows one part of an application to dispatch an event,
/// and another part to listen for that event, without either having a
/// direct reference to the other.
base class EventBus<T> {
  /// The private broadcast StreamController that powers the event bus.
  final StreamController<T> _sc;

  /// Creates an instance of the [EventBus].
  ///
  /// By default, the underlying stream is asynchronous.
  EventBus({bool sync = false}) : _sc = StreamController.broadcast(sync: sync);

  /// Dispatches an [event] to all listeners.
  void dispatch(T event) {
    _sc.add(event);
  }

  /// Closes the event bus stream.
  Future<void> dispose() => _sc.close();

  /// Returns a stream for a specific event type `E`.
  ///
  /// This is the primary method for listening to events. It filters the main
  /// event stream to only include events that are of type `E`.
  Stream<E> on<E extends T>() {
    return _sc.stream.where((T event) => event is E).cast<E>();
  }
}
