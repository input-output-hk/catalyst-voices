import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation.dart';
import 'package:test/test.dart';

void main() {
  group(KeyDerivation, () {
    late KeyDerivation keyDerivation;
    late SeedPhrase seedPhrase;

    setUp(() {
      keyDerivation = const KeyDerivation();
      seedPhrase = SeedPhrase.fromMnemonic(
        'few loyal swift champion rug peace dinosaur'
        ' erase bacon tone install universe',
      );
    });

    test('should generate key pair with different valid paths', () async {
      for (final role in AccountRole.values) {
        final keyPair = await keyDerivation.deriveKeyPair(
          seedPhrase: seedPhrase,
          path: "m/${role.roleNumber}'/1234'",
        );
        expect(keyPair, isNotNull);
      }
    });

    test('should generate key pair with different valid roles', () async {
      for (final role in AccountRole.values) {
        final keyPair = await keyDerivation.deriveAccountRoleKeyPair(
          seedPhrase: seedPhrase,
          role: role,
        );
        expect(keyPair, isNotNull);
      }
    });
  });
}
