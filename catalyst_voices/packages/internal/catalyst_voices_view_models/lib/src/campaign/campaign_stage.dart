import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Enum representing the stage of a campaign.
/// 
/// Stages:
/// - [draft]: Campaign has not started. 
/// Required when publish state is [CampaignPublish.draft]
/// - [scheduled]: Campaign has start/end dates set but hasn't started yet
/// - [live]: Campaign is currently active (between start and end dates)
/// - [completed]: Campaign has ended (current date is after end date)
/// 
/// Note: All stages except [draft] require [CampaignPublish.published] state
enum CampaignStage {
  draft,
  scheduled,
  live,
  completed;

  bool get isCompleted => this == CampaignStage.completed;
  bool get isDraft => this == CampaignStage.draft;

  String localizedName(VoicesLocalizations l10n) => switch (this) {
        CampaignStage.draft => l10n.campaignStartingSoon,
        CampaignStage.scheduled => l10n.campaignStartingSoon,
        CampaignStage.live => l10n.campaignIsLive,
        CampaignStage.completed => l10n.campaignConcluded,
      };
}
