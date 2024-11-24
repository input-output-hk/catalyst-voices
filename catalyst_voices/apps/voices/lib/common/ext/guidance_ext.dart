import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

extension GuidanceExt on GuidanceType {
  String localizedType(VoicesLocalizations localizations) => switch (this) {
        GuidanceType.mandatory => localizations.mandatoryGuidanceType,
        GuidanceType.education => localizations.educationGuidanceType,
        GuidanceType.tips => localizations.tipsGuidanceType,
      };

  // TODO(ryszard-schossler): when designers will
  // provide us with icon, change here accordingly
  SvgGenImage get icon {
    return switch (this) {
      GuidanceType.education => VoicesAssets.icons.newspaper,
      GuidanceType.mandatory => VoicesAssets.icons.newspaper,
      GuidanceType.tips => VoicesAssets.icons.newspaper,
    };
  }
}
