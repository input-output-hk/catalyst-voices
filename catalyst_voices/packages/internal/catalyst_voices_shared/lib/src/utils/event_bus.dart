import 'dart:async';

/// A simple event bus for decoupled communication between components.
///
/// The event bus allows one part of an application to dispatch an event,
/// and another part to listen for that event, without either having a
/// direct reference to the other.
final class EventBus {
  /// The private broadcast StreamController that powers the event bus.
  final StreamController<Object> _sc;

  /// Creates an instance of the [EventBus].
  ///
  /// By default, the underlying stream is asynchronous.
  EventBus({bool sync = false}) : _sc = StreamController.broadcast(sync: sync);

  /// Dispatches an [event] to all listeners.
  void dispatch(Object event) {
    _sc.add(event);
  }

  /// Closes the event bus stream.
  Future<void> dispose() => _sc.close();

  /// Returns a stream for a specific event type [T].
  ///
  /// This is the primary method for listening to events. It filters the main
  /// event stream to only include events that are of type [T].
  Stream<T> on<T>() {
    if (T == dynamic) {
      return _sc.stream as Stream<T>;
    } else {
      return _sc.stream.where((event) => event is T).cast<T>();
    }
  }
}
