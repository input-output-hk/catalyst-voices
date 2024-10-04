import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class WorkspaceProposalSegment extends Equatable {
  final Object id;
  final List<WorkspaceProposalSegmentStep> steps;

  const WorkspaceProposalSegment({
    required this.id,
    required this.steps,
  });

  @override
  List<Object?> get props => [
        id,
        steps,
      ];
}

final class WorkspaceProposalSetup extends WorkspaceProposalSegment {
  const WorkspaceProposalSetup({
    required super.id,
    required super.steps,
  });
}
