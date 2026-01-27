import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class VotingTimelinePhase extends Equatable {
  final VotingTimelinePhaseType type;
  final String title;
  final String description;
  final DateRange dateRange;

  const VotingTimelinePhase({
    required this.type,
    required this.title,
    required this.description,
    required this.dateRange,
  });

  factory VotingTimelinePhase.fromCampaignPhase(CampaignPhase phase) {
    return VotingTimelinePhase(
      type: VotingTimelinePhaseType.fromCampaignPhaseType(phase.type),
      title: phase.title,
      description: phase.description,
      dateRange: phase.timeline,
    );
  }

  @override
  List<Object?> get props => [type, title, description, dateRange];
}

/// The type of voting timeline phase.
enum VotingTimelinePhaseType {
  registration,
  voting,
  tally,
  results;

  /// Creates a [VotingTimelinePhaseType] from a [CampaignPhaseType].
  factory VotingTimelinePhaseType.fromCampaignPhaseType(CampaignPhaseType type) {
    return switch (type) {
      CampaignPhaseType.votingRegistration => VotingTimelinePhaseType.registration,
      CampaignPhaseType.communityVoting => VotingTimelinePhaseType.voting,
      CampaignPhaseType.votingTally => VotingTimelinePhaseType.tally,
      CampaignPhaseType.votingResults => VotingTimelinePhaseType.results,
      _ => throw ArgumentError('Unsupported phase type: $type'),
    };
  }
}
