import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class BrandAssets extends ThemeExtension<BrandAssets> {
  final SvgGenImage logo;
  final SvgGenImage logoIcon;

  const BrandAssets({
    required this.logo,
    required this.logoIcon,
  });

  @override
  ThemeExtension<BrandAssets> copyWith({
    SvgGenImage? logo,
    SvgGenImage? logoIcon,
  }) {
    return BrandAssets(
      logo: logo ?? this.logo,
      logoIcon: logo ?? this.logoIcon,
    );
  }

  @override
  BrandAssets lerp(
    ThemeExtension<BrandAssets>? other,
    double t,
  ) {
    if (other is! BrandAssets) {
      return this;
    }

    return BrandAssets(
      logo: logo,
      logoIcon: logoIcon,
    );
  }
}

extension BrandAssetsExtension on ThemeData {
  BrandAssets get brandAssets => extension<BrandAssets>()!;
}
