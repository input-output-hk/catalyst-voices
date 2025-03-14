import 'dart:async';

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

  /// Clears the private key.
  void drop() {
    privateKey.drop();
  }
}

extension FutureCatalystKeyPairExt on Future<CatalystKeyPair?> {
  /// Calls the [callback] on the key pair
  /// and then drops the private key bytes.
  Future<R> use<R>(FutureOr<R> Function(CatalystKeyPair) callback) async {
    final keyPair = await this;
    if (keyPair == null) {
      throw StateError("Cannot use key pair, it's not provided.");
    }

    try {
      final result = await callback(keyPair);
      
      assert(
        result is! CatalystKeyPair,
        'After the callback is called the key pair will '
        'be destroyed therefore it is not safe to return it',
      );

      assert(
        result is! CatalystPrivateKey,
        'After the callback is called the private key will '
        'be destroyed therefore it is not safe to return it',
      );

      return result;
    } finally {
      keyPair.drop();
    }
  }
}
