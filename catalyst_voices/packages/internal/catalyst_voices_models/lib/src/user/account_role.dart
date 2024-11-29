enum AccountRole {
  /// An account role that is assigned to every account.
  /// Allows to vote for proposals.
  voter(roleNumber: 0),

  /// A delegated representative that can vote on behalf of other accounts.
  drep(roleNumber: 1),

  /// An account role that can create new proposals.
  proposer(roleNumber: 3);

  /// The RBAC specified role number.
  final int roleNumber;

  const AccountRole({required this.roleNumber});

  /// Returns the role which is assigned to every user.
  static AccountRole get root => voter;
}
