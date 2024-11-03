import 'package:catalyst_key_derivation/src/ed25519/ed25519_private_key.dart';
import 'package:catalyst_key_derivation/src/ed25519/ed25519_public_key.dart';
import 'package:cryptography/cryptography.dart';
import 'package:equatable/equatable.dart';

/// The public and private Ed25519 key pair.
final class Ed25519KeyPair extends Equatable {
  /// The public key.
  final Ed25519PublicKey publicKey;

  /// The private key.
  final Ed25519PrivateKey privateKey;

  /// The default constructor for [Ed25519KeyPair].
  const Ed25519KeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  /// Generates a [Ed25519KeyPair] from given private key [seed].
  static Future<Ed25519KeyPair> fromSeed(List<int> seed) async {
    if (seed.length != Ed25519PrivateKey.length) {
      throw ArgumentError(
        'Ed25519KeyPair seed length does not match: ${seed.length}',
      );
    }

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(seed);
    final publicKey = await keyPair.extractPublicKey();
    final privateKey = await keyPair.extractPrivateKeyBytes();

    return Ed25519KeyPair(
      publicKey: Ed25519PublicKey.fromBytes(publicKey.bytes),
      privateKey: Ed25519PrivateKey.fromBytes(privateKey),
    );
  }

  @override
  List<Object?> get props => [publicKey, privateKey];
}
