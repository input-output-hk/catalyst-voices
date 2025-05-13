import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Defines singular account used by [User] (physical person).
/// One [User] may have multiple [Account]'s.
final class Account extends Equatable {
  /* cSpell:disable */

  static const dummyKeychainId = 'TestUserKeychainID';
  static const dummyUnlockFactor = PasswordLockFactor('Test1234');
  static final dummySeedPhrase = SeedPhrase.fromMnemonic(
    'few loyal swift champion rug peace dinosaur '
    'erase bacon tone install universe',
  );

  /* cSpell:enable */

  final CatalystId catalystId;
  final String? email;
  final Keychain keychain;
  final Set<AccountRole> roles;

  /// The wallet change address used when submitting the initial registration.
  ///
  /// null for users created before this field was added here.
  final ShelleyAddress? address;

  /// Status of this account in reviews module. Public status
  /// can be changed by attaching [email] to account.
  final AccountPublicStatus publicStatus;

  /// Whether this account is being used.
  final bool isActive;

  const Account({
    required this.catalystId,
    this.email,
    required this.keychain,
    required this.roles,
    required this.address,
    required this.publicStatus,
    this.isActive = false,
  }) : assert(
          (email == null && publicStatus == AccountPublicStatus.notSetup) ||
              (email != null && publicStatus != AccountPublicStatus.notSetup),
          'Account publicStatus have to be notSetup only when email is not set',
        );

  factory Account.dummy({
    required CatalystId catalystId,
    required Keychain keychain,
    bool isActive = false,
  }) {
    return Account(
      catalystId: catalystId,
      keychain: keychain,
      roles: const {
        AccountRole.voter,
        AccountRole.proposer,
      },
      /* cSpell:disable */
      address: ShelleyAddress.fromBech32(
        'addr_test1vzpwq95z3xyum8vqndgdd'
        '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
      ),
      /* cSpell:enable */
      publicStatus: AccountPublicStatus.notSetup,
      isActive: isActive,
    );
  }

  // Note. Disabled all admin functionalities for F14.
  bool get isAdmin => false;

  bool get isDummy => keychain.id == dummyKeychainId;

  // TODO(damian-molinski): Update this getter.
  /// When account registration transaction is posted on chain account is
  /// "provisional". This means backend does not yet know about it because
  /// transaction was not yet read.
  bool get isProvisional => true;

  @override
  List<Object?> get props => [
        catalystId,
        email,
        keychain.id,
        roles,
        address,
        publicStatus,
        isActive,
      ];

  String? get username => catalystId.username;

  Account copyWith({
    CatalystId? catalystId,
    Optional<String>? email,
    Keychain? keychain,
    Set<AccountRole>? roles,
    ShelleyAddress? address,
    AccountPublicStatus? publicStatus,
    bool? isActive,
  }) {
    return Account(
      catalystId: catalystId ?? this.catalystId,
      email: email.dataOr(this.email),
      keychain: keychain ?? this.keychain,
      roles: roles ?? this.roles,
      address: address ?? this.address,
      publicStatus: publicStatus ?? this.publicStatus,
      isActive: isActive ?? this.isActive,
    );
  }

  bool hasRole(AccountRole role) {
    return roles.contains(role);
  }

  bool isSameRef(Account other) => catalystId.isReferringTo(other);
}

extension CatalystIdExt on CatalystId {
  /// Compares accounts against significant parts of [Account] catalystId.
  bool isReferringTo(Account account) {
    return toSignificant() == account.catalystId.toSignificant();
  }
}
