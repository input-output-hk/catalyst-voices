import 'dart:convert';

import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(SignedDocumentManager, () {
    const documentManager = SignedDocumentManager();

    setUpAll(() {
      CatalystPublicKey.factory = _FakeCatalystPublicKeyFactory();
      CatalystSignature.factory = _FakeCatalystSignatureFactory();
      CatalystCompressionPlatform.instance = _FakeCatalystCompressionPlatform();
    });

    test(
        'signDocument creates a signed document '
        'that can be converted from/to bytes', () async {
      const document = _JsonDocument('title');

      final signedDocument = await documentManager.signDocument(
        document,
        catalystId: _catalystId,
        metadata: _metadata,
        privateKey: _privateKey,
      );

      expect(signedDocument.payload, equals(document));

      final isVerified = await signedDocument.verifySignature(_catalystId);
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

const _metadata = SignedDocumentMetadata(
  contentType: SignedDocumentContentType.json,
  documentType: DocumentType.proposalDocument,
);

final _catalystId = CatalystId(
  // TODO(dtscalac): inject the host from configuration, don't hardcode it
  host: CatalystIdHost.cardanoPreprod.host,
  role0Key: _publicKey,
);

final _privateKey = _FakeCatalystPrivateKey(bytes: _privateKeyBytes);
final _privateKeyBytes = Uint8List.fromList(List.filled(32, 0));
final _publicKey = _FakeCatalystPublicKey(bytes: _publicKeyBytes);
final _publicKeyBytes = Uint8List.fromList(List.filled(32, 1));
final _signature = _FakeCatalystSignature(bytes: _signatureBytes);
final _signatureBytes = Uint8List.fromList(List.filled(32, 2));

class _FakeCatalystCompressionPlatform extends CatalystCompressionPlatform {
  @override
  CatalystCompressor get brotli => const _FakeCompressor();
}

class _FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPrivateKey({required this.bytes});

  @override
  Future<CatalystPrivateKey> derivePrivateKey({
    required String path,
  }) async {
    return _FakeCatalystPrivateKey(bytes: Uint8List.fromList(path.codeUnits));
  }

  @override
  Future<CatalystPublicKey> derivePublicKey() async {
    return _FakeCatalystPublicKey(bytes: bytes);
  }

  @override
  Future<CatalystSignature> sign(Uint8List data) async {
    return _signature;
  }
}

class _FakeCatalystPublicKey extends Fake implements CatalystPublicKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPublicKey({required this.bytes});

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

class _FakeCatalystPublicKeyFactory extends Fake
    implements CatalystPublicKeyFactory {
  @override
  CatalystPublicKey create(Uint8List bytes) {
    return _FakeCatalystPublicKey(bytes: bytes);
  }
}

class _FakeCatalystSignature extends Fake implements CatalystSignature {
  @override
  final Uint8List bytes;

  _FakeCatalystSignature({required this.bytes});
}

class _FakeCatalystSignatureFactory extends Fake
    implements CatalystSignatureFactory {
  @override
  CatalystSignature create(Uint8List bytes) {
    return _FakeCatalystSignature(bytes: bytes);
  }
}

final class _FakeCompressor implements CatalystCompressor {
  const _FakeCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async => bytes;

  @override
  Future<List<int>> decompress(List<int> bytes) async => bytes;
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

  @override
  List<Object?> get props => [title];

  @override
  Uint8List toBytes() {
    final jsonString = json.encode(toJson());
    return utf8.encode(jsonString);
  }

  Map<String, dynamic> toJson() {
    return {'title': title};
  }
}
