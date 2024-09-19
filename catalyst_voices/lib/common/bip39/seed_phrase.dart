import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;

class SeedPhrase {
  final String mnemonic;
  final String seed;

  /// Constructor to generate a new seed phrase.
  SeedPhrase()
      : mnemonic = bip39.generateMnemonic(),
        seed = bip39.mnemonicToSeedHex(bip39.generateMnemonic());

  /// Constructor to create a SeedPhrase from an existing mnemonic.
  SeedPhrase.fromMnemonic(this.mnemonic)
      : seed = bip39.mnemonicToSeedHex(mnemonic);

  /// Gets the seed hex.
  String getSeed() {
    return seed;
  }

  /// Gets the mnemonic.
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
