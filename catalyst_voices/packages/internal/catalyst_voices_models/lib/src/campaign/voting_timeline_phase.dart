import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class VotingTimelinePhase extends Equatable {
  final VotingTimelinePhaseType type;
  final DateRange dateRange;

  const VotingTimelinePhase({
    required this.type,
    required this.dateRange,
  });

  factory VotingTimelinePhase.fromCampaignPhase(CampaignPhase phase) {
    return VotingTimelinePhase(
      type: VotingTimelinePhaseType.fromCampaignPhaseType(phase.type),
      dateRange: phase.timeline,
    );
  }

  @override
  List<Object?> get props => [type, dateRange];
}

/// The type of voting timeline phase.
enum VotingTimelinePhaseType {
  preVoting,
  voting,
  tally,
  results;

  /// Creates a [VotingTimelinePhaseType] from a [CampaignPhaseType].
  ///
  /// [VotingTimelinePhaseType.preVoting] is calculated based on campaignStartDate
  /// and the start of community voting.
  factory VotingTimelinePhaseType.fromCampaignPhaseType(CampaignPhaseType type) {
    return switch (type) {
      CampaignPhaseType.communityVoting => VotingTimelinePhaseType.voting,
      CampaignPhaseType.votingTally => VotingTimelinePhaseType.tally,
      CampaignPhaseType.votingResults => VotingTimelinePhaseType.results,
      _ => throw ArgumentError('Unsupported phase type: $type'),
    };
  }
}
