import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:mocktail/mocktail.dart';

final class FakeSignedDocument extends Fake implements SignedDocument {
  @override
  final SignedDocumentPayload payload;

  @override
  final DocumentDataMetadata metadata;

  @override
  final List<CatalystId> signers;

  FakeSignedDocument({
    required this.payload,
    required this.metadata,
    this.signers = const [],
  });

  @override
  SignedDocumentRawPayload get rawPayload => SignedDocumentRawPayload(payload.toBytes());

  @override
  DocumentArtifact toArtifact() {
    throw UnsupportedError('Not implemented');
  }

  @override
  Future<bool> verifySignature(CatalystId catalystId) async {
    throw UnsupportedError('Not implemented');
  }
}
