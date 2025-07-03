import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class CampaignTimeline extends Equatable {
  final String title;
  final String description;
  final DateRange timeline;
  final CampaignTimelineStage stage;
  final bool offstage;
  // NOTE. later we can add enum for stage that campaign is in when today is
  // in timeline range

  const CampaignTimeline({
    required this.title,
    required this.description,
    required this.timeline,
    required this.stage,
    this.offstage = false,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        timeline,
        stage,
        offstage,
      ];

  CampaignTimeline copyWith({
    String? title,
    String? description,
    DateRange? timeline,
    CampaignTimelineStage? stage,
    bool? offstage,
  }) {
    return CampaignTimeline(
      title: title ?? this.title,
      description: description ?? this.description,
      timeline: timeline ?? this.timeline,
      stage: stage ?? this.stage,
      offstage: offstage ?? this.offstage,
    );
  }
}

enum CampaignTimelineStage {
  proposalSubmission,
  communityReview,
  communityVoting,
  votingResults,
  projectOnboarding,
  votingRegistration,
  reviewRegistration,
}

extension CampaignTimelineX on CampaignTimeline {
  static List<CampaignTimeline> staticContent = [
    CampaignTimeline(
      title: 'Proposal Submission',
      description:
          '''Proposers submit initial ideas to solve challenges. Each proposal includes the problem, solution, requested ADA budget, and a clear implementation plan.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 01, 18),
        to: DateTime.utc(2025, 07, 04, 20),
      ),
      stage: CampaignTimelineStage.proposalSubmission,
    ),
    CampaignTimeline(
      title: 'Voting Registration',
      description:
          'During Voter registration, ADA holders register via supported wallet to participate in the Voting.',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 05, 18),
        to: DateTime.utc(2025, 07, 12, 10),
      ),
      stage: CampaignTimelineStage.votingRegistration,
    ),
    CampaignTimeline(
      title: 'Community Review',
      description:
          '''Community members help improve proposals through two key steps: LV0 and LV1 reviewers assess the proposals, then LV2 moderators oversee the process to ensure quality and fairness.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 03, 8),
        to: DateTime.utc(2025, 07, 08, 20),
      ),
      stage: CampaignTimelineStage.communityReview,
    ),
    CampaignTimeline(
      title: 'Reviewers and Moderators registration',
      description: '',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 03, 8),
        to: DateTime.utc(2025, 07, 04, 20),
      ),
      stage: CampaignTimelineStage.reviewRegistration,
      offstage: true,
    ),
    CampaignTimeline(
      title: 'Community Voting',
      description: '''Community members cast their votes using the Catalyst Voting app.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 16, 12),
        to: DateTime.utc(2025, 07, 18, 9),
      ),
      stage: CampaignTimelineStage.communityVoting,
    ),
    CampaignTimeline(
      title: 'Voting Results',
      description:
          '''Votes are tallied and the results are announced. Rewards are distributed to both voters and community reviewers.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 18, 9),
        to: DateTime.utc(2025, 07, 21, 2),
      ),
      stage: CampaignTimelineStage.votingResults,
    ),
    CampaignTimeline(
      title: 'Project Onboarding',
      description:
          '''This phase involves finalizing the key milestones submitted in the Catalyst App during the proposal submission stage within the Catalyst Milestone Module. It also includes conducting formal due diligence, and fulfilling all required onboarding steps to become eligible for funding.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 25, 06),
        to: DateTime.utc(2025, 07, 30, 06),
      ),
      stage: CampaignTimelineStage.projectOnboarding,
    ),
  ];
}
