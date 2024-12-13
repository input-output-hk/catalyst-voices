import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Defines user or the app.
final class User extends Equatable {
  final List<Account> accounts;
  final String? activeKeychainId;

  const User({
    required this.accounts,
    this.activeKeychainId,
  });

  const User.empty() : this(accounts: const []);

  Account? get activeAccount {
    return accounts
        .singleWhereOrNull((account) => account.keychainId == activeKeychainId);
  }

  User copyWith({
    List<Account>? accounts,
    Optional<String>? activeKeychainId,
  }) {
    return User(
      accounts: accounts ?? this.accounts,
      activeKeychainId: activeKeychainId.dataOr(this.activeKeychainId),
    );
  }

  @override
  List<Object?> get props => [
        accounts,
        activeKeychainId,
      ];
}
