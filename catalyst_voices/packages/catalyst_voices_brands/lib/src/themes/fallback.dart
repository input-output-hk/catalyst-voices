import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/src/theme_extensions/brand_assets.dart';
import 'package:flutter/material.dart';

final BrandAssets lightBrandAssets = BrandAssets(
  logo: VoicesAssets.images.fallbackLogo,
  logoIcon: VoicesAssets.images.fallbackLogoIcon,
);

/// [ThemeData] for the `fallback` brand.
final ThemeData fallback = ThemeData(
  colorScheme: ThemeData.light().colorScheme,
  extensions: <ThemeExtension<dynamic>>[
    lightBrandAssets,
  ],
);

/// Dark [ThemeData] for the `fallback` brand.
final ThemeData darkFallback = ThemeData.dark();
