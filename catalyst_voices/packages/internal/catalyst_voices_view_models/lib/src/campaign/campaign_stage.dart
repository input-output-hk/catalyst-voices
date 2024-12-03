import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';

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
