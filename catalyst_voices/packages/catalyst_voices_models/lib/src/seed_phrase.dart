// cspell: words wordlists WORDLIST
// ignore_for_file: implementation_imports

import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip39/src/wordlists/english.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:equatable/equatable.dart';

/// Represent singular mnemonic words which keeps data as well as index of
/// this word.
///
/// This is useful because seed phrase may have duplicate words. With this
/// structure we can distinguish which word is which.
final class SeedPhraseWord extends Equatable
    implements Comparable<SeedPhraseWord> {
  /// Word value.
  final String data;

  /// Number of this word in [SeedPhrase].
  final int nr;

  const SeedPhraseWord(
    this.data, {
    required this.nr,
  });

  @override
  List<Object?> get props => [data, nr];

  @override
  int compareTo(SeedPhraseWord other) => nr.compareTo(other.nr);
}

/// Represents a seed phrase consisting of a mnemonic and provides methods for
/// generating and deriving cryptographic data from the mnemonic.
///
/// The `SeedPhrase` class allows creation of a seed phrase either randomly,
/// from a given mnemonic, or from entropy data. It supports converting between
/// different formats, including Uint8List and hex strings.
final class SeedPhrase extends Equatable {
  /// The mnemonic phrase
  final String mnemonic;

  /// Generates a new seed phrase with a random mnemonic.
  ///
  /// Throws an [ArgumentError] if the word count is invalid.
  ///
  /// [wordCount]: The number of words in the mnemonic.
  /// The default word count is 12, but can specify 12, 15, 18, 21, or 24 words.
  /// with a higher word count providing greater entropy and security.
  factory SeedPhrase({int wordCount = 12}) {
    final mnemonic = bip39.generateMnemonic(
      strength: (wordCount * 32) ~/ 3,
    );

    return SeedPhrase.fromMnemonic(mnemonic);
  }

  /// Private const constructor
  const SeedPhrase._({
    required this.mnemonic,
  });

  /// Creates a SeedPhrase from an existing [Uint8List] entropy.
  ///
  /// [encodedData]: The entropy data as a Uint8List.
  factory SeedPhrase.fromUint8ListEntropy(Uint8List encodedData) {
    final hexEncodedData = hex.encode(encodedData);
    return SeedPhrase.fromHexEntropy(hexEncodedData);
  }

  /// Creates a SeedPhrase from an existing hex-encoded entropy.
  ///
  /// [encodedData]: The entropy data as a hex string.
  factory SeedPhrase.fromHexEntropy(String encodedData) {
    final mnemonic = bip39.entropyToMnemonic(encodedData);
    return SeedPhrase.fromMnemonic(mnemonic);
  }

  /// Creates a SeedPhrase from an existing [mnemonic].
  ///
  /// Throws an [ArgumentError] if the mnemonic is invalid.
  ///
  /// [mnemonic]: The mnemonic to derive the seed from.
  factory SeedPhrase.fromMnemonic(String mnemonic) {
    assert(bip39.validateMnemonic(mnemonic), 'Invalid mnemonic phrase');

    return SeedPhrase._(mnemonic: mnemonic);
  }

  /// Builds [mnemonic] from [words] and calls [SeedPhrase.fromMnemonic]
  /// with result.
  factory SeedPhrase.fromWords(List<SeedPhraseWord> words) {
    assert(words.isSorted(), 'words list has incorrect order');

    final mnemonic = words.map((e) => e.data).join(' ');

    return SeedPhrase.fromMnemonic(mnemonic);
  }

  /// The full list of BIP-39 mnemonic words in English.
  static List<String> get wordList => WORDLIST;

  /// Utility method that validates given [words] as [SeedPhrase] data.
  static bool isValid({
    required List<SeedPhraseWord> words,
  }) {
    final mnemonic = words.map((e) => e.data).join(' ');
    return bip39.validateMnemonic(mnemonic);
  }

  /// The seed derived from the mnemonic as a Uint8List.
  Uint8List get uint8ListSeed => bip39.mnemonicToSeed(mnemonic);

  /// The seed derived from the mnemonic as a hex-encoded string.
  String get hexSeed => bip39.mnemonicToSeedHex(mnemonic);

  /// The entropy derived from the mnemonic as a Uint8List.
  Uint8List get uint8ListEntropy => Uint8List.fromList(hex.decode(hexEntropy));

  /// The entropy derived from the mnemonic as a hex-encoded string.
  String get hexEntropy => bip39.mnemonicToEntropy(mnemonic);

  /// The mnemonic phrase as a list of individual words.
  List<SeedPhraseWord> get mnemonicWords => mnemonic
      .split(' ')
      .mapIndexed((index, element) => SeedPhraseWord(element, nr: index + 1))
      .toList();

  /// Version of [mnemonicWords] but in random order. Each call will generate
  /// new random order.
  List<SeedPhraseWord> get shuffledMnemonicWords {
    return [...mnemonicWords]..shuffle();
  }

  /// Derives an Ed25519 key pair from a seed.
  ///
  /// Throws a [RangeError] If the provided [offset] is negative or exceeds
  /// the length of the seed (64).
  ///
  /// [offset]: The offset is applied
  /// to the seed to adjust where key derivation starts. It defaults to 0.
  Future<Ed25519KeyPair> deriveKeyPair([int offset = 0]) async {
    final modifiedSeed = uint8ListSeed.sublist(offset);

    final masterKey = await ED25519_HD_KEY.getMasterKeyFromSeed(modifiedSeed);
    final privateKey = masterKey.key;

    final publicKey = await ED25519_HD_KEY.getPublicKey(privateKey, false);

    return Ed25519KeyPair(
      publicKey: Ed25519PublicKey.fromBytes(publicKey),
      privateKey: Ed25519PrivateKey.fromBytes(privateKey),
    );
  }

  @override
  String toString() => 'SeedPhrase(${mnemonic.hashCode})';

  @override
  List<Object?> get props => [mnemonic];
}
