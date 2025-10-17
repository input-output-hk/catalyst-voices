/// Fake implementations of Bip32Ed25519 cryptographic interfaces for testing.
///
/// These fakes provide simple, predictable implementations that can be used
/// across all test suites without duplicating code.
library;

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' as kd;
import 'package:cbor/cbor.dart';
import 'package:flutter_test/flutter_test.dart';

/// A fake implementation of [kd.Bip32Ed25519XPrivateKey] for testing.
///
/// This fake returns predictable signatures based on the message being signed.
/// The signature is constructed from the first 32 bytes of the message
/// followed by 32 zero bytes.
class FakeBip32Ed25519XPrivateKey extends Fake implements kd.Bip32Ed25519XPrivateKey {
  @override
  final List<int> bytes;

  /// Creates a fake private key with the given [bytes].
  FakeBip32Ed25519XPrivateKey(this.bytes);

  @override
  Future<kd.Bip32Ed25519XSignature> sign(List<int> message) async {
    return FakeBip32Ed25519XSignature([
      ...message.take(32),
      ...List.filled(32, 0),
    ]);
  }

  @override
  Future<R> use<R>(
    Future<R> Function(kd.Bip32Ed25519XPrivateKey key) callback,
  ) async {
    return callback(this);
  }
}

/// A fake factory for creating [FakeBip32Ed25519XPrivateKey] instances.
class FakeBip32Ed25519XPrivateKeyFactory extends kd.Bip32Ed25519XPrivateKeyFactory {
  @override
  kd.Bip32Ed25519XPrivateKey fromBytes(List<int> bytes) {
    return FakeBip32Ed25519XPrivateKey(bytes);
  }
}

/// A fake implementation of [kd.Bip32Ed25519XPublicKey] for testing.
///
/// This fake uses the provided bytes and can convert to [kd.Ed25519PublicKey].
class FakeBip32Ed25519XPublicKey extends Fake implements kd.Bip32Ed25519XPublicKey {
  @override
  final List<int> bytes;

  /// Creates a fake public key with the given [bytes].
  FakeBip32Ed25519XPublicKey(this.bytes);

  @override
  kd.Ed25519PublicKey toPublicKey() => kd.Ed25519PublicKey.fromBytes(
    bytes.take(kd.Ed25519PrivateKey.length).toList(),
  );
}

/// A fake factory for creating [FakeBip32Ed25519XPublicKey] instances.
class FakeBip32Ed25519XPublicKeyFactory extends kd.Bip32Ed25519XPublicKeyFactory {
  @override
  kd.Bip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return FakeBip32Ed25519XPublicKey(bytes);
  }
}

/// A fake implementation of [kd.Bip32Ed25519XSignature] for testing.
///
/// This fake uses the provided bytes and can serialize to CBOR.
class FakeBip32Ed25519XSignature extends Fake implements kd.Bip32Ed25519XSignature {
  @override
  final List<int> bytes;

  /// Creates a fake signature with the given [bytes].
  FakeBip32Ed25519XSignature(this.bytes);

  @override
  CborValue toCbor() => CborBytes(bytes);
}

/// A fake factory for creating [FakeBip32Ed25519XSignature] instances.
class FakeBip32Ed25519XSignatureFactory extends kd.Bip32Ed25519XSignatureFactory {
  @override
  kd.Bip32Ed25519XSignature fromBytes(List<int> bytes) {
    return FakeBip32Ed25519XSignature(bytes);
  }
}
