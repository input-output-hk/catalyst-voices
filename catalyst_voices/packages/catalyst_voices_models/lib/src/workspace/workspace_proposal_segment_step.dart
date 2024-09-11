import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';

class WorkspaceProposalSegmentStep extends Equatable {
  final int id;
  final String title;
  final String? description;
  final Document? document;
  final bool isEditable;

  WorkspaceProposalSegmentStep({
    required this.id,
    required this.title,
    this.description,
    this.document,
    this.isEditable = false,
  }) : assert(
          description != null || document != null,
          'Make sure description or document are provided',
        );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        document,
        isEditable,
      ];
}
