import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixture/signed_document/signed_document_test_data.dart';

void main() {
  group(SignedDocumentManager, () {
    const documentManager = SignedDocumentManager(
      brotli: FakeCompressor(),
      zstd: FakeCompressor(),
    );

    setUpAll(() {
      CatalystPublicKey.factory = FakeCatalystPublicKeyFactory();
      CatalystSignature.factory = FakeCatalystSignatureFactory();
    });

    test('signDocument creates a signed document '
        'that can be converted from/to bytes', () async {
      const payload = SignedDocumentJsonPayload({'title': 'hey'});

      final signedDocument = await documentManager.signDocument(
        payload,
        catalystId: _catalystId,
        metadata: _metadata,
        privateKey: _privateKey,
      );

      expect(signedDocument.payload, equals(payload));

      final isVerified = await signedDocument.verifySignature(_catalystId);
      expect(isVerified, isTrue);

      final signedDocumentArtifact = signedDocument.toArtifact();
      final parsedDocument = await documentManager.parseDocument(signedDocumentArtifact);

      expect(parsedDocument.payload, equals(payload));
      expect(parsedDocument.rawPayload, isNotEmpty);
      expect(parsedDocument.signers, [_catalystId]);
    });

    test('parse signed document v0.0.1', () async {
      final artifact = await SignedDocumentTestData.signedDocumentV0_0_1Bytes.then(
        DocumentArtifact.new,
      );
      final document = await documentManager.parseDocument(artifact);

      expect(document.metadata.type, equals(DocumentType.proposalDocument));
      expect(document.metadata.template, isNotNull);
      expect(document.metadata.parameters, isNotEmpty);
    });

    test('parse signed document v0.0.4', () async {
      final artifact = await SignedDocumentTestData.signedDocumentV0_0_4Bytes.then(
        DocumentArtifact.new,
      );
      final document = await documentManager.parseDocument(artifact);

      expect(document.metadata.type, equals(DocumentType.proposalDocument));
      expect(document.metadata.template, isNotNull);
      expect(document.metadata.parameters, isNotEmpty);
    });
  });
}

final _catalystId = CatalystId(
  host: CatalystIdHost.cardanoPreprod.host,
  role0Key: _publicKey.publicKeyBytes,
);

final _categoryRef = DocumentRefFactory.signedDocumentRef();

final _metadata = DocumentDataMetadata.proposal(
  id: DocumentRefFactory.signedDocumentRef(),
  parameters: DocumentParameters({_categoryRef}),
  template: DocumentRefFactory.signedDocumentRef(),
  authors: [_catalystId],
);

final _privateKey = FakeCatalystPrivateKey(bytes: _privateKeyBytes, signature: _signature);
final _privateKeyBytes = Uint8List.fromList(List.filled(32, 0));
final _publicKey = FakeCatalystPublicKey(bytes: _publicKeyBytes, signatureBytes: _signatureBytes);
final _publicKeyBytes = Uint8List.fromList(List.filled(32, 1));
final _signature = FakeCatalystSignature(bytes: _signatureBytes);
final _signatureBytes = Uint8List.fromList(List.filled(32, 2));
