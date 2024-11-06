import 'package:catalyst_voices_services/src/catalyst_voices_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:uuid/uuid.dart';

void main() {
  final KeychainProvider provider = VaultKeychainProvider();
  final UserStorage storage = SecureUserStorage();

  late UserService service;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});

    service = UserService(keychainProvider: provider, userStorage: storage);
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

      expect(currentKeychain, keychain);
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
          keychainOne,
          keychainTwo,
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

      expect(serviceKeychains, keychains);
    });
  });

  group('Account', () {
    test('use last account restores previously stored keychain', () async {
      // Given
      final keychainId = const Uuid().v4();

      // When
      final expectedKeychain = await provider.create(keychainId);

      await storage.setUsedKeychainId(expectedKeychain.id);

      await service.useLastAccount();

      // Then
      expect(service.keychain, expectedKeychain);
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

      await storage.setUsedKeychainId(currentKeychain.id);

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
