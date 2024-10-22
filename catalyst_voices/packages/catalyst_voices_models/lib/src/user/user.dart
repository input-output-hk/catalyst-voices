import 'package:catalyst_voices_models/src/user/account.dart';
import 'package:equatable/equatable.dart';

/// Defines user or the app.
final class User extends Equatable {
  final List<Account> accounts;

  User({
    required Account account,
  }) : accounts = [account];

  /// Just syntax sugar for [activeAccount].
  Account get account => activeAccount;

  // Note. At the moment we support only single profile Users but later
  // this may change and this implementation with it.
  Account get activeAccount => accounts.single;

  @override
  List<Object?> get props => [
        accounts,
      ];
}
