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
  votingTally,
  votingRegistration,
  reviewRegistration,
  votingResults,
  projectOnboarding;

  bool get isCommunityReview => this == CampaignPhaseType.communityReview;

  bool get isCommunityVoting => this == CampaignPhaseType.communityVoting;

  bool get isReviewRegistration => this == CampaignPhaseType.reviewRegistration;

  bool get isVotingRegistration => this == CampaignPhaseType.votingRegistration;
}
