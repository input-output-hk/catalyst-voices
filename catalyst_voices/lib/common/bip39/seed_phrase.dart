import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;

/// Represents a seed phrase consisting of a mnemonic and its associated seed.
/// This class provides methods for generating a new seed phrase and creating
/// one from an existing mnemonic.
///
/// The seed phrase is used for cryptographic purposes, such as generating
/// cryptocurrency wallets or secure key management.
class SeedPhrase {
  final String mnemonic;

  /// Generates a new seed phrase with a random mnemonic
  /// and its corresponding seed.
  SeedPhrase() : this.fromMnemonic(bip39.generateMnemonic());

  SeedPhrase.fromUint8ListEntropy(Uint8List encodedData)
      : this.fromHexEntropy(_uint8ListToHex(encodedData));

  SeedPhrase.fromHexEntropy(String encodedData)
      : this.fromMnemonic(bip39.entropyToMnemonic(encodedData));

  /// Creates a SeedPhrase from an existing [mnemonic].
  ///
  /// Throws an [ArgumentError] if the mnemonic is invalid.
  ///
  /// [mnemonic]: The mnemonic to derive the seed from.
  SeedPhrase.fromMnemonic(this.mnemonic)
      : assert(bip39.validateMnemonic(mnemonic), 'Invalid mnemonic phrase');

  /// Returns the seed hex string associated with the mnemonic.
  Uint8List getUint8ListSeed() {
    return bip39.mnemonicToSeed(mnemonic);
  }

  String getHexSeed() {
    return bip39.mnemonicToSeedHex(mnemonic);
  }

  /// Returns the mnemonic phrase.
  String getMnemonic() {
    return mnemonic;
  }

  Uint8List toUint8ListEntropy() {
    return _hexStringToUint8List(toHexEntropy());
  }

  String toHexEntropy() {
    return bip39.mnemonicToEntropy(mnemonic);
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
