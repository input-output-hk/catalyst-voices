import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/campaign/campaign_stage.dart';
import 'package:equatable/equatable.dart';

final class CampaignInfo extends Equatable {
  final String id;
  final CampaignStage stage;
  final DateTime startDate;
  final String description;

  const CampaignInfo({
    required this.id,
    required this.stage,
    required this.startDate,
    required this.description,
  });

  /// Calculates the [campaign] info state at given [date].
  factory CampaignInfo.fromCampaign(Campaign campaign, DateTime date) {
    final stage = CampaignStage.fromCampaign(campaign, date);
    return CampaignInfo(
      id: campaign.id,
      stage: stage,
      startDate: campaign.startDate,
      description: campaign.description,
    );
  }

  String localizedDate(
    VoicesLocalizations l10n,
    (String date, String time) formattedDate,
  ) {
    if (stage == CampaignStage.draft) {
      return l10n.campaignBeginsOn(formattedDate.$1, formattedDate.$2);
    } else {
      return l10n.campaignEndsOn(formattedDate.$1, formattedDate.$2);
    }
  }

  @override
  List<Object?> get props => [id, stage, startDate, description];
}
