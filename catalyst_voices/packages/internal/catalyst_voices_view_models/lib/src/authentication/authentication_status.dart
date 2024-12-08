enum AuthenticationStatus {
  /// A user has a keychain and it is unlocked.
  actor,

  /// A user has a keychain but it is locked.
  guest,

  /// A user doesn't have a keychain.
  visitor;
}
