import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/src/campaign/campaign_stage.dart';
import 'package:equatable/equatable.dart';

final class CampaignInfo extends Equatable {
  final String id;
  final CampaignStage stage;
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  const CampaignInfo({
    required this.id,
    required this.stage,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  /// Calculates the [campaign] info state at given [date].
  factory CampaignInfo.fromCampaign(Campaign campaign, DateTime date) {
    final stage = CampaignStage.fromCampaign(campaign, date);
    return CampaignInfo(
      id: campaign.id,
      stage: stage,
      startDate: campaign.startDate,
      endDate: campaign.endDate,
      description: campaign.description,
    );
  }

  factory CampaignInfo.mockStageFromCampaign(
    Campaign campaign,
    CampaignStage campaignStage,
  ) {
    return CampaignInfo(
      id: campaign.id,
      stage: campaignStage,
      startDate: _mockCampaignStartDate(campaignStage),
      endDate: _mockCampaignEndDate(campaignStage),
      description: campaign.description,
    );
  }

  static DateTime _mockCampaignStartDate(CampaignStage stage) {
    return switch (stage) {
      CampaignStage.draft => DateTimeExt.now().plusDays(3),
      CampaignStage.scheduled => DateTimeExt.now().plusDays(3),
      CampaignStage.live => DateTimeExt.now().minusDays(4),
      CampaignStage.completed => DateTimeExt.now().minusDays(7),
    };
  }

  static DateTime _mockCampaignEndDate(CampaignStage stage) {
    return switch (stage) {
      CampaignStage.draft => DateTimeExt.now().plusDays(5),
      CampaignStage.scheduled => DateTimeExt.now().plusDays(5),
      CampaignStage.live => DateTimeExt.now().minusDays(2),
      CampaignStage.completed => DateTimeExt.now().minusDays(5),
    };
  }

  @override
  List<Object?> get props => [id, stage, startDate, endDate, description];
}
