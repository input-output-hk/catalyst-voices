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
