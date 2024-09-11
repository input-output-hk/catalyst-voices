import 'package:equatable/equatable.dart';

sealed class WorkspaceProposalSegmentStep extends Equatable {
  final int id;
  final bool isEditable;

  WorkspaceProposalSegmentStep({
    required this.id,
    this.isEditable = false,
  });

  @override
  List<Object?> get props => [
        id,
        isEditable,
      ];
}

final class WorkspaceProposalTitle extends WorkspaceProposalSegmentStep {
  WorkspaceProposalTitle({
    required super.id,
    super.isEditable,
  });
}

// Note. Temporary class representing dummy topic
final class WorkspaceProposalTopicX extends WorkspaceProposalSegmentStep {
  final int nr;

  WorkspaceProposalTopicX({
    required super.id,
    required this.nr,
  });

  @override
  List<Object?> get props => super.props + [nr];
}
