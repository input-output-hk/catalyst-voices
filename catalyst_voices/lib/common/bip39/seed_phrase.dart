import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;

/// Represents a seed phrase consisting of a mnemonic and provides methods for
/// generating and deriving cryptographic data from the mnemonic.
///
/// The `SeedPhrase` class allows creation of a seed phrase either randomly,
/// from a given mnemonic, or from entropy data. It supports converting between
/// different formats, including Uint8List and hex strings.
class SeedPhrase {
  final String mnemonic;

  /// Generates a new seed phrase with a random mnemonic
  /// and its corresponding seed.
  SeedPhrase() : this.fromMnemonic(bip39.generateMnemonic());

  /// Creates a SeedPhrase from an existing [Uint8List] entropy.
  ///
  /// [encodedData]: The entropy data as a Uint8List.
  SeedPhrase.fromUint8ListEntropy(Uint8List encodedData)
      : this.fromHexEntropy(_uint8ListToHex(encodedData));

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

  /// Returns the seed derived from the mnemonic as a Uint8List.
  Uint8List getUint8ListSeed() {
    return bip39.mnemonicToSeed(mnemonic);
  }

  /// Returns the seed derived from the mnemonic as a hex-encoded string.
  String getHexSeed() {
    return bip39.mnemonicToSeedHex(mnemonic);
  }

  /// Returns the entropy derived from the mnemonic as a Uint8List.
  Uint8List toUint8ListEntropy() {
    return _hexStringToUint8List(toHexEntropy());
  }

  /// Returns the entropy derived from the mnemonic as a hex-encoded string.
  String toHexEntropy() {
    return bip39.mnemonicToEntropy(mnemonic);
  }

  /// Returns the mnemonic phrase.
  String getMnemonic() {
    return mnemonic;
  }
}

String _uint8ListToHex(Uint8List encodedData) {
  final hexString = StringBuffer();
  for (final byte in encodedData) {
    hexString.write(byte.toRadixString(16).padLeft(2, '0'));
  }
  return hexString.toString();
}

Uint8List _hexStringToUint8List(String hex) {
  if (hex.length % 2 != 0) {
    throw ArgumentError('Hex string must have an even length.');
  }

  return Uint8List.fromList(
    List.generate(
      hex.length ~/ 2,
      (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16),
    ),
  );
}
