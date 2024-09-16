import 'package:catalyst_voices_models/src/workspace/workspace_proposal_segment.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceProposalNavigation extends Equatable {
  final List<WorkspaceProposalSegment> segments;

  WorkspaceProposalNavigation({
    required this.segments,
  });

  @override
  List<Object?> get props => [
        segments,
      ];
}
