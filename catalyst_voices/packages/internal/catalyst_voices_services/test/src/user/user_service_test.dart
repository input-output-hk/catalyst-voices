import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:uuid/uuid.dart';

void main() {
  late final KeychainProvider provider;
  late final UserRepository userRepository;
  final dummyUserFactory = DummyUserFactory();

  late UserService service;

  setUpAll(() {
    final store = InMemorySharedPreferencesAsync.empty();
    SharedPreferencesAsyncPlatform.instance = store;
    FlutterSecureStorage.setMockInitialValues({});

    provider = VaultKeychainProvider(
      secureStorage: const FlutterSecureStorage(),
      sharedPreferences: SharedPreferencesAsync(),
      cacheConfig: const CacheConfig(),
    );
    userRepository = UserRepository(SecureUserStorage());
  });

  setUp(() {
    service = UserService(
      keychainProvider: provider,
      userRepository: userRepository,
      dummyUserFactory: dummyUserFactory,
    );
  });

  tearDown(() async {
    await const FlutterSecureStorage().deleteAll();
    await SharedPreferencesAsync().clear();
  });

  group('Keychain', () {
    test('when using keychain getter returns that keychain', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final keychain = await provider.create(keychainId);

      await service.useKeychain(keychain.id);

      // Then
      final currentKeychain = service.keychain;

      expect(currentKeychain?.id, keychain.id);
    });

    test('using different keychain emits update in stream', () async {
      // Given
      final keychainIdOne = const Uuid().v4();
      final keychainIdTwo = const Uuid().v4();

      // When
      final keychainOne = await provider.create(keychainIdOne);
      final keychainTwo = await provider.create(keychainIdTwo);

      final keychainStream = service.watchKeychain;

      // Then
      expect(
        keychainStream,
        emitsInOrder([
          isNull,
          predicate<Keychain>((e) => e.id == keychainOne.id),
          predicate<Keychain>((e) => e.id == keychainTwo.id),
          isNull,
        ]),
      );

      await service.useKeychain(keychainOne.id);
      await service.useKeychain(keychainTwo.id);
      await service.removeCurrentKeychain();

      await service.dispose();
    });

    test('keychains getter returns all initialized local instances', () async {
      // Given
      final ids = List.generate(5, (_) => const Uuid().v4());

      // When
      final keychains = <Keychain>[];
      for (final id in ids) {
        final keychain = await provider.create(id);
        keychains.add(keychain);
      }

      // Then
      final serviceKeychains = await service.keychains;

      expect(serviceKeychains.map((e) => e.id), keychains.map((e) => e.id));
    });
  });

  group('Account', () {
    test('use last account restores previously stored keychain', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final expectedKeychain = await provider.create(keychainId);

      final user = User(
        accounts: [
          Account.dummy(keychainId: expectedKeychain.id),
        ],
        activeKeychainId: expectedKeychain.id,
      );
      await userRepository.saveUser(user);

      await service.useLastAccount();

      // Then
      expect(service.keychain?.id, expectedKeychain.id);
    });

    test('use last account does nothing on clear instance', () async {
      // Given

      // When
      await service.useLastAccount();

      // Then
      expect(service.keychain, isNull);
      expect(service.account, isNull);
    });

    test('remove current account clears current keychain', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final currentKeychain = await provider.create(keychainId);

      final user = User(
        accounts: [
          Account.dummy(keychainId: currentKeychain.id),
        ],
        activeKeychainId: currentKeychain.id,
      );
      await userRepository.saveUser(user);

      await service.useLastAccount();

      // Then
      expect(service.keychain, isNotNull);

      await service.removeCurrentKeychain();

      expect(service.keychain, isNull);
      expect(await currentKeychain.isEmpty, isTrue);
      expect(await provider.exists(keychainId), isFalse);
    });
  });
}
