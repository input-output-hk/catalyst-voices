import 'dart:typed_data';

import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
    late FakeKeyDerivationService keyDerivationService;
    late AuthTokenGenerator authTokenGenerator;
    late AuthService authService;

    setUpAll(() {
      final store = InMemorySharedPreferencesAsync.empty();
      SharedPreferencesAsyncPlatform.instance = store;

      cache = LocalAuthTokenCache(sharedPreferences: SharedPreferencesAsync());
    });

    setUp(() {
      userObserver = StreamUserObserver();
      keyDerivationService = FakeKeyDerivationService();
      authTokenGenerator = AuthTokenGenerator(keyDerivationService);
      authService = AuthService(
        cache,
        userObserver,
        authTokenGenerator,
      );
    });

    tearDown(() async {
      await SharedPreferencesAsync().clear();
    });

    tearDownAll(() async {
      await userObserver.dispose();
    });

    group('createRbacToken', () {
      final keychain = MockKeychain();

      setUp(() {
        when(() => keychain.id).thenReturn('keychain_id');
        when(
          keychain.getMasterKey,
        ).thenAnswer((_) async => FakeCatalystPrivateKey(bytes: Uint8List(32)));
      });

      tearDown(() {
        reset(keychain);
      });

      test('returns null when keychain is locked', () async {
        // Given
        final account = Account.dummy(
          catalystId: DummyCatalystIdFactory.create(),
          keychain: keychain,
          isActive: true,
        );
        final user = User.optional(accounts: [account]);

        // When
        when(() => keychain.isUnlocked).thenAnswer((_) async => false);
        userObserver.user = user;

        final token = await authService.createRbacToken();

        // Then
        expect(token, isNull);
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
        when(() => keychain.isUnlocked).thenAnswer((_) async => true);
        userObserver.user = user;

        final token = await authService.createRbacToken();

        // Then
        expect(token, startsWith(AuthTokenGenerator.tokenPrefix));
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
        when(() => keychain.isUnlocked).thenAnswer((_) async => true);
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
        when(() => keychain.isUnlocked).thenAnswer((_) async => true);
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
