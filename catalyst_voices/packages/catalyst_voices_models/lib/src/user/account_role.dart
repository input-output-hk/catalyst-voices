enum AccountRole {
  voter(roleNumber: 0),

  // TODO(dtscalac): the RBAC specification doesn't define yet the role number
  // for the proposer, replace this arbitrary number when it's specified.
  proposer(roleNumber: 1),

  // TODO(dtscalac): the RBAC specification doesn't define yet the role number
  // for the drep, replace this arbitrary number when it's specified.
  drep(roleNumber: 2);

  /// The RBAC specified role number.
  final int roleNumber;

  const AccountRole({required this.roleNumber});

  /// Returns the role which is assigned to every user.
  static AccountRole get root => voter;
}
