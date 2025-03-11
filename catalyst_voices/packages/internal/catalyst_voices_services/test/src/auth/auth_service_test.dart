import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/auth/auth_service.dart';
import 'package:catalyst_voices_services/src/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(AuthService, () {
    late UserObserver userObserver;
    late _FakeKeyDerivationService keyDerivationService;
    late AuthService authService;

    setUp(() {
      userObserver = StreamUserObserver();
      keyDerivationService = _FakeKeyDerivationService();
      authService = AuthService(userObserver, keyDerivationService);
    });

    tearDownAll(() async {
      await userObserver.dispose();
    });

    test('createRbacToken returns a valid token', () async {
      final keychain = _MockKeychain();
      when(() => keychain.id).thenReturn('keychain_id');
      when(keychain.getMasterKey)
          .thenAnswer((_) async => _FakeCatalystPrivateKey(Uint8List(32)));

      final account = Account.dummy(keychain: keychain, isActive: true);
      final user = User.optional(accounts: [account]);
      userObserver.user = user;

      final token = await authService.createRbacToken();
      expect(token, startsWith(AuthServiceImpl.tokenPrefix));
    });
  });
}

class _FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPrivateKey(this.bytes);

  @override
  Future<CatalystSignature> sign(Uint8List data) async {
    return _FakeCatalystSignature(data);
  }
}

class _FakeCatalystPublicKey extends Fake implements CatalystPublicKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPublicKey(this.bytes);

  @override
  Uint8List get publicKeyBytes => bytes;
}

class _FakeCatalystSignature extends Fake implements CatalystSignature {
  @override
  final Uint8List bytes;

  _FakeCatalystSignature(this.bytes);
}

class _FakeKeyDerivationService extends Fake implements KeyDerivationService {
  @override
  Future<CatalystKeyPair> deriveAccountRoleKeyPair({
    required CatalystPrivateKey masterKey,
    required AccountRole role,
  }) async {
    return CatalystKeyPair(
      publicKey: _FakeCatalystPublicKey(masterKey.bytes),
      privateKey: _FakeCatalystPrivateKey(masterKey.bytes),
    );
  }
}

class _MockKeychain extends Mock implements Keychain {}
