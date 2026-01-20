import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Defines possible account roles.
// TODO(damian-molinski): rename AccountRoleType
enum AccountRole {
  /// An account role that is assigned to every account.
  /// Allows to vote for proposals.
  voter(number: 0, registrationOffset: 0, isDefault: true),

  /// A delegated representative that can vote on behalf of other accounts.
  drep(number: 1, registrationOffset: 1),

  /// An account role that can create new proposals.
  proposer(number: 3, registrationOffset: 2);

  /// Returns the role which is assigned to every user.
  static AccountRole get root => voter;

  /// The RBAC specified role number.
  final int number;

  /// The offset in the registration transaction at which the role specific
  /// signing key is registered.
  ///
  /// The offsets for the roles should be as low as possible to avoid creating
  /// big gaps of unused slots in the registration transaction.
  ///
  /// The offsets cannot be reused, if any of the roles registered ever
  /// a signing key at a given slot then no other role ever again can
  /// reuse the slot because it would be confusing to which
  /// role the signing key belongs.
  final int registrationOffset;
  final bool isDefault;
  final bool isHidden;

  const AccountRole({
    required this.number,
    required this.registrationOffset,
    this.isDefault = false,
    this.isHidden = false,
  });

  factory AccountRole.fromNumber(int number) {
    final role = maybeFromNumber(number);
    if (role != null) {
      return role;
    }

    throw ArgumentError('Unsupported role with number: $number');
  }

  static AccountRole? fromRegistrationOffset(int registrationOffset) {
    return values.firstWhereOrNull((e) => e.registrationOffset == registrationOffset);
  }

  static AccountRole? maybeFromNumber(int number) {
    for (final value in values) {
      if (value.number == number) {
        return value;
      }
    }

    return null;
  }
}

// TODO(damian-molinski): rename to AccountRole
final class AccountRoleData extends Equatable {
  final AccountRole type;
  final AccountRoleStatus status;

  const AccountRoleData({
    required this.type,
    required this.status,
  });

  @override
  List<Object?> get props => [type, status];

  AccountRoleData copyWith({
    AccountRole? type,
    AccountRoleStatus? status,
  }) {
    return AccountRoleData(
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}

enum AccountRoleStatus {
  /// meaning transaction was sent but backend does not know about it yet.
  volatile,

  /// backend seen transaction with given role in chain.
  permanent,
}
