import 'package:catalyst_key_derivation/src/ed25519_extended/ed25519_extended_private_key.dart';
import 'package:catalyst_key_derivation/src/ed25519_extended/ed25519_extended_public_key.dart';
import 'package:equatable/equatable.dart';

/// The public and private Ed25519 extended key pair.
class Ed25519ExtendedKeyPair extends Equatable {
  /// The public key.
  final Ed25519ExtendedPublicKey publicKey;

  /// The private key.
  final Ed25519ExtendedPrivateKey privateKey;

  /// The default constructor for [Ed25519ExtendedKeyPair].
  const Ed25519ExtendedKeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  @override
  List<Object?> get props => [publicKey, privateKey];
}
