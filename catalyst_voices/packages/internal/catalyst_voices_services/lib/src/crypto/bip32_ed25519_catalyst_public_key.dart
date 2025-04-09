import 'dart:typed_data';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class Bip32Ed25519XCatalystPublicKey extends Equatable
    implements CatalystPublicKey {
  final Bip32Ed25519XPublicKey _publicKey;

  const Bip32Ed25519XCatalystPublicKey(this._publicKey);

  @override
  Uint8List get bytes => Uint8List.fromList(_publicKey.bytes);

  @override
  List<Object?> get props => [_publicKey];

  @override
  Uint8List get publicKeyBytes =>
      Uint8List.fromList(_publicKey.toPublicKey().bytes);

  @override
  Future<bool> verify(Uint8List data, {required CatalystSignature signature}) {
    final bip32Signature = Bip32Ed25519XSignatureFactory.instance.fromBytes(
      signature.bytes,
    );

    return _publicKey.verify(data, signature: bip32Signature);
  }
}

final class Bip32Ed25519XCatalystPublicKeyFactory
    implements CatalystPublicKeyFactory {
  const Bip32Ed25519XCatalystPublicKeyFactory();

  @override
  CatalystPublicKey create(Uint8List bytes) {
    final publicKey = Bip32Ed25519XPublicKeyFactory.instance.fromBytes(bytes);
    return Bip32Ed25519XCatalystPublicKey(publicKey);
  }
}
