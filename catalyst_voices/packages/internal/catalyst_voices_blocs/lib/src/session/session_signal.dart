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

sealed class SessionSignal extends Equatable {
  const SessionSignal();

  @override
  List<Object?> get props => [];
}
