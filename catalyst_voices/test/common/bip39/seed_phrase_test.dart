import 'package:bip39/bip39.dart' as bip39;
import 'package:catalyst_voices/common/bip39/seed_phrase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(SeedPhrase, () {
    test('should generate a new SeedPhrase with random mnemonic', () {
      final seedPhrase = SeedPhrase();
      expect(seedPhrase.mnemonic, isNotEmpty);
      expect(seedPhrase.uint8ListSeed, isNotEmpty);
      expect(seedPhrase.hexSeed, isNotEmpty);
    });

    test('should create SeedPhrase from a valid mnemonic', () {
      final validMnemonic = bip39.generateMnemonic();
      final seedPhrase = SeedPhrase.fromMnemonic(validMnemonic);
      expect(seedPhrase.mnemonic, validMnemonic);
      expect(seedPhrase.hexSeed, bip39.mnemonicToSeedHex(validMnemonic));
    });

    test('should create SeedPhrase from hex-encoded entropy', () {
      final entropy = bip39.mnemonicToEntropy(bip39.generateMnemonic());
      final seedPhrase = SeedPhrase.fromHexEntropy(entropy);

      expect(seedPhrase.mnemonic, isNotEmpty);
      expect(seedPhrase.hexEntropy, entropy);
    });

    test('should throw an error for invalid mnemonic', () {
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

    test('should contain consistent mnemonic and seed in generated SeedPhrase',
        () {
      final seedPhrase = SeedPhrase();
      final mnemonic = seedPhrase.mnemonic;
      final seed = seedPhrase.hexSeed;

      expect(bip39.mnemonicToSeedHex(mnemonic), seed);
    });

    test('should split mnemonic into a list of words', () {
      final mnemonic = bip39.generateMnemonic();
      final seedPhrase = SeedPhrase.fromMnemonic(mnemonic);
      final expectedWords = mnemonic.split(' ');
      expect(seedPhrase.mnemonicWords, expectedWords);
    });
  });
}
