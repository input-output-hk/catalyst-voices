import 'package:equatable/equatable.dart';

/// Describes events that change the user session.
sealed class SessionEvent extends Equatable {
  const SessionEvent();
}

/// Dummy implementation of session management,
/// just toggles the next session state or reset to the initial one.
class NextStateSessionEvent extends SessionEvent {
  const NextStateSessionEvent();

  @override
  List<Object?> get props => [];
}
