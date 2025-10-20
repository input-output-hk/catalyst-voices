import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

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
      const document = SignedDocumentJsonPayload({'title': 'hey'});

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
      );

      expect(parsedDocument, equals(signedDocument));
      expect(parsedDocument.signers, [_catalystId]);
    });
  });
}

const _metadata = SignedDocumentMetadata(
  contentType: SignedDocumentContentType.json,
  documentType: DocumentType.proposalDocument,
);

final _catalystId = CatalystId(
  host: CatalystIdHost.cardanoPreprod.host,
  role0Key: _publicKey.publicKeyBytes,
);

final _privateKey = FakeCatalystPrivateKey(bytes: _privateKeyBytes);
final _privateKeyBytes = Uint8List.fromList(List.filled(32, 0));
final _publicKey = FakeCatalystPublicKey(bytes: _publicKeyBytes);
final _publicKeyBytes = Uint8List.fromList(List.filled(32, 1));
