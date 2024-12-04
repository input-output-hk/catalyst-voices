import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Defines singular account used by [User] (physical person).
/// One [User] may have multiple [Account]'s.
final class Account extends Equatable {
  final String keychainId;
  final Set<AccountRole> roles;
  final WalletInfo walletInfo;

  const Account({
    required this.keychainId,
    required this.roles,
    required this.walletInfo,
  });

  // Note. this is not defined yet what we will show here.
  String get acronym => 'A';

  bool get isAdmin => true;

  @override
  List<Object?> get props => [
        keychainId,
        roles,
        walletInfo,
      ];
}
