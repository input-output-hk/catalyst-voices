import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/auth/auth_service.dart';
import 'package:catalyst_voices_services/src/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  group(AuthService, () {
    late final AuthTokenCache cache;
    late UserObserver userObserver;
    late _FakeKeyDerivationService keyDerivationService;
    late AuthService authService;

    setUpAll(() {
      final store = InMemorySharedPreferencesAsync.empty();
      SharedPreferencesAsyncPlatform.instance = store;

      cache = LocalAuthTokenCache(sharedPreferences: SharedPreferencesAsync());
    });

    setUp(() {
      userObserver = StreamUserObserver();
      keyDerivationService = _FakeKeyDerivationService();
      authService = AuthService(
        cache,
        userObserver,
        keyDerivationService,
      );
    });

    tearDown(() async {
      await SharedPreferencesAsync().clear();
    });

    tearDownAll(() async {
      await userObserver.dispose();
    });

    group('createRbacToken', () {
      final keychain = _MockKeychain();

      setUp(() {
        when(() => keychain.id).thenReturn('keychain_id');
        when(keychain.getMasterKey)
            .thenAnswer((_) async => _FakeCatalystPrivateKey(Uint8List(32)));
      });

      tearDown(() {
        reset(keychain);
      });

      test('returns a valid token', () async {
        // Given
        final account = Account.dummy(
          catalystId: DummyCatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        );
        final user = User.optional(accounts: [account]);

        // When
        userObserver.user = user;

        final token = await authService.createRbacToken();

        // Then
        expect(token, startsWith(AuthServiceImpl.tokenPrefix));
      });

      test('keeps token cached and calls keychain once', () async {
        // Given
        final account = Account.dummy(
          catalystId: DummyCatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        );
        final user = User.optional(accounts: [account]);

        // When
        userObserver.user = user;

        await List.generate(4, (_) => authService.createRbacToken()).wait;

        // Then
        verify(keychain.getMasterKey).called(1);
      });

      test('creates new token each time when force update is set', () async {
        // Given
        const tokensCount = 4;
        final account = Account.dummy(
          catalystId: DummyCatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        );
        final user = User.optional(accounts: [account]);

        // When
        userObserver.user = user;

        await List.generate(
          tokensCount,
          (_) => authService.createRbacToken(forceRefresh: true),
        ).wait;

        // Then
        verify(keychain.getMasterKey).called(tokensCount);
      });
    });
  });
}

class _FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPrivateKey(this.bytes);

  @override
  void drop() {
    // do nothing
  }

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
