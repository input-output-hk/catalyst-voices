import 'package:bip39/bip39.dart' as bip39;
import 'package:catalyst_voices_models/src/seed_phrase.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(SeedPhrase, () {
    test('should generate a new SeedPhrase with random mnemonic', () {
      final seedPhrase = SeedPhrase();
      expect(seedPhrase.mnemonic, isNotEmpty);
      expect(seedPhrase.uint8ListSeed, isNotEmpty);
      expect(seedPhrase.hexSeed, isNotEmpty);
      expect(seedPhrase.mnemonicWords.length, 12);
    });

    test('should generate a seed phrase with 12, 15, 18, 21, and 24 words', () {
      for (final wordCount in [12, 15, 18, 21, 24]) {
        final seedPhrase = SeedPhrase(wordCount: wordCount);
        expect(seedPhrase.mnemonicWords.length, wordCount);
        expect(bip39.validateMnemonic(seedPhrase.mnemonic), isTrue);
      }
    });

    test('should throw an error for an invalid word count', () {
      expect(() => SeedPhrase(wordCount: 9), throwsA(isA<ArgumentError>()));
      expect(() => SeedPhrase(wordCount: 13), throwsA(isA<AssertionError>()));
      expect(() => SeedPhrase(wordCount: 27), throwsA(isA<ArgumentError>()));
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
      final words = seedPhrase.mnemonicWords.map((e) => e.data).toList();
      expect(words, expectedWords);
    });

    test('should generate key pair with different valid offsets', () async {
      for (final offset in [0, 4, 28, 32, 64]) {
        final keyPair = await SeedPhrase().deriveKeyPair(offset);

        expect(keyPair, isNotNull);
      }
    });

    test('should throw an error for key pair with out of range offset',
        () async {
      for (final offset in [-1, 65]) {
        expect(
          () async => SeedPhrase().deriveKeyPair(offset),
          throwsA(isA<RangeError>()),
        );
      }
    });

    test('toString should return hashed mnemonic', () {
      final seedPhrase = SeedPhrase();
      final mnemonic = seedPhrase.mnemonic;

      final asString = seedPhrase.toString();

      expect(asString, isNot(contains(mnemonic)));
    });

    test('mnemonic words should be sorted', () {
      final mnemonic = bip39.generateMnemonic();
      final seedPhrase = SeedPhrase.fromMnemonic(mnemonic);
      expect(seedPhrase.mnemonicWords.isSorted(), isTrue);
    });
  });
}
