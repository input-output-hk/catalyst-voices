import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';

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
  SeedPhrase() : this.fromMnemonic(bip39.generateMnemonic());

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
}
