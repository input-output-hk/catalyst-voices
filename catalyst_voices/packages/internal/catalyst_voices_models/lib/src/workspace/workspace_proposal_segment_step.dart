import 'package:catalyst_voices_models/src/document/document_json.dart';
import 'package:equatable/equatable.dart';

class WorkspaceProposalSegmentStep extends Equatable {
  final int id;
  final String title;
  final String? titleInDetails;
  final String? description;
  final DocumentJson? documentJson;
  final RichTextParams? richTextParams;
  final bool isEditable;

  const WorkspaceProposalSegmentStep({
    required this.id,
    required this.title,
    this.titleInDetails,
    this.description,
    this.documentJson,
    this.richTextParams,
    this.isEditable = false,
  }) : assert(
          description != null || richTextParams != null,
          'Make sure description or richTextParams are provided',
        );

  @override
  List<Object?> get props => [
        id,
        title,
        titleInDetails,
        description,
        documentJson,
        richTextParams,
        isEditable,
      ];
}

class RichTextParams {
  final DocumentJson documentJson;
  final int? charsLimit;

  RichTextParams({
    required this.documentJson,
    this.charsLimit,
  });
}
