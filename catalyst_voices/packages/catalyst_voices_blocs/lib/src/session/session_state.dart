import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Determines the state of the user session.
sealed class SessionState extends Equatable {
  const SessionState();
}

/// The user hasn't registered yet nor setup the keychain.
final class VisitorSessionState extends SessionState {
  const VisitorSessionState();

  @override
  List<Object?> get props => [];
}

/// The user has registered the keychain but it's locked.
final class GuestSessionState extends SessionState {
  const GuestSessionState();

  @override
  List<Object?> get props => [];
}

/// The user has registered and unlocked the keychain.
final class ActiveUserSessionState extends SessionState {
  const ActiveUserSessionState({
    required this.user,
  });

  final User user;

  @override
  List<Object?> get props => [
        user,
      ];
}
