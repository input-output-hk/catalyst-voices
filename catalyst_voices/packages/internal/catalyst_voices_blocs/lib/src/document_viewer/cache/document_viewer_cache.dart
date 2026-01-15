import 'package:catalyst_voices_models/catalyst_voices_models.dart';

interface class DocumentViewerCache {
  final DocumentRef? id;
  final DocumentData? documentData;
  final CatalystId? activeAccountId;
  final DocumentParameters? documentParameters;

  DocumentViewerCache({
    this.id,
    this.documentData,
    this.activeAccountId,
    this.documentParameters,
  });

  DocumentViewerCache copyWith({
    Optional<DocumentRef>? id,
    Optional<DocumentData>? documentData,
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentParameters>? documentParameters,
  }) {
    return DocumentViewerCache(
      id: id.dataOr(this.id),
      documentData: documentData.dataOr(this.documentData),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      documentParameters: documentParameters.dataOr(this.documentParameters),
    );
  }
}
