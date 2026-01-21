import 'package:catalyst_voices_models/catalyst_voices_models.dart';

interface class DocumentViewerCache {
  final DocumentRef? id;
  final CatalystId? activeAccountId;
  final DocumentParameters? documentParameters;

  DocumentViewerCache({
    this.id,
    this.activeAccountId,
    this.documentParameters,
  });

  DocumentViewerCache copyWith({
    Optional<DocumentRef>? id,
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentParameters>? documentParameters,
  }) {
    return DocumentViewerCache(
      id: id.dataOr(this.id),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      documentParameters: documentParameters.dataOr(this.documentParameters),
    );
  }
}
