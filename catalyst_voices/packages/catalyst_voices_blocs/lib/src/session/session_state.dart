import 'package:equatable/equatable.dart';

/// Determines the state of the user session.
sealed class SessionState extends Equatable {
  const SessionState();
}

/// The user hasn't registered yet nor setup the keychain.
class VisitorSessionState extends SessionState {
  const VisitorSessionState();

  @override
  List<Object?> get props => [];
}

/// The user has registered the keychain but it's locked.
class GuestSessionState extends SessionState {
  const GuestSessionState();

  @override
  List<Object?> get props => [];
}

/// The user has registered and unlocked the keychain.
class ActiveUserSessionState extends SessionState {
  const ActiveUserSessionState();

  @override
  List<Object?> get props => [];
}
