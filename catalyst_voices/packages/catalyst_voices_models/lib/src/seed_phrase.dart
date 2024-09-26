// cspell: words wordlists WORDLIST
// ignore_for_file: implementation_imports

import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip39/src/wordlists/english.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:convert/convert.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';

/// Represents a seed phrase consisting of a mnemonic and provides methods for
/// generating and deriving cryptographic data from the mnemonic.
///
/// The `SeedPhrase` class allows creation of a seed phrase either randomly,
/// from a given mnemonic, or from entropy data. It supports converting between
/// different formats, including Uint8List and hex strings.
class SeedPhrase {
  /// The mnemonic phrase
  final String mnemonic;

  /// Generates a new seed phrase with a random mnemonic.
  ///
  /// Throws an [ArgumentError] if the word count is invalid.
  ///
  /// [wordCount]: The number of words in the mnemonic.
  /// The default word count is 12, but can specify 12, 15, 18, 21, or 24 words.
  /// with a higher word count providing greater entropy and security.
  SeedPhrase({int wordCount = 12})
      : this.fromMnemonic(
          bip39.generateMnemonic(
            strength: (wordCount * 32) ~/ 3,
          ),
        );

  /// Creates a SeedPhrase from an existing [Uint8List] entropy.
  ///
  /// [encodedData]: The entropy data as a Uint8List.
  SeedPhrase.fromUint8ListEntropy(Uint8List encodedData)
      : this.fromHexEntropy(hex.encode(encodedData));

  /// Creates a SeedPhrase from an existing hex-encoded entropy.
  ///
  /// [encodedData]: The entropy data as a hex string.
  SeedPhrase.fromHexEntropy(String encodedData)
      : this.fromMnemonic(bip39.entropyToMnemonic(encodedData));

  /// Creates a SeedPhrase from an existing [mnemonic].
  ///
  /// Throws an [ArgumentError] if the mnemonic is invalid.
  ///
  /// [mnemonic]: The mnemonic to derive the seed from.
  SeedPhrase.fromMnemonic(this.mnemonic)
      : assert(bip39.validateMnemonic(mnemonic), 'Invalid mnemonic phrase');

  /// The seed derived from the mnemonic as a Uint8List.
  Uint8List get uint8ListSeed => bip39.mnemonicToSeed(mnemonic);

  /// The seed derived from the mnemonic as a hex-encoded string.
  String get hexSeed => bip39.mnemonicToSeedHex(mnemonic);

  /// The entropy derived from the mnemonic as a Uint8List.
  Uint8List get uint8ListEntropy => Uint8List.fromList(hex.decode(hexEntropy));

  /// The entropy derived from the mnemonic as a hex-encoded string.
  String get hexEntropy => bip39.mnemonicToEntropy(mnemonic);

  /// The mnemonic phrase as a list of individual words.
  List<String> get mnemonicWords => mnemonic.split(' ');

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

  /// The full list of BIP-39 mnemonic words in English.
  static List<String> get wordList => WORDLIST;
}
