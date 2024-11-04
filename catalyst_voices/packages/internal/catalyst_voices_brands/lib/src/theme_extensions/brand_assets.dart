import 'package:catalyst_voices_brands/src/brands/brand.dart';
import 'package:flutter/material.dart';

/// A `ThemeExtension` that holds brand-specific assets for theming purposes.
///
/// `BrandAssets` is used to encapsulate theme-dependent assets such as the
/// brand's logo and logo icon as SVG images which can be utilized throughout
/// the application wherever is required.
///
/// Example usage:
/// ```dart
/// final logo = Theme.of(context).brandAssets.brand.logo(context);
/// final logoIcon = Theme.of(context).brandAssets.brand.logoIcon(context);
/// ```
@immutable
class BrandAssets extends ThemeExtension<BrandAssets> {
  final Brand brand;

  const BrandAssets({
    required this.brand,
  });

  @override
  ThemeExtension<BrandAssets> copyWith({
    Brand? brand,
  }) {
    return BrandAssets(
      brand: brand ?? this.brand,
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
