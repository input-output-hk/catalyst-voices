import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Defines singular account used by [User] (physical person).
/// One [User] may have multiple [Account]'s.
final class Account extends Equatable {
  final String keychainId;
  final Set<AccountRole> roles;
  final WalletInfo walletInfo;

  /// When account registration transaction is posted on chain account is
  /// "provisional". This means backend does not yet know about it because
  /// transaction was not yet read.
  final bool isProvisional;

  const Account({
    required this.keychainId,
    required this.roles,
    required this.walletInfo,
    this.isProvisional = true,
  });

  factory Account.dummy({
    required String keychainId,
  }) {
    return Account(
      keychainId: keychainId,
      roles: const {
        AccountRole.voter,
        AccountRole.proposer,
      },
      walletInfo: WalletInfo(
        metadata: const WalletMetadata(name: 'Dummy Wallet', icon: null),
        balance: Coin.fromAda(10),
        /* cSpell:disable */
        address: ShelleyAddress.fromBech32(
          'addr_test1vzpwq95z3xyum8vqndgdd'
          '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
        ),
        /* cSpell:enable */
      ),
      isProvisional: true,
    );
  }

  // Note. this is not defined yet what we will show here.
  String get acronym => 'A';

  bool get isAdmin => true;

  Account copyWith({
    String? keychainId,
    Set<AccountRole>? roles,
    WalletInfo? walletInfo,
    bool? isProvisional,
  }) {
    return Account(
      keychainId: keychainId ?? this.keychainId,
      roles: roles ?? this.roles,
      walletInfo: walletInfo ?? this.walletInfo,
      isProvisional: isProvisional ?? this.isProvisional,
    );
  }

  @override
  List<Object?> get props => [
        keychainId,
        roles,
        walletInfo,
        isProvisional,
      ];
}
