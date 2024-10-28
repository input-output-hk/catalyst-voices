import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group(KeychainToUnlockTransformer, () {
    test('emits keychain unlock stage changes when keychain is set', () async {
      // Given
      final keychain = VaultKeychain(id: 'id');
      const lockFactor = PasswordLockFactor('Test1234');
      final keychainSC = StreamController<Keychain?>.broadcast();

      // When
      await keychain.setLock(lockFactor);

      // Then
      expect(
        keychainSC.stream.transform(KeychainToUnlockTransformer()),
        emitsInOrder([
          false,
          true,
          false,
          emitsDone,
        ]),
      );

      keychainSC.add(keychain);

      await keychain.unlock(lockFactor);
      await keychain.lock();

      await keychainSC.close();
    });

    test('emits false when keychain is not emitted', () async {
      // Given
      final keychainSC = StreamController<Keychain?>.broadcast();

      // When

      // Then
      expect(
        keychainSC.stream.transform(KeychainToUnlockTransformer()),
        emitsInOrder([
          false,
          emitsDone,
        ]),
      );

      keychainSC.add(null);

      await keychainSC.close();
    });
  });
}
