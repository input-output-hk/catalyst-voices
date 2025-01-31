import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class AccountState extends Equatable {
  final MyAccountStatusNotification status;
  final DisplayName displayName;
  final Email email;
  final AccountRolesState roles;
  final String walletConnected;

  const AccountState({
    this.status = const None(),
    this.displayName = const DisplayName.pure(),
    this.email = const Email.pure(),
    this.roles = const AccountRolesState(),
    this.walletConnected = '',
  });

  AccountState copyWith({
    MyAccountStatusNotification? status,
    DisplayName? displayName,
    Email? email,
    AccountRolesState? roles,
    String? walletConnected,
  }) {
    return AccountState(
      status: status ?? this.status,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      walletConnected: walletConnected ?? this.walletConnected,
    );
  }

  @override
  List<Object?> get props => [
        status,
        displayName,
        email,
        roles,
        walletConnected,
      ];
}

final class AccountRolesState extends Equatable {
  final List<MyAccountRoleItem> items;
  final bool canAddRole;

  const AccountRolesState({
    this.items = const [],
    this.canAddRole = false,
  });

  @override
  List<Object?> get props => [items, canAddRole];
}
