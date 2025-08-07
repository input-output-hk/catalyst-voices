import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

typedef RoleCredentialsCallback<T> = Future<T> Function(
  CatalystId catalystId,
  CatalystPrivateKey privateKey,
);

final class AccountSignerService implements SignerService {
  final UserService _userService;

  const AccountSignerService(this._userService);

  @override
  Future<T> useProposerCredentials<T>(RoleCredentialsCallback<T> callback) {
    return _useRoleCredentials(callback, role: AccountRole.proposer);
  }

  @override
  Future<T> useVoterCredentials<T>(RoleCredentialsCallback<T> callback) {
    return _useRoleCredentials(callback, role: AccountRole.voter);
  }

  Future<T> _useRoleCredentials<T>(
    RoleCredentialsCallback<T> callback, {
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

    final keyPair = account.keychain.getRoleKeyPair(role: role);
    return keyPair.use((keyPair) => callback(catalystId, keyPair.privateKey));
  }
}

abstract interface class SignerService {
  Future<T> useProposerCredentials<T>(RoleCredentialsCallback<T> callback);

  Future<T> useVoterCredentials<T>(RoleCredentialsCallback<T> callback);
}
