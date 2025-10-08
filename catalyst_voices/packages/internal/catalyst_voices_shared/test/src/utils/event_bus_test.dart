import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:test/test.dart';

void main() {
  group(EventBus, () {
    late EventBus<AppEvent> eventBus;

    setUp(() {
      eventBus = EventBus<AppEvent>(sync: true);
    });

    tearDown(() async {
      await eventBus.dispose();
    });

    test('should receive an event of the subscribed type', () {
      const event = UserLoggedInEvent('Alice');

      expect(
        eventBus.on<UserLoggedInEvent>(),
        emits(event),
      );

      eventBus.dispatch(event);
    });

    test('should not receive an event of a different type', () {
      final receivedEvents = <UserLoggedInEvent>[];

      eventBus.on<UserLoggedInEvent>().listen(receivedEvents.add);

      eventBus.dispatch(const UserLoggedOutEvent());

      expect(receivedEvents, isEmpty);
    });

    test('multiple listeners should receive the same event', () {
      const event = UserLoggedInEvent('Bob');

      // Listener 1
      expect(
        eventBus.on<UserLoggedInEvent>(),
        emits(event),
      );

      // Listener 2
      expect(
        eventBus.on<UserLoggedInEvent>(),
        emits(event),
      );

      eventBus.dispatch(event);
    });

    test('should stop receiving events after subscription is cancelled', () async {
      final receivedEvents = <UserLoggedInEvent>[];
      const event1 = UserLoggedInEvent('Charlie');
      const event2 = UserLoggedInEvent('David');

      // Create a listener and hold onto the subscription
      final subscription = eventBus.on<UserLoggedInEvent>().listen(receivedEvents.add);

      eventBus.dispatch(event1);

      expect(receivedEvents, contains(event1));
      expect(receivedEvents.length, 1);

      await subscription.cancel();

      eventBus.dispatch(event2);

      expect(receivedEvents, isNot(contains(event2)));
      expect(receivedEvents.length, 1);
    });

    test('stream is properly closed after dispose is called', () async {
      final stream = eventBus.on<UserLoggedInEvent>();

      expect(stream, emitsDone);

      await eventBus.dispose();
    });

    test('should receive all events when listening on the base event type', () {
      final receivedEvents = <AppEvent>[];
      const loggedInEvent = UserLoggedInEvent('Frank');
      const loggedOutEvent = UserLoggedOutEvent();

      // Listen for the base AppEvent type
      eventBus.on().listen(receivedEvents.add);

      // Dispatch multiple, different event subtypes
      eventBus
        ..dispatch(loggedInEvent)
        ..dispatch(loggedOutEvent);

      // Verify that both events were received
      expect(receivedEvents.length, 2);
      expect(receivedEvents, contains(loggedInEvent));
      expect(receivedEvents, contains(loggedOutEvent));
    });
  });
}

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class UserLoggedInEvent extends AppEvent {
  final String username;

  const UserLoggedInEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class UserLoggedOutEvent extends AppEvent {
  const UserLoggedOutEvent();

  @override
  List<Object?> get props => [];
}
