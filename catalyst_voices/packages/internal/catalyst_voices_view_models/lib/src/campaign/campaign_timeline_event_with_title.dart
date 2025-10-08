import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class CampaignTimelineEventWithTitle extends Equatable {
  final DateRange dateRange;
  final CampaignPhaseType type;

  const CampaignTimelineEventWithTitle({
    required this.dateRange,
    required this.type,
  });

  @override
  List<Object?> get props => [dateRange, type];

  String localizedEventTitle(VoicesLocalizations l10n) {
    return switch (type) {
      CampaignPhaseType.reviewRegistration => l10n.reviewRegistration,
      CampaignPhaseType.communityReview => l10n.reviewTimelineHeader,
      CampaignPhaseType.votingRegistration => l10n.votingRegistrationTimelineHeader,
      CampaignPhaseType.communityVoting => l10n.votingTimelineHeader,
      _ => '',
    };
  }
}
