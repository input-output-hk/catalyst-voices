import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;

/// Represents a seed phrase consisting of a mnemonic and its associated seed.
/// This class provides methods for generating a new seed phrase and creating
/// one from an existing mnemonic.
///
/// The seed phrase is used for cryptographic purposes, such as generating
/// cryptocurrency wallets or secure key management.
class SeedPhrase {
  final String mnemonic;
  final String seed;

  /// Generates a new seed phrase with a random mnemonic
  /// and its corresponding seed.
  SeedPhrase() : this.fromMnemonic(bip39.generateMnemonic());

  /// Creates a SeedPhrase from an existing [mnemonic].
  SeedPhrase.fromMnemonic(this.mnemonic)
      : seed = bip39.mnemonicToSeedHex(mnemonic);

  /// Returns the seed hex string associated with the mnemonic.
  String getSeed() {
    return seed;
  }

  /// Returns the mnemonic phrase.
  String getMnemonic() {
    return mnemonic;
  }
}

class SeedPhraseSerialisation {
  // Encode the seed phrase into a JSON string
  static String encode(SeedPhrase seedPhrase) {
    final data = {
      'mnemonic': seedPhrase.getMnemonic(),
      'seed': seedPhrase.getSeed(),
    };
    return jsonEncode(data);
  }

  // Decode the JSON string back into a SeedPhrase object
  static SeedPhrase decode(String encodedData) {
    final Map<String, dynamic> data = jsonDecode(encodedData);
    final String mnemonic = data['mnemonic'];
    return SeedPhrase.fromMnemonic(mnemonic);
  }
}

class SeedPhraseFactory {
  // Generate a new SeedPhrase
  static SeedPhrase generateNew() {
    return SeedPhrase();
  }

  // Create a SeedPhrase from an existing mnemonic
  static SeedPhrase fromMnemonic(String mnemonic) {
    return SeedPhrase.fromMnemonic(mnemonic);
  }
}
