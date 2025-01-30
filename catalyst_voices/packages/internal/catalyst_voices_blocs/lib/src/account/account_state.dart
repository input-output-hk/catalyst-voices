import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class AccountState extends Equatable {
  final DisplayName displayName;
  final Email email;
  final Set<AccountRole> roles;
  final String walletConnected;

  const AccountState({
    this.displayName = const DisplayName.pure(),
    this.email = const Email.pure(),
    this.roles = const {},
    this.walletConnected = '',
  });

  AccountState copyWith({
    DisplayName? displayName,
    Email? email,
    Set<AccountRole>? roles,
    String? walletConnected,
  }) {
    return AccountState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      walletConnected: walletConnected ?? this.walletConnected,
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        email,
        roles,
        walletConnected,
      ];
}
