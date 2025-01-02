import 'dart:convert';

import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_shared/src/document/signed_document_manager.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final _privateKey = Uint8List.fromList(List.filled(32, 0));
final _publicKey = Uint8List.fromList(List.filled(32, 1));
final _signature = Uint8List.fromList(List.filled(32, 2));

void main() {
  group(SignedDocumentManager, () {
    const documentManager = SignedDocumentManager();

    setUpAll(() {
      CatalystCompressionPlatform.instance = _FakeCatalystCompressionPlatform();

      Bip32Ed25519XPublicKeyFactory.instance =
          _FakeBip32Ed25519XPublicKeyFactory();

      Bip32Ed25519XPrivateKeyFactory.instance =
          _FakeBip32Ed25519XPrivateKeyFactory();

      Bip32Ed25519XSignatureFactory.instance =
          _FakeBip32Ed25519XSignatureFactory();
    });

    test(
        'signDocument creates a signed document '
        'that can be converted from/to bytes', () async {
      const document = _JsonDocument('title');

      final signedDocument = await documentManager.signDocument(
        document,
        publicKey: _publicKey,
        privateKey: _privateKey,
      );

      expect(signedDocument.payload, equals(document));

      final isVerified = await signedDocument.verifySignature(_publicKey);
      expect(isVerified, isTrue);

      final signedDocumentBytes = signedDocument.toBytes();
      final parsedDocument = await documentManager.parseDocument(
        signedDocumentBytes,
        parser: _JsonDocument.fromBytes,
      );

      expect(parsedDocument, equals(signedDocument));
    });
  });
}

final class _JsonDocument extends Equatable implements SignedDocumentPayload {
  final String title;

  const _JsonDocument(this.title);

  factory _JsonDocument.fromBytes(Uint8List bytes) {
    final string = utf8.decode(bytes);
    final map = json.decode(string);
    return _JsonDocument.fromJson(map as Map<String, dynamic>);
  }

  factory _JsonDocument.fromJson(Map<String, dynamic> map) {
    return _JsonDocument(map['title'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'title': title};
  }

  @override
  Uint8List toBytes() {
    final jsonString = json.encode(toJson());
    return utf8.encode(jsonString);
  }

  @override
  DocumentContentType get contentType => DocumentContentType.json;

  @override
  List<Object?> get props => [title];
}

class _FakeCatalystCompressionPlatform extends CatalystCompressionPlatform {
  @override
  CatalystCompressor get brotli => const _FakeCompressor();
}

final class _FakeCompressor implements CatalystCompressor {
  const _FakeCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async => bytes;

  @override
  Future<List<int>> decompress(List<int> bytes) async => bytes;
}

class _FakeBip32Ed25519XPublicKeyFactory extends Bip32Ed25519XPublicKeyFactory {
  @override
  Bip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed22519XPublicKey(bytes: bytes);
  }
}

class _FakeBip32Ed25519XPrivateKeyFactory
    extends Bip32Ed25519XPrivateKeyFactory {
  @override
  Bip32Ed25519XPrivateKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed22519XPrivateKey(bytes: bytes);
  }
}

class _FakeBip32Ed25519XSignatureFactory extends Bip32Ed25519XSignatureFactory {
  @override
  Bip32Ed25519XSignature fromBytes(List<int> bytes) {
    return _FakeBip32Ed22519XSignature(bytes: bytes);
  }
}

class _FakeBip32Ed22519XPublicKey extends Fake
    implements Bip32Ed25519XPublicKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed22519XPublicKey({required this.bytes});

  @override
  Future<bool> verify(
    List<int> message, {
    required Bip32Ed25519XSignature signature,
  }) async {
    return listEquals(signature.bytes, _signature);
  }

  @override
  String toHex() => hex.encode(bytes);
}

class _FakeBip32Ed22519XPrivateKey extends Fake
    implements Bip32Ed25519XPrivateKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed22519XPrivateKey({required this.bytes});

  @override
  Future<Bip32Ed25519XSignature> sign(List<int> message) async {
    return _FakeBip32Ed22519XSignature(bytes: _signature);
  }

  @override
  String toHex() => hex.encode(bytes);
}

class _FakeBip32Ed22519XSignature extends Fake
    implements Bip32Ed25519XSignature {
  @override
  final List<int> bytes;

  _FakeBip32Ed22519XSignature({required this.bytes});

  @override
  String toHex() => hex.encode(bytes);
}
