import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:mocktail/mocktail.dart';

class FakeBip32Ed25519XPrivateKey extends Fake implements Bip32Ed25519XPrivateKey {
  @override
  final List<int> bytes;

  final Bip32Ed25519XSignature? customSignature;

  FakeBip32Ed25519XPrivateKey(this.bytes, {this.customSignature});

  @override
  Future<Bip32Ed25519XSignature> sign(List<int> message) async {
    if (customSignature != null) {
      return customSignature!;
    }
    return FakeBip32Ed25519XSignature([
      ...message.take(32),
      ...List.filled(32, 0),
    ]);
  }

  @override
  Future<R> use<R>(
    Future<R> Function(Bip32Ed25519XPrivateKey key) callback,
  ) async {
    return callback(this);
  }

  @override
  Future<bool> verify(
    List<int> message, {
    required Bip32Ed25519XSignature signature,
  }) async {
    return true;
  }
}

class FakeBip32Ed25519XPrivateKeyFactory extends Bip32Ed25519XPrivateKeyFactory {
  @override
  Bip32Ed25519XPrivateKey fromBytes(List<int> bytes) {
    return FakeBip32Ed25519XPrivateKey(bytes);
  }
}

class FakeBip32Ed25519XPublicKey extends Fake implements Bip32Ed25519XPublicKey {
  @override
  final List<int> bytes;

  FakeBip32Ed25519XPublicKey(this.bytes);

  @override
  Ed25519PublicKey toPublicKey() => Ed25519PublicKey.fromBytes(
    bytes.take(Ed25519PrivateKey.length).toList(),
  );
}

class FakeBip32Ed25519XPublicKeyFactory extends Bip32Ed25519XPublicKeyFactory {
  @override
  Bip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return FakeBip32Ed25519XPublicKey(bytes);
  }
}

class FakeBip32Ed25519XSignature extends Fake implements Bip32Ed25519XSignature {
  @override
  final List<int> bytes;

  FakeBip32Ed25519XSignature(this.bytes);

  @override
  CborValue toCbor() => CborBytes(bytes);
}

class FakeBip32Ed25519XSignatureFactory extends Bip32Ed25519XSignatureFactory {
  @override
  Bip32Ed25519XSignature fromBytes(List<int> bytes) {
    return FakeBip32Ed25519XSignature(bytes);
  }
}
