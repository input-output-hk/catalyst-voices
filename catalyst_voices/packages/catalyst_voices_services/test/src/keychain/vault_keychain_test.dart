import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group(VaultKeychain, () {
    test('is considered empty even with metadata in it', () async {
      // Given
      final id = const Uuid().v4();

      // When
      final vault = VaultKeychain(id: id);

      // Then
      expect(await vault.isEmpty, isTrue);
    });

    test('is not empty when master key is written', () async {
      // Given
      final id = const Uuid().v4();
      const lock = PasswordLockFactor('Test1234');
      final key = Ed25519PrivateKey.fromHex(
        '8a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c',
      );

      // When
      final vault = VaultKeychain(id: id);
      await vault.setLock(lock);
      await vault.unlock(lock);

      // Then
      await vault.setMasterKey(key);
      expect(await vault.isEmpty, isFalse);
    });

    test('metadata is updated after writing master key', () async {
      // Given
      final id = const Uuid().v4();
      const lock = PasswordLockFactor('Test1234');
      final key = Ed25519PrivateKey.fromHex(
        '8a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c',
      );

      // When
      final vault = VaultKeychain(id: id);
      await vault.setLock(lock);
      await vault.unlock(lock);

      // Then
      final metadataBefore = await vault.metadata;
      await vault.setMasterKey(key);
      final metadataAfter = await vault.metadata;

      expect(
        metadataBefore.updatedAt.isBefore(metadataAfter.updatedAt),
        isTrue,
      );
    });

    test('are equal when id is matching', () async {
      // Given
      final id = const Uuid().v4();

      // When
      final vaultOne = VaultKeychain(id: id);
      final vaultTwo = VaultKeychain(id: id);

      // Then
      expect(vaultOne, equals(vaultTwo));
    });

    test('metadata dates are in UTC', () async {
      // Given
      final id = const Uuid().v4();

      // When
      final vault = VaultKeychain(id: id);

      // Then

      final metadata = await vault.metadata;

      expect(metadata.createdAt.isUtc, isTrue);
      expect(metadata.updatedAt.isUtc, isTrue);
    });
  });
}
