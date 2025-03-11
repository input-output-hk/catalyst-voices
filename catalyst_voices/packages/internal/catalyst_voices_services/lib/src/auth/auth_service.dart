import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class AuthService implements AuthTokenProvider {
  const factory AuthService(
    UserObserver userObserver,
    KeyDerivationService keyDerivationService,
  ) = AuthServiceImpl;
}

final class AuthServiceImpl implements AuthService {
  static const String tokenPrefix = 'catv1';

  final UserObserver userObserver;
  final KeyDerivationService keyDerivationService;

  const AuthServiceImpl(
    this.userObserver,
    this.keyDerivationService,
  );

  @override
  Future<String> createRbacToken() async {
    final keyPair = await _getRole0KeyPair();

    final catalystId = await _createCatalystId(keyPair);
    final catalystIdString = catalystId.toUri().toStringWithoutScheme();
    final toBeSigned = utf8.encode('$tokenPrefix.$catalystIdString.');
    final signature = await keyPair.privateKey.sign(toBeSigned);
    final encodedSignature = base64Encode(signature.bytes);

    return '$tokenPrefix.$catalystIdString.$encodedSignature';
  }

  Future<CatalystId> _createCatalystId(CatalystKeyPair keyPair) async {
    final dateTime = DateTimeExt.now();

    return CatalystId(
      host: CatalystIdHost.cardano.host,
      role0Key: keyPair.publicKey,
      nonce: dateTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond,
    );
  }

  Future<CatalystKeyPair> _getRole0KeyPair() async {
    final account = userObserver.user.activeAccount;
    if (account == null) {
      throw StateError('Cannot create rbac token, account missing');
    }

    final masterKey = await account.keychain.getMasterKey();
    if (masterKey == null) {
      throw StateError('Cannot publish a proposal, master key missing');
    }

    return keyDerivationService.deriveAccountRoleKeyPair(
      masterKey: masterKey,
      role: AccountRole.root,
    );
  }
}
