import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension CampaignStatusExt on CampaignStatus {
  String localizedName(VoicesLocalizations l10n) => switch (this) {
        CampaignStatus.draft => l10n.campaignStartingSoon,
        CampaignStatus.live => l10n.campaignIsLive,
        CampaignStatus.completed => l10n.campaignConcluded,
      };
}
