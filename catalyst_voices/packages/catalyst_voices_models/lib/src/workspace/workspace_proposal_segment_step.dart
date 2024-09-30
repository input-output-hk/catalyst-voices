import 'package:catalyst_voices_models/src/document/document_json.dart';
import 'package:equatable/equatable.dart';

class WorkspaceProposalSegmentStep extends Equatable {
  final int id;
  final String title;
  final String? description;
  final DocumentJson? documentJson;
  final bool isEditable;

  const WorkspaceProposalSegmentStep({
    required this.id,
    required this.title,
    this.description,
    this.documentJson,
    this.isEditable = false,
  }) : assert(
          description != null || documentJson != null,
          'Make sure description or document are provided',
        );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        documentJson,
        isEditable,
      ];
}
