import 'package:bip39/bip39.dart' as bip39;
import 'package:catalyst_voices/common/bip39/seed_phrase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(SeedPhrase, () {
    test('should generate a new SeedPhrase with random mnemonic', () {
      final seedPhrase = SeedPhrase();
      expect(seedPhrase.getMnemonic(), isNotEmpty);
      expect(seedPhrase.getUint8ListSeed(), isNotEmpty);
      expect(seedPhrase.getHexSeed(), isNotEmpty);
    });

    test('should create SeedPhrase from a valid mnemonic', () {
      final validMnemonic = bip39.generateMnemonic();
      final seedPhrase = SeedPhrase.fromMnemonic(validMnemonic);
      expect(seedPhrase.getMnemonic(), validMnemonic);
      expect(seedPhrase.getHexSeed(), bip39.mnemonicToSeedHex(validMnemonic));
    });

    test('should create SeedPhrase from hex-encoded entropy', () {
      final entropy = bip39.mnemonicToEntropy(bip39.generateMnemonic());
      final seedPhrase = SeedPhrase.fromHexEntropy(entropy);

      expect(seedPhrase.getMnemonic(), isNotEmpty);
      expect(seedPhrase.toHexEntropy(), entropy);
    });

    test('expect invalid mnemonic throws an error', () {
      const invalidMnemonic = 'invalid mnemonic phrase';
      expect(
        () => SeedPhrase.fromMnemonic(invalidMnemonic),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            contains('Invalid mnemonic phrase'),
          ),
        ),
      );
    });

    test('should generated SeedPhrase contains consistent mnemonic and seed',
        () {
      final seedPhrase = SeedPhrase();
      final mnemonic = seedPhrase.getMnemonic();
      final seed = seedPhrase.getHexSeed();

      expect(bip39.mnemonicToSeedHex(mnemonic), seed);
    });
  });
}
