import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Simple Enum to store all possible Brands.
enum Brand {
  catalyst;

  SvgGenImage logo(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return switch (this) {
      Brand.catalyst when brightness == Brightness.dark =>
        VoicesAssets.images.catalystLogoWhite,
      Brand.catalyst => VoicesAssets.images.catalystLogo,
    };
  }

  SvgGenImage logoIcon(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return switch (this) {
      Brand.catalyst when brightness == Brightness.dark =>
        VoicesAssets.images.catalystLogoIconWhite,
      Brand.catalyst => VoicesAssets.images.catalystLogoIcon,
    };
  }
}
