import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentDataPreviewState extends Equatable {
  final List<DocumentData>? documents;

  const DocumentDataPreviewState({
    this.documents,
  });

  @override
  List<Object?> get props => [documents];

  DocumentDataPreviewState copyWith({
    Optional<List<DocumentData>>? documents,
  }) {
    return DocumentDataPreviewState(
      documents: documents.dataOr(this.documents),
    );
  }
}
