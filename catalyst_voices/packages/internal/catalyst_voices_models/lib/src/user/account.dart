import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Defines singular account used by [User] (physical person).
/// One [User] may have multiple [Account]'s.
final class Account extends Equatable {
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

  /// Groups user defined settings.
  final AccountSettings settings;

  static const dummyKeychainId = 'TestUserKeychainID';
  static const dummyUnlockFactor = PasswordLockFactor('Test1234');
  static final dummySeedPhrase = SeedPhrase.fromMnemonic(
    'few loyal swift champion rug peace dinosaur '
    'erase bacon tone install universe',
  );

  const Account({
    required this.displayName,
    required this.email,
    required this.keychain,
    required this.roles,
    required this.walletInfo,
    this.isActive = false,
    this.isProvisional = true,
    this.settings = const AccountSettings(),
  });

  factory Account.dummy({
    required Keychain keychain,
    bool isActive = false,
  }) {
    return Account(
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
      settings: const AccountSettings(),
    );
  }

  String get id => keychain.id;

  bool get isAdmin => true;

  bool get isDummy => keychain.id == dummyKeychainId;

  Account copyWith({
    String? displayName,
    String? email,
    Keychain? keychain,
    Set<AccountRole>? roles,
    WalletInfo? walletInfo,
    bool? isActive,
    bool? isProvisional,
    AccountSettings? settings,
  }) {
    return Account(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      keychain: keychain ?? this.keychain,
      roles: roles ?? this.roles,
      walletInfo: walletInfo ?? this.walletInfo,
      isActive: isActive ?? this.isActive,
      isProvisional: isProvisional ?? this.isProvisional,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        email,
        keychain.id,
        roles,
        walletInfo,
        isActive,
        isProvisional,
        settings,
      ];
}

final class AccountSettings extends Equatable {
  final TimezonePreferences? timezone;
  final ThemePreferences? theme;

  const AccountSettings({
    this.timezone,
    this.theme,
  });

  AccountSettings copyWith({
    Optional<TimezonePreferences>? timezone,
    Optional<ThemePreferences>? theme,
  }) {
    return AccountSettings(
      timezone: timezone.dataOr(this.timezone),
      theme: theme.dataOr(this.theme),
    );
  }

  @override
  List<Object?> get props => [
        timezone,
        theme,
      ];
}
