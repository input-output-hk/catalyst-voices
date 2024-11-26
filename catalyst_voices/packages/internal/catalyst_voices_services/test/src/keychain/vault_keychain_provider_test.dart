import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/keychain/vault_keychain_provider.dart';
import 'package:convert/convert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  final provider = VaultKeychainProvider();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group(VaultKeychainProvider, () {
    test('create returns empty keychain', () async {
      // Given
      final id = const Uuid().v4();

      // When
      final keychain = await provider.create(id);

      // Then
      expect(await provider.exists(id), isTrue);
      expect([keychain], await provider.getAll());
    });

    test('calling create twice on keychain will empty previous data', () async {
      // Given
      final id = const Uuid().v4();
      const lockFactor = PasswordLockFactor('Test1234');
      final key = _FakeBip32Ed22519XPrivateKey(
        bytes: hex.decode(
          '8a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c',
        ),
      );

      // When
      var keychain = await provider.create(id);
      await keychain.setLock(lockFactor);
      await keychain.unlock(lockFactor);
      await keychain.setMasterKey(key);

      // Then
      expect(await keychain.isUnlocked, isTrue);
      expect(await keychain.isEmpty, isFalse);

      keychain = await provider.create(id);

      expect(await keychain.isUnlocked, isFalse);
      expect(await keychain.isEmpty, isTrue);
    });

    test('exists returns false when storage is empty', () async {
      // Given
      final id = const Uuid().v4();

      // When

      // Then
      expect(await provider.exists(id), isFalse);
    });

    test('exists returns true for existing keychain', () async {
      // Given
      final id = const Uuid().v4();

      // When
      await provider.create(id);

      // Then
      expect(await provider.exists(id), isTrue);
    });

    test(
      'exists returns false when multiple keychains exits but none matches id',
      () async {
        // Given
        final id = const Uuid().v4();
        final existsIds = List.generate(2, (_) => const Uuid().v4());

        // When
        for (final id in existsIds) {
          await provider.create(id);
        }

        // Then
        expect(await provider.exists(id), isFalse);
      },
    );

    test('getAll returns keychains without duplicates', () async {
      // Given
      final ids = List.generate(2, (_) => const Uuid().v4());

      // When
      for (final id in ids) {
        await provider.create(id);
      }

      // Then
      final keychains = await provider.getAll();
      expect(keychains.length, ids.length);
      expect(keychains.map((e) => e.id), containsAll(ids));
    });
  });
}

class _FakeBip32Ed22519XPrivateKey extends Fake
    implements Bip32Ed25519XPrivateKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed22519XPrivateKey({required this.bytes});

  @override
  String toHex() => hex.encode(bytes);
}
