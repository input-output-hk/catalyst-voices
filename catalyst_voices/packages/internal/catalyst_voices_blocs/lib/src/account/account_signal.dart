import 'package:equatable/equatable.dart';

sealed class AccountSignal extends Equatable {
  const AccountSignal();
}

final class AccountVerificationEmailSendSignal extends AccountSignal {
  const AccountVerificationEmailSendSignal();

  @override
  List<Object?> get props => [];
}
