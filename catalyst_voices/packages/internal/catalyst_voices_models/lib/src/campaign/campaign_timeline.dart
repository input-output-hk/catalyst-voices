import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class CampaignTimeline extends Equatable {
  final String title;
  final String description;
  final DateRange timeline;
  // NOTE. later we can add enum for stage that campaign is in when today is
  // in timeline range

  const CampaignTimeline({
    required this.title,
    required this.description,
    required this.timeline,
  });

  @override
  List<Object?> get props => [title, description, timeline];

  CampaignTimeline copyWith({
    String? title,
    String? description,
    DateRange? timeline,
  }) {
    return CampaignTimeline(
      title: title ?? this.title,
      description: description ?? this.description,
      timeline: timeline ?? this.timeline,
    );
  }
}

extension CampaignTimelineX on CampaignTimeline {
  static List<CampaignTimeline> staticContent = [
    CampaignTimeline(
      title: 'Proposal Submission',
      description:
          '''Participants submit initial proposals for ideas to solve challenges. A set amount of ada is allocated to the new funding round.''',
      timeline: DateRange(
        from: DateTime(2024, 9, 26),
        to: DateTime(2024, 10, 10),
      ),
    ),
    CampaignTimeline(
      title: 'Community Review',
      description:
          '''Community members share ideas and insights to refine the proposals. This stage consists of two distinct parts: reviews by LV0 & LV1s reviewers, as well as moderation by LV2s moderators.''',
      timeline: DateRange(
        from: DateTime(2024, 10, 26),
        to: DateTime(2024, 12, 10),
      ),
    ),
    CampaignTimeline(
      title: 'Community Voting',
      description:
          '''Community members vote using the Project Catalyst voting app. Votes are weighted based on voter's token holding.''',
      timeline: DateRange(
        from: DateTime(2025, 1, 1),
        to: DateTime(2025, 1, 31),
      ),
    ),
    CampaignTimeline(
      title: 'Voting Results',
      description:
          '''Votes are tallied and the results revealed. Voters and community reviewers receive their rewards.''',
      timeline: DateRange(
        from: DateTime(2025, 2, 2),
        to: DateTime(2025, 2, 18),
      ),
    ),
    CampaignTimeline(
      title: 'Project Onboarding',
      description:
          '''Votes are tallied and the results revealed. Voters and community reviewers receive their rewards.''',
      timeline: DateRange(
        from: DateTime(2025, 2, 19),
        to: null,
      ),
    ),
  ];
}
