import 'package:catalyst_voices_models/src/document/document_ref.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Parameters associated with a document, like brandId, campaignId or categoryId.
final class DocumentParameters extends Equatable {
  final Set<SignedDocumentRef> set;

  const DocumentParameters([this.set = const {}]);

  @override
  List<Object?> get props => [set];

  bool contains(SignedDocumentRef ref) {
    return set.contains(ref);
  }

  bool containsId(String id) {
    return set.any((e) => e.id.equalsIgnoreCase(id));
  }
}
