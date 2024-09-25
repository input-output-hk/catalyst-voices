import 'dart:typed_data';

import 'package:catalyst_voices_models/src/seed_phrase.dart';
import 'package:convert/convert.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';

class Ed25519KeyPair {
  final SeedPhrase seedPhrase;
  final Uint8List privateKey;
  final Uint8List publicKey;

  static Future<Ed25519KeyPair> generateKeyPair(SeedPhrase seedPhrase) async {
    // Derive the private key using the Ed25519 HD key derivation
    final masterKey =
        await ED25519_HD_KEY.getMasterKeyFromSeed(seedPhrase.uint8ListSeed);
    final privateKey = Uint8List.fromList(masterKey.key);

    // Generate the matching public key
    final publicKey = Uint8List.fromList(
      await ED25519_HD_KEY.getPublicKey(privateKey, false),
    );

    return Ed25519KeyPair._(seedPhrase, privateKey, publicKey);
  }

  Ed25519KeyPair._(this.seedPhrase, this.privateKey, this.publicKey);

  /// The private key in hex format
  String get hexPrivateKey => hex.encode(privateKey);

  /// The public key in hex format
  String get hexPublicKey => hex.encode(publicKey);
}
