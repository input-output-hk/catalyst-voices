import 'package:equatable/equatable.dart';

// TODO(damian-molinski): rename to AccountRole
final class AccountRoleData extends Equatable {
  final AccountRole type;
  final AccountRoleStatus status;

  const AccountRoleData({
    required this.type,
    required this.status,
  });

  AccountRoleData copyWith({
    AccountRole? type,
    AccountRoleStatus? status,
  }) {
    return AccountRoleData(
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [type, status];
}

// TODO(damian-molinski): rename AccountRoleType
enum AccountRole {
  /// An account role that is assigned to every account.
  /// Allows to vote for proposals.
  voter(number: 0, isDefault: true),

  /// A delegated representative that can vote on behalf of other accounts.
  drep(number: 1, isHidden: true),

  /// An account role that can create new proposals.
  proposer(number: 3);

  /// The RBAC specified role number.
  final int number;
  final bool isDefault;
  final bool isHidden;

  const AccountRole({
    required this.number,
    this.isDefault = false,
    this.isHidden = false,
  });

  /// Returns the role which is assigned to every user.
  static AccountRole get root => voter;
}

enum AccountRoleStatus {
  /// meaning transaction was sent but backend does not know about it yet.
  sent,

  /// backend seen transaction with given role.
  confirmed,
}
