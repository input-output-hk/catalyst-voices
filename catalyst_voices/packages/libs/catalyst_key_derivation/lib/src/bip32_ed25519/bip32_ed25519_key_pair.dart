import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_private_key.dart';
import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_public_key.dart';
import 'package:equatable/equatable.dart';

/// The public and private BIP-32 Ed25519 extended key pair.
class Bip32Ed25519XKeyPair extends Equatable {
  /// The public key.
  final Bip32Ed25519XPublicKey publicKey;

  /// The private key.
  final Bip32Ed25519XPrivateKey privateKey;

  /// The default constructor for [Bip32Ed25519XKeyPair].
  const Bip32Ed25519XKeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  @override
  List<Object?> get props => [publicKey, privateKey];
}
