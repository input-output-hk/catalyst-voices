import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';

class FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  final CatalystSignature? signature;

  @override
  final Uint8List bytes;

  FakeCatalystPrivateKey({Uint8List? bytes, this.signature}) : bytes = bytes ?? Uint8List(0);

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

  @override
  Future<CatalystSignature> sign(Uint8List data) async {
    return signature ?? FakeCatalystSignature(bytes: data);
  }
}

class FakeCatalystPrivateKeyFactory extends Fake implements CatalystPrivateKeyFactory {
  @override
  CatalystPrivateKey create(Uint8List bytes) {
    return FakeCatalystPrivateKey(bytes: bytes);
  }
}

class FakeCatalystPublicKey extends Fake implements CatalystPublicKey {
  final Uint8List _signatureBytes;
  @override
  final Uint8List bytes;

  FakeCatalystPublicKey({
    Uint8List? bytes,
    Uint8List? signatureBytes,
  }) : bytes = bytes ?? Uint8List(0),
       _signatureBytes = signatureBytes ?? Uint8List.fromList(List.filled(32, 2));

  @override
  Uint8List get publicKeyBytes => bytes;

  @override
  Future<bool> verify(
    Uint8List data, {
    required CatalystSignature signature,
  }) async {
    return listEquals(signature.bytes, _signatureBytes);
  }
}

class FakeCatalystPublicKeyFactory extends Fake implements CatalystPublicKeyFactory {
  @override
  CatalystPublicKey create(Uint8List bytes) {
    return FakeCatalystPublicKey(bytes: bytes);
  }
}

class FakeCatalystSignature extends Fake implements CatalystSignature {
  @override
  final Uint8List bytes;

  FakeCatalystSignature({Uint8List? bytes}) : bytes = bytes ?? Uint8List(0);
}

class FakeCatalystSignatureFactory extends Fake implements CatalystSignatureFactory {
  @override
  CatalystSignature create(Uint8List bytes) {
    return FakeCatalystSignature(bytes: bytes);
  }
}
