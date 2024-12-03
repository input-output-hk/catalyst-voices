import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/campaign/campaign_stage.dart';
import 'package:equatable/equatable.dart';

sealed class CampaignInfo extends Equatable {
  final String id;
  final CampaignStage stage;
  final String description;

  const CampaignInfo({
    required this.id,
    required this.stage,
    required this.description,
  });

  /// Calculates the [campaign] info state at given [date].
  factory CampaignInfo.fromCampaign(Campaign campaign, DateTime date) {
    final stage = CampaignStage.fromCampaign(campaign, date);
    return switch (stage) {
      CampaignStage.draft => DraftCampaignInfo(
          startDate: campaign.startDate,
          id: campaign.id,
          description: campaign.description,
        ),
      CampaignStage.scheduled => ScheduledCampaignInfo(
          startDate: campaign.startDate,
          id: campaign.id,
          description: campaign.description,
        ),
      CampaignStage.live => LiveCampaignInfo(
          startDate: campaign.startDate,
          id: campaign.id,
          description: campaign.description,
        ),
      CampaignStage.completed => CompletedCampaignInfo(
          id: campaign.id,
          description: campaign.description,
        ),
    };
  }

  @override
  List<Object?> get props => [stage, description];
}

class ScheduledCampaignInfo extends CampaignInfo with CampaignDateTimeMixin {
  @override
  final DateTime startDate;

  const ScheduledCampaignInfo({
    required this.startDate,
    required super.id,
    required super.description,
  }) : super(stage: CampaignStage.draft);

  @override
  List<Object?> get props => [startDate, description];
}

class DraftCampaignInfo extends CampaignInfo with CampaignDateTimeMixin {
  @override
  final DateTime startDate;

  const DraftCampaignInfo({
    required this.startDate,
    required super.id,
    required super.description,
  }) : super(stage: CampaignStage.draft);

  @override
  List<Object?> get props => [startDate, description];
}

class LiveCampaignInfo extends CampaignInfo with CampaignDateTimeMixin {
  @override
  final DateTime startDate;

  const LiveCampaignInfo({
    required this.startDate,
    required super.id,
    required super.description,
  }) : super(stage: CampaignStage.live);

  @override
  List<Object?> get props => [startDate, description];
}

class CompletedCampaignInfo extends CampaignInfo {
  const CompletedCampaignInfo({
    required super.id,
    required super.description,
  }) : super(stage: CampaignStage.completed);
}

mixin CampaignDateTimeMixin {
  DateTime get startDate;
  CampaignStage get stage;

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
}
