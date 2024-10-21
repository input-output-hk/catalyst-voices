import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Defines singular account used by [User] (physical person).
/// One [User] may have multiple [Account]'s.
final class Account extends Equatable {
  const Account({
    required this.roles,
    required this.walletInfo,
  });

  final Set<AccountRole> roles;
  final WalletInfo walletInfo;

  @override
  List<Object?> get props => [
        roles,
        walletInfo,
      ];
}
