import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/src/campaign/campaign_stage.dart';
import 'package:equatable/equatable.dart';

/// View model for campaign info.
///
/// This view model is used to display the info of a campaign.
///
/// Data for this view model is extracted from the [Campaign] model.
final class CampaignInfo extends Equatable {
  final DocumentRef id;
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

  // TODO(LynxLynxx): Calculate stage based on campaign phase and status when requirements are clear.
  factory CampaignInfo.fromCampaign(Campaign campaign) {
    final stage = CampaignStage.fromCampaign(campaign);
    return CampaignInfo(
      id: campaign.id,
      stage: stage,
      startDate: campaign.timeline.phases.first.timeline.from ?? DateTime.now(),
      endDate: campaign.timeline.phases.last.timeline.to ?? DateTime.now(),
      description: campaign.description,
    );
  }

  /// Creates a mocked campaign info from [campaign] at given [campaignStage].
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

  @override
  List<Object?> get props => [id, stage, startDate, endDate, description];

  static DateTime _mockCampaignEndDate(CampaignStage stage) {
    return switch (stage) {
      CampaignStage.draft => DateTimeExt.now().plusDays(5),
      CampaignStage.scheduled => DateTimeExt.now().plusDays(5),
      CampaignStage.live => DateTimeExt.now().minusDays(2),
      CampaignStage.completed => DateTimeExt.now().minusDays(5),
    };
  }

  static DateTime _mockCampaignStartDate(CampaignStage stage) {
    return switch (stage) {
      CampaignStage.draft => DateTimeExt.now().plusDays(3),
      CampaignStage.scheduled => DateTimeExt.now().plusDays(3),
      CampaignStage.live => DateTimeExt.now().minusDays(4),
      CampaignStage.completed => DateTimeExt.now().minusDays(7),
    };
  }
}
