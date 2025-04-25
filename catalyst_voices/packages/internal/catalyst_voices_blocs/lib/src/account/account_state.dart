import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

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

final class AccountState extends Equatable {
  final MyAccountStatusNotification status;
  final CatalystId? catalystId;
  final Username username;
  final Email email;
  final AccountRolesState roles;
  final String walletConnected;
  final AccountPublicStatus accountPublicStatus;

  const AccountState({
    this.status = const None(),
    this.catalystId,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.roles = const AccountRolesState(),
    this.walletConnected = '',
    this.accountPublicStatus = AccountPublicStatus.unknown,
  });

  @override
  List<Object?> get props => [
        status,
        catalystId,
        username,
        email,
        roles,
        walletConnected,
        accountPublicStatus,
      ];

  AccountState copyWith({
    MyAccountStatusNotification? status,
    Optional<CatalystId>? catalystId,
    Username? username,
    Email? email,
    AccountRolesState? roles,
    String? walletConnected,
    AccountPublicStatus? accountPublicStatus,
  }) {
    return AccountState(
      status: status ?? this.status,
      catalystId: catalystId.dataOr(this.catalystId),
      username: username ?? this.username,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      walletConnected: walletConnected ?? this.walletConnected,
      accountPublicStatus: accountPublicStatus ?? this.accountPublicStatus,
    );
  }
}
