import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Defines user or the app.
final class User extends Equatable {
  final List<Account> accounts;

  const User({
    required this.accounts,
  });

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
  }) {
    return User(
      accounts: accounts ?? this.accounts,
    );
  }

  @override
  List<Object?> get props => [
        accounts,
      ];
}
