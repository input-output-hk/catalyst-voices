import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/keychain/key_derivation_service.dart';
import 'package:test/test.dart';

void main() {
  group(KeyDerivationService, () {
    late KeyDerivationService service;
    late SeedPhrase seedPhrase;

    setUp(() {
      service = KeyDerivationService();
      seedPhrase = SeedPhrase.fromMnemonic(
        'few loyal swift champion rug peace dinosaur'
        ' erase bacon tone install universe',
      );
    });

    test('should generate key pair with different valid paths', () async {
      for (final role in AccountRole.values) {
        final keyPair = await service.deriveKeyPair(
          seedPhrase: seedPhrase,
          path: "m/${role.roleNumber}'/1234'",
        );
        expect(keyPair, isNotNull);
      }
    });

    test('should generate key pair with different valid roles', () async {
      for (final role in AccountRole.values) {
        final keyPair = await service.deriveAccountRoleKeyPair(
          seedPhrase: seedPhrase,
          role: role,
        );
        expect(keyPair, isNotNull);
      }
    });
  });
}
