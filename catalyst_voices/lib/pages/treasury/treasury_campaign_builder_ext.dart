import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension TreasuryCampaignSegmentExt on TreasuryCampaignSegment {
  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      TreasuryCampaignSetup() => localizations.treasuryCampaignSetup,
    };
  }
}

extension TreasuryCampaignSegmentStepExt on TreasuryCampaignSegmentStep {
  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      TreasuryCampaignTitle() => localizations.treasuryCampaignTitle,
      TreasuryCampaignTopicX(:final nr) => 'Other topic $nr',
    };
  }

  String tempDescription() {
    return switch (this) {
      TreasuryCampaignTitle() => 'F14 / Promote Social Entrepreneurs and a '
          'longer title up-to 60 characters',
      TreasuryCampaignTopicX(:final nr) => 'Other topic $nr',
    };
  }
}
