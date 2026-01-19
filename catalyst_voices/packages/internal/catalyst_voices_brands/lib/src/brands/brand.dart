import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Simple Enum to store all possible Brands.
enum Brand {
  catalyst;

  SvgGenImage logo(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return switch (this) {
      Brand.catalyst when brightness == Brightness.dark =>
        VoicesAssets.images.svg.catalystLogoWhite,
      Brand.catalyst => VoicesAssets.images.svg.catalystLogo,
    };
  }

  SvgGenImage logoIcon(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return switch (this) {
      Brand.catalyst when brightness == Brightness.dark =>
        VoicesAssets.images.svg.catalystLogoIconWhite,
      Brand.catalyst => VoicesAssets.images.svg.catalystLogoIcon,
    };
  }

  AssetGenImage votingBg(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return switch (this) {
      Brand.catalyst when brightness == Brightness.dark => VoicesAssets.images.votingBgDark,
      Brand.catalyst => VoicesAssets.images.votingBgLight,
    };
  }

  AssetGenImage votingFailedCastVotes(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return switch (this) {
      Brand.catalyst when brightness == Brightness.dark =>
        VoicesAssets.images.failedCastingVotesDark,
      Brand.catalyst => VoicesAssets.images.failedCastingVotesLight,
    };
  }

  AssetGenImage votingSuccessCastVotes(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return switch (this) {
      Brand.catalyst when brightness == Brightness.dark =>
        VoicesAssets.images.successCastingVotesDark,
      Brand.catalyst => VoicesAssets.images.successCastingVotesLight,
    };
  }
}
