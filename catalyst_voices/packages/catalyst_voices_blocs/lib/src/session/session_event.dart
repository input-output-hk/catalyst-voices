import 'package:equatable/equatable.dart';

/// Describes events that change the user session.
sealed class SessionEvent extends Equatable {
  const SessionEvent();
}

/// Dummy implementation of session management,
/// just toggles the next session state or reset to the initial one.
final class NextStateSessionEvent extends SessionEvent {
  const NextStateSessionEvent();

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
