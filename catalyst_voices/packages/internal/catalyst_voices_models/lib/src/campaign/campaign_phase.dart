import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class CampaignPhase extends Equatable {
  final String title;
  final String description;
  final DateRange timeline;
  final CampaignPhaseType type;

  const CampaignPhase({
    required this.title,
    required this.description,
    required this.timeline,
    required this.type,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    timeline,
    type,
  ];

  CampaignPhase copyWith({
    String? title,
    String? description,
    DateRange? timeline,
    CampaignPhaseType? type,
  }) {
    return CampaignPhase(
      title: title ?? this.title,
      description: description ?? this.description,
      timeline: timeline ?? this.timeline,
      type: type ?? this.type,
    );
  }
}

enum CampaignPhaseType {
  proposalSubmission,
  communityReview,
  communityVoting,
  votingRegistration,
  reviewRegistration,
  votingResults,
  projectOnboarding,
}

extension CampaignPhaseX on CampaignPhase {
  static List<CampaignPhase> f14StaticContent = [
    CampaignPhase(
      title: 'Proposal Submission',
      description:
          '''Proposers submit initial ideas to solve challenges. Each proposal includes the problem, solution, requested ADA budget, and a clear implementation plan.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 25, 10),
        to: DateTime.utc(2025, 12, 30, 18),
      ),
      type: CampaignPhaseType.proposalSubmission,
    ),
    CampaignPhase(
      title: 'Voting Registration',
      description:
          'During Voter registration, ADA holders register via supported wallet to participate in the Voting.',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 05, 18),
        to: DateTime.utc(2025, 07, 12, 10),
      ),
      type: CampaignPhaseType.votingRegistration,
    ),
    CampaignPhase(
      title: 'Community Review',
      description:
          '''Community members help improve proposals through two key steps: LV0 and LV1 reviewers assess the proposals, then LV2 moderators oversee the process to ensure quality and fairness.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 03, 8),
        to: DateTime.utc(2025, 07, 08, 20),
      ),
      type: CampaignPhaseType.communityReview,
    ),
    CampaignPhase(
      title: 'Reviewers and Moderators registration',
      description: '',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 03, 8),
        to: DateTime.utc(2025, 07, 04, 20),
      ),
      type: CampaignPhaseType.reviewRegistration,
    ),
    CampaignPhase(
      title: 'Community Voting',
      description: '''Community members cast their votes using the Catalyst Voting app.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 16, 12),
        to: DateTime.utc(2025, 08, 18, 9),
      ),
      type: CampaignPhaseType.communityVoting,
    ),
    CampaignPhase(
      title: 'Voting Results',
      description:
          '''Votes are tallied and the results are announced. Rewards are distributed to both voters and community reviewers.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 18, 9),
        to: DateTime.utc(2025, 07, 21, 2),
      ),
      type: CampaignPhaseType.votingResults,
    ),
    CampaignPhase(
      title: 'Project Onboarding',
      description:
          '''This phase involves finalizing the key milestones submitted in the Catalyst App during the proposal submission type within the Catalyst Milestone Module. It also includes conducting formal due diligence, and fulfilling all required onboarding steps to become eligible for funding.''',
      timeline: DateRange(
        from: DateTime.utc(2025, 07, 25, 06),
        to: DateTime.utc(2025, 07, 30, 06),
      ),
      type: CampaignPhaseType.projectOnboarding,
    ),
  ];
}
