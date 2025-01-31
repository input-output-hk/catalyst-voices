import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Defines singular account used by [User] (physical person).
/// One [User] may have multiple [Account]'s.
final class Account extends Equatable {
  /* cSpell:disable */

  /// base64 role0 key looks like
  ///
  /// ```md
  /// kid.catalyst-rbac://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE/0/0
  /// ```
  ///
  /// 'kid.catalyst-rbac://' part is common so it can be skipped while building
  /// catalystId.
  ///
  /// Examples:
  /// ```md
  /// username@cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE
  /// cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE
  /// preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE
  /// testnet.midnight/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE
  /// ```
  /* cSpell:enable */
  final String catalystId;
  final String displayName;
  final String email;
  final Keychain keychain;
  final Set<AccountRole> roles;
  final WalletInfo walletInfo;

  /// Whether this account is being used.
  final bool isActive;

  /// When account registration transaction is posted on chain account is
  /// "provisional". This means backend does not yet know about it because
  /// transaction was not yet read.
  final bool isProvisional;

  // TODO(damian-molinski): Not integrated. Backend should return it.
  String get stakingAddress {
    /* cSpell:disable */
    return 'addr1q9gkq75mt2hykrktnsgt2zxrj5h9jnd6gkwr5s4r8v'
        '5x3dzp8n9h9mns5w7zx95jhtwz46yq4nr7y6hhlwtq75jflsqq9dxry2';
    /* cSpell:enable */
  }

  static const dummyKeychainId = 'TestUserKeychainID';
  static const dummyUnlockFactor = PasswordLockFactor('Test1234');
  static final dummySeedPhrase = SeedPhrase.fromMnemonic(
    'few loyal swift champion rug peace dinosaur '
    'erase bacon tone install universe',
  );

  const Account({
    required this.catalystId,
    required this.displayName,
    required this.email,
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
      catalystId: 'cardano/${keychain.id}',
      displayName: 'Dummy',
      email: 'dummy@iohk.com',
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

  bool get isAdmin => true;

  bool get isDummy => keychain.id == dummyKeychainId;

  Account copyWith({
    String? catalystId,
    String? displayName,
    String? email,
    Keychain? keychain,
    Set<AccountRole>? roles,
    WalletInfo? walletInfo,
    bool? isActive,
    bool? isProvisional,
  }) {
    return Account(
      catalystId: catalystId ?? this.catalystId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      keychain: keychain ?? this.keychain,
      roles: roles ?? this.roles,
      walletInfo: walletInfo ?? this.walletInfo,
      isActive: isActive ?? this.isActive,
      isProvisional: isProvisional ?? this.isProvisional,
    );
  }

  @override
  List<Object?> get props => [
        catalystId,
        displayName,
        email,
        keychain.id,
        roles,
        walletInfo,
        isActive,
        isProvisional,
      ];
}
