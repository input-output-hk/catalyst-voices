import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Defines user of the app.
final class User extends Equatable {
  final List<Account> accounts;
  final UserSettings settings;

  const User({
    required this.accounts,
    required this.settings,
  });

  const User.empty()
    : this(
        accounts: const [],
        settings: const UserSettings(),
      );

  @visibleForTesting
  const User.optional({
    this.accounts = const [],
    this.settings = const UserSettings(),
  });

  Account? get activeAccount {
    return accounts.singleWhereOrNull((account) => account.isActive);
  }

  @override
  List<Object?> get props => [
    accounts,
    settings,
  ];

  User addAccount(Account account) {
    final accounts = [...this.accounts, account];

    return copyWith(accounts: accounts);
  }

  User copyWith({
    List<Account>? accounts,
    UserSettings? settings,
  }) {
    return User(
      accounts: accounts ?? this.accounts,
      settings: settings ?? this.settings,
    );
  }

  /// Returns [Account] with corresponding [id] (comparing significant part).
  ///
  /// Throws exception if not found.
  Account getAccount(CatalystId id) {
    return accounts.singleWhere((account) => id.isReferringTo(account));
  }

  ///
  bool hasAccount({
    required CatalystId id,
  }) {
    return accounts.any((account) => id.isReferringTo(account));
  }

  /// Removes matching [Account] from [accounts] with corresponding [id] (comparing
  /// significant part).
  ///
  /// Returns copy of [User] with updated [accounts].
  User removeAccount({
    required CatalystId id,
  }) {
    final accounts = [...this.accounts].where((account) => !id.isReferringTo(account)).toList();

    return copyWith(accounts: accounts);
  }

  /// Tries to find matching [Account] (compares ids) and replaces it with [account].
  ///
  /// Returns copy of [User] with updated [accounts].
  User updateAccount(Account account) {
    final accounts = List.of(this.accounts).map((e) => e.isSameRef(account) ? account : e).toList();

    return copyWith(accounts: accounts);
  }

  /// Tries to find [Account] with corresponding [id] and marks it as active.
  ///
  /// Returns copy of [User] with updated [accounts].
  User useAccount({
    required CatalystId id,
  }) {
    if (this.accounts.none((account) => id.isReferringTo(account))) {
      throw ArgumentError('Account[$id] is not on the list');
    }

    final accounts = [
      ...this.accounts,
    ].map((account) => account.copyWith(isActive: id.isReferringTo(account))).toList();

    return copyWith(accounts: accounts);
  }
}
