import 'package:equatable/equatable.dart';

class WorkspaceProposalSegmentStep extends Equatable {
  final int id;
  final String title;
  final String? description;
  final List<dynamic>? jsonData;
  final bool isEditable;

  const WorkspaceProposalSegmentStep({
    required this.id,
    required this.title,
    this.description,
    this.jsonData,
    this.isEditable = false,
  }) : assert(
          description != null || jsonData != null,
          'Make sure description or document are provided',
        );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        jsonData,
        isEditable,
      ];
}
