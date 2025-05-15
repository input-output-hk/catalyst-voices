import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Raw document content class. At this level we can't really make sense of
/// what [data] is. [DocumentDataMetadata] is required and most likely
/// [Document] will be produced out of it.
final class DocumentDataContent extends Equatable {
  final Map<String, dynamic> data;

  const DocumentDataContent(this.data);

  @override
  List<Object?> get props => [data];

  String? get title {
    final value =
        DocumentNodeTraverser.getValue(ProposalDocument.titleNodeId, data);
    return value as String?;
  }
}
