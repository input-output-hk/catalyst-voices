import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class CampaignTimeline extends Equatable {
  final String title;
  final String description;
  final DateRange timeline;
  final CampaignTimelineStage stage;
  // NOTE. later we can add enum for stage that campaign is in when today is
  // in timeline range

  const CampaignTimeline({
    required this.title,
    required this.description,
    required this.timeline,
    required this.stage,
  });

  @override
  List<Object?> get props => [title, description, timeline, stage];

  CampaignTimeline copyWith({
    String? title,
    String? description,
    DateRange? timeline,
    CampaignTimelineStage? stage,
  }) {
    return CampaignTimeline(
      title: title ?? this.title,
      description: description ?? this.description,
      timeline: timeline ?? this.timeline,
      stage: stage ?? this.stage,
    );
  }
}

enum CampaignTimelineStage {
  proposalSubmission,
  communityReview,
  communityVoting,
  votingResults,
  projectOnboarding,
}

extension CampaignTimelineX on CampaignTimeline {
  static List<CampaignTimeline> staticContent = [
    CampaignTimeline(
      title: 'Proposal Submission',
      description:
          '''Proposers submit initial ideas to solve challenges. Each proposal includes the problem, solution, requested ADA budget, and a clear implementation plan.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 4, 30, 13, 20),
        to: DateTime.utc(2025, 07, 07, 06),
      ),
      stage: CampaignTimelineStage.proposalSubmission,
    ),
    CampaignTimeline(
      title: 'Community Review',
      description:
          '''Community members help improve proposals through two key steps: LV0 and LV1 reviewers assess the proposals, then LV2 moderators oversee the process to ensure quality and fairness.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 19, 12),
        to: DateTime.utc(2025, 08, 6, 6),
      ),
      stage: CampaignTimelineStage.communityReview,
    ),
    CampaignTimeline(
      title: 'Community Voting',
      description: '''Community members cast their votes using the Catalyst Voting app.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 08, 11, 12),
        to: DateTime.utc(2025, 08, 25, 11),
      ),
      stage: CampaignTimelineStage.communityVoting,
    ),
    CampaignTimeline(
      title: 'Voting Results',
      description:
          '''Votes are tallied and the results are announced. Rewards are distributed to both voters and community reviewers.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 08, 25),
        to: DateTime.utc(2025, 08, 31),
      ),
      stage: CampaignTimelineStage.votingResults,
    ),
    CampaignTimeline(
      title: 'Project Onboarding',
      description:
          '''This phase involves finalizing the key milestones submitted in the Catalyst App during the proposal submission stage within the Catalyst Milestone Module. It also includes conducting formal due diligence, and fulfilling all required onboarding steps to become eligible for funding.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 08, 28),
        to: DateTime.utc(2025, 10, 9),
      ),
      stage: CampaignTimelineStage.projectOnboarding,
    ),
  ];
}
