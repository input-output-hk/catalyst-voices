import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Defines user or the app.
final class User extends Equatable {
  final List<Account> accounts;
  final UserSettings settings;

  const User({
    required this.accounts,
    required this.settings,
  });

  @visibleForTesting
  const User.optional({
    this.accounts = const [],
    this.settings = const UserSettings(),
  });

  const User.empty()
      : this(
          accounts: const [],
          settings: const UserSettings(),
        );

  Account? get activeAccount {
    return accounts.singleWhereOrNull((account) => account.isActive);
  }

  User useAccount({
    required String catalystId,
  }) {
    if (this.accounts.none((e) => e.catalystId == catalystId)) {
      throw ArgumentError('Account[$catalystId] is not on the list');
    }

    final accounts = [...this.accounts]
        .map((e) => e.copyWith(isActive: e.catalystId == catalystId))
        .toList();

    return copyWith(accounts: accounts);
  }

  bool hasAccount({
    required String catalystId,
  }) {
    return accounts.any((element) => element.catalystId == catalystId);
  }

  User addAccount(Account account) {
    final accounts = [...this.accounts, account];

    return copyWith(accounts: accounts);
  }

  User removeAccount({
    required String catalystId,
  }) {
    final accounts = [...this.accounts]
        .where((element) => element.catalystId != catalystId)
        .toList();

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

  @override
  List<Object?> get props => [
        accounts,
        settings,
      ];
}
