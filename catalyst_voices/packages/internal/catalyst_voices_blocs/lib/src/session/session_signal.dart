import 'package:equatable/equatable.dart';

final class AccountNeedsVerificationSignal extends SessionSignal {
  final bool isProposer;

  const AccountNeedsVerificationSignal({
    this.isProposer = false,
  });

  @override
  List<Object?> get props => [isProposer];
}

final class CancelAccountNeedsVerificationSignal extends SessionSignal {
  const CancelAccountNeedsVerificationSignal();
}

/// Signal emitted when the keychain is locked.
final class KeychainLockedSignal extends SessionSignal {
  const KeychainLockedSignal();
}

/// Signal emitted when the keychain is unlocked.
final class KeychainUnlockedSignal extends SessionSignal {
  const KeychainUnlockedSignal();
}

sealed class SessionSignal extends Equatable {
  const SessionSignal();

  @override
  List<Object?> get props => [];
}
