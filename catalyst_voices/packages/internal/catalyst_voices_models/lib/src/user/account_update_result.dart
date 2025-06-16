import 'package:equatable/equatable.dart';

final class AccountUpdateResult extends Equatable {
  final bool didChanged;

  /// When account has verified public profile (email) and new email was send it will not
  /// be used until new is verified.
  final bool hasPendingEmailChange;

  const AccountUpdateResult({
    this.didChanged = false,
    this.hasPendingEmailChange = false,
  });

  @override
  List<Object?> get props => [
        didChanged,
        hasPendingEmailChange,
      ];
}
