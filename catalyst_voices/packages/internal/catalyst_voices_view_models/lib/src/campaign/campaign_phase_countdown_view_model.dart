import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class CampaignPhaseCountdownViewModel extends Equatable {
  final DateTime date;
  final int fundNumber;
  final CampaignPhaseType type;

  CampaignPhaseCountdownViewModel({
    DateTime? dateTime,
    required this.fundNumber,
    required this.type,
  })  : assert(dateTime != null, 'dateTime must not be null'),
        date = dateTime!;

  factory CampaignPhaseCountdownViewModel.fromCampaignPhase({
    required CampaignPhase phase,
    required int fundNumber,
    bool useFromDate = true,
  }) {
    return CampaignPhaseCountdownViewModel(
      dateTime: useFromDate ? phase.timeline.from : phase.timeline.to,
      fundNumber: fundNumber,
      type: phase.type,
    );
  }

  @override
  List<Object?> get props => [date, fundNumber, type];

  String title(VoicesLocalizations l10n, String formattedDate) {
    return switch (type) {
      CampaignPhaseType.communityVoting =>
        l10n.campaignPhaseCountdownCommunityVoting(fundNumber, formattedDate),
      _ => '',
    };
  }
}
