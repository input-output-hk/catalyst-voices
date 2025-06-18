import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentLookupState extends Equatable {
  final List<DocumentLookupTileData>? documents;

  const DocumentLookupState({
    this.documents,
  });

  @override
  List<Object?> get props => [documents];

  DocumentLookupState copyWith({
    Optional<List<DocumentLookupTileData>>? documents,
  }) {
    return DocumentLookupState(
      documents: documents.dataOr(this.documents),
    );
  }
}
