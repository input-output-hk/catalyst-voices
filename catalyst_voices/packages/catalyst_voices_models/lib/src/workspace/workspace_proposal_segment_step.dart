import 'package:equatable/equatable.dart';

class WorkspaceProposalSegmentStep extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool isEditable;

  WorkspaceProposalSegmentStep({
    required this.id,
    required this.title,
    required this.description,
    this.isEditable = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isEditable,
      ];
}
