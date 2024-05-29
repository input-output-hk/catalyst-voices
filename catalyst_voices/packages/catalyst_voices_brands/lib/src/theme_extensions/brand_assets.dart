import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

/// A `ThemeExtension` that holds brand-specific assets for theming purposes.
///
/// `BrandAssets` is used to encapsulate theme-dependent assets such as the
/// brand's logo and logo icon as SVG images which can be utilized throughout
/// the application wherever is required.
///
/// Example usage:
/// ```dart
/// final logo = Theme.of(context).brandAssets.logo;
/// final logoIcon = Theme.of(context).brandAssets.logoIcon;
/// ```
@immutable
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
    } else if (t >= 0.5) {
      return other;
    } else {
      return this;
    }
  }
}

extension BrandAssetsExtension on ThemeData {
  BrandAssets get brandAssets => extension<BrandAssets>()!;
}
