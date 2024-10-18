import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:equatable/equatable.dart';

/// Describes events that change the user session.
sealed class SessionEvent extends Equatable {
  const SessionEvent();
}

/// An event to restore the last session after the app is restarted.
final class RestoreSessionEvent extends SessionEvent {
  const RestoreSessionEvent();

  @override
  List<Object?> get props => [];
}

/// An event to unlock the session with given [unlockFactor].
final class UnlockSessionEvent extends SessionEvent {
  final LockFactor unlockFactor;

  const UnlockSessionEvent({required this.unlockFactor});

  @override
  List<Object?> get props => [unlockFactor];

  // Deliberately override the toString() so that
  // we don't expose the unlockFactor in the logs.
  @override
  String toString() => 'UnlockSessionEvent';
}

/// An event to lock the session.
final class LockSessionEvent extends SessionEvent {
  const LockSessionEvent();

  @override
  List<Object?> get props => [];
}

/// Dummy implementation of session management.
final class VisitorSessionEvent extends SessionEvent {
  const VisitorSessionEvent();

  @override
  List<Object?> get props => [];
}

/// Dummy implementation of session management.
final class GuestSessionEvent extends SessionEvent {
  const GuestSessionEvent();

  @override
  List<Object?> get props => [];
}

/// Dummy implementation of session management.
final class ActiveUserSessionEvent extends SessionEvent {
  const ActiveUserSessionEvent();

  @override
  List<Object?> get props => [];
}

/// An event which triggers keychain deletion.
final class RemoveKeychainSessionEvent extends SessionEvent {
  const RemoveKeychainSessionEvent();

  @override
  List<Object?> get props => [];
}
