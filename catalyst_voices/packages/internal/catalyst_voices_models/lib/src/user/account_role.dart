enum AccountRole {
  /// An account role that is assigned to every account.
  /// Allows to vote for proposals.
  voter(number: 0),

  /// A delegated representative that can vote on behalf of other accounts.
  drep(number: 1),

  /// An account role that can create new proposals.
  proposer(number: 3);

  /// The RBAC specified role number.
  final int number;

  const AccountRole({required this.number});

  /// Returns the role which is assigned to every user.
  static AccountRole get root => voter;
}
