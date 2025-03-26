import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

typedef RoleCredentialsCallback = Future<void> Function(
  CatalystId catalystId,
  CatalystPrivateKey privateKey,
);

final class AccountSignerService implements SignerService {
  final UserService _userService;
  final KeyDerivationService _keyDerivationService;

  const AccountSignerService(
    this._userService,
    this._keyDerivationService,
  );

  @override
  Future<void> useProposerCredentials(RoleCredentialsCallback callback) {
    return _useRoleCredentials(callback, role: AccountRole.proposer);
  }

  @override
  Future<void> useVoterCredentials(RoleCredentialsCallback callback) {
    return _useRoleCredentials(callback, role: AccountRole.voter);
  }

  Future<void> _useRoleCredentials(
    RoleCredentialsCallback callback, {
    required AccountRole role,
    int rotation = 0,
  }) async {
    final account = _userService.user.activeAccount;
    if (account == null) {
      throw StateError('Cannot obtain proposer credentials, account missing');
    }

    final catalystId = account.catalystId.copyWith(
      role: Optional(role),
      rotation: Optional(rotation),
    );

    await account.keychain.getMasterKey().use((masterKey) async {
      final keyPair = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: role,
      );

      await keyPair.use(
        (keyPair) => callback(catalystId, keyPair.privateKey),
      );
    });
  }
}

abstract interface class SignerService {
  Future<void> useProposerCredentials(RoleCredentialsCallback callback);

  Future<void> useVoterCredentials(RoleCredentialsCallback callback);
}
