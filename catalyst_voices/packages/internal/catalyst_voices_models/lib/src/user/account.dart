import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Defines singular account used by [User] (physical person).
/// One [User] may have multiple [Account]'s.
final class Account extends Equatable {
  final Keychain keychain;
  final Set<AccountRole> roles;
  final WalletInfo walletInfo;

  /// Whether this account is beaning used.
  final bool isActive;

  /// When account registration transaction is posted on chain account is
  /// "provisional". This means backend does not yet know about it because
  /// transaction was not yet read.
  final bool isProvisional;

  static const dummyKeychainId = 'TestUserKeychainID';
  static const dummyUnlockFactor = PasswordLockFactor('Test1234');
  static final dummySeedPhrase = SeedPhrase.fromMnemonic(
    'few loyal swift champion rug peace dinosaur '
    'erase bacon tone install universe',
  );

  const Account({
    required this.keychain,
    required this.roles,
    required this.walletInfo,
    this.isActive = false,
    this.isProvisional = true,
  });

  factory Account.dummy({
    required Keychain keychain,
    bool isActive = false,
  }) {
    return Account(
      keychain: keychain,
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
      isActive: isActive,
      isProvisional: true,
    );
  }

  String get id => keychain.id;

  // Note. this is not defined yet what we will show here.
  String get acronym => 'A';

  bool get isAdmin => true;

  bool get isDummy => keychain.id == dummyKeychainId;

  Account copyWith({
    Keychain? keychain,
    Set<AccountRole>? roles,
    WalletInfo? walletInfo,
    bool? isActive,
    bool? isProvisional,
  }) {
    return Account(
      keychain: keychain ?? this.keychain,
      roles: roles ?? this.roles,
      walletInfo: walletInfo ?? this.walletInfo,
      isActive: isActive ?? this.isActive,
      isProvisional: isProvisional ?? this.isProvisional,
    );
  }

  @override
  List<Object?> get props => [
        keychain.id,
        roles,
        walletInfo,
        isActive,
        isProvisional,
      ];
}
