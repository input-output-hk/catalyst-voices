/// Fake implementations of Catalyst cryptographic interfaces for testing.
///
/// These fakes provide simple, predictable implementations that can be used
/// across all test suites without duplicating code.
library;

import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';

/// A fake implementation of [CatalystPrivateKey] for testing.
///
/// This fake returns predictable derived keys and public keys based on the
/// input bytes and derivation paths.
class FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  @override
  final Uint8List bytes;

  /// Creates a fake private key with the given [bytes].
  FakeCatalystPrivateKey({required this.bytes});

  @override
  CatalystSignatureAlgorithm get algorithm => CatalystSignatureAlgorithm.ed25519;

  @override
  Future<CatalystPrivateKey> derivePrivateKey({
    required String path,
  }) async {
    return FakeCatalystPrivateKey(bytes: Uint8List.fromList(path.codeUnits));
  }

  @override
  Future<CatalystPublicKey> derivePublicKey() async {
    return FakeCatalystPublicKey(bytes: bytes);
  }

  @override
  void drop() {}
}

/// A fake factory for creating [FakeCatalystPrivateKey] instances.
class FakeCatalystPrivateKeyFactory extends Fake implements CatalystPrivateKeyFactory {
  @override
  CatalystPrivateKey create(Uint8List bytes) {
    return FakeCatalystPrivateKey(bytes: bytes);
  }
}

/// A fake implementation of [CatalystPublicKey] for testing.
///
/// This fake uses the provided bytes for the public key representation.
class FakeCatalystPublicKey extends Fake implements CatalystPublicKey {
  @override
  final Uint8List bytes;

  /// Creates a fake public key with the given [bytes].
  FakeCatalystPublicKey({required this.bytes});

  @override
  Uint8List get publicKeyBytes => bytes;
}

/// A fake factory for creating [FakeCatalystPublicKey] instances.
class FakeCatalystPublicKeyFactory extends Fake implements CatalystPublicKeyFactory {
  @override
  CatalystPublicKey create(Uint8List bytes) {
    return FakeCatalystPublicKey(bytes: bytes);
  }
}

/// A fake implementation of [CatalystSignature] for testing.
///
/// This fake uses the provided bytes for the signature representation.
class FakeCatalystSignature extends Fake implements CatalystSignature {
  @override
  final Uint8List bytes;

  /// Creates a fake signature with the given [bytes].
  FakeCatalystSignature({required this.bytes});
}

/// A fake factory for creating [FakeCatalystSignature] instances.
class FakeCatalystSignatureFactory extends Fake implements CatalystSignatureFactory {
  @override
  CatalystSignature create(Uint8List bytes) {
    return FakeCatalystSignature(bytes: bytes);
  }
}
