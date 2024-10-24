import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Determines the state of the user session.
sealed class SessionState extends Equatable {
  const SessionState();
}

/// The user hasn't registered yet nor setup the keychain.
final class VisitorSessionState extends SessionState {
  final bool isRegistrationInProgress;

  const VisitorSessionState({
    required this.isRegistrationInProgress,
  });

  @override
  List<Object?> get props => [
        isRegistrationInProgress,
      ];
}

/// The user has registered the keychain but it's locked.
final class GuestSessionState extends SessionState {
  const GuestSessionState();

  @override
  List<Object?> get props => [];
}

/// The user has registered and unlocked the keychain.
final class ActiveAccountSessionState extends SessionState {
  final Account? account;

  const ActiveAccountSessionState({
    this.account,
  });

  @override
  List<Object?> get props => [
        account,
      ];
}
