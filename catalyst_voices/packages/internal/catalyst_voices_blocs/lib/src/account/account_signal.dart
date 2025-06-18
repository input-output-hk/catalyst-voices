import 'package:equatable/equatable.dart';

sealed class AccountSignal extends Equatable {
  const AccountSignal();

  @override
  List<Object?> get props => [];
}

final class AccountVerificationEmailSendSignal extends AccountSignal {
  const AccountVerificationEmailSendSignal();
}

final class PendingEmailChangeSignal extends AccountSignal {
  const PendingEmailChangeSignal();
}
