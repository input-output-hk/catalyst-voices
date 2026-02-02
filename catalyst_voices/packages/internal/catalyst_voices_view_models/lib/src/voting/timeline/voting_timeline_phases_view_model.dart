import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_phase_view_model.dart';
import 'package:equatable/equatable.dart';

/// View model for voting timeline phases widget.
final class VotingTimelinePhasesViewModel extends Equatable {
  final List<VotingTimelinePhaseViewModel> phases;
  final bool isVotingDelegated;

  const VotingTimelinePhasesViewModel({
    required this.phases,
    required this.isVotingDelegated,
  });

  @override
  List<Object?> get props => [phases, isVotingDelegated];
}
