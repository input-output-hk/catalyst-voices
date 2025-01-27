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

  User useAccount({required String id}) {
    if (this.accounts.none((e) => e.id == id)) {
      throw ArgumentError('Account[$id] is not on the list');
    }

    final accounts = [...this.accounts]
        .map((e) => e.copyWith(isActive: e.id == id))
        .toList();

    return copyWith(accounts: accounts);
  }

  bool hasAccount({required String id}) {
    return accounts.any((element) => element.id == id);
  }

  User addAccount(Account account) {
    final accounts = [...this.accounts, account];

    return copyWith(accounts: accounts);
  }

  User removeAccount({required String id}) {
    final accounts =
        [...this.accounts].where((element) => element.id != id).toList();

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
