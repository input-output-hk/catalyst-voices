import 'package:catalyst_voices_models/src/crypto/catalyst_private_key.dart';
import 'package:catalyst_voices_models/src/crypto/catalyst_public_key.dart';
import 'package:equatable/equatable.dart';

/// The public and private key pair.
final class CatalystKeyPair extends Equatable {
  /// The public key.
  final CatalystPublicKey publicKey;

  /// The private key.
  final CatalystPrivateKey privateKey;

  /// The default constructor for [CatalystKeyPair].
  const CatalystKeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  @override
  List<Object?> get props => [publicKey, privateKey];
}
