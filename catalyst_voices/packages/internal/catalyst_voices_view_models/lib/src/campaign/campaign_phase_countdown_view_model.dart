import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class CampaignPhaseCountdownViewModel extends Equatable {
  final DateTime date;
  final int fundNumber;
  final CampaignPhaseType type;

  const CampaignPhaseCountdownViewModel({
    required this.date,
    required this.fundNumber,
    required this.type,
  });

  factory CampaignPhaseCountdownViewModel.fromCampaignPhase({
    required CampaignPhase phase,
    required int fundNumber,
    bool useFromDate = true,
  }) {
    final dateTime = useFromDate ? phase.timeline.from : phase.timeline.to;

    if (dateTime != null) {
      return CampaignPhaseCountdownViewModel(
        date: dateTime,
        fundNumber: fundNumber,
        type: phase.type,
      );
    }
    throw ArgumentError('DateTime is null');
  }

  @override
  List<Object?> get props => [date, fundNumber, type];

  String title(VoicesLocalizations l10n, String formattedDate) {
    return switch (type) {
      CampaignPhaseType.communityVoting =>
        l10n.campaignPhaseCountdownCommunityVoting(fundNumber, formattedDate),
      CampaignPhaseType.proposalSubmission => l10n.proposalSubmissionStageStartAt(formattedDate),
      _ => '',
    };
  }
}
