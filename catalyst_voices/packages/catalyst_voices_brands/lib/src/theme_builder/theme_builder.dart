import 'package:catalyst_voices_brands/src/brands/brands.dart';
import 'package:catalyst_voices_brands/src/themes/catalyst.dart';
import 'package:catalyst_voices_brands/src/themes/fallback.dart';
import 'package:flutter/material.dart';

/// A utility class to build themes dynamically based on brand keys.
///
/// [buildTheme] can be used to obtain the corresponding theme data for the
/// [BrandKey] passed to the method.
///
/// [buildDarkTheme] operates in the same way but picks the dark version of the
/// theme for a specific brand.
///
/// For each brand there is a specific key defined in the [BrandKey] enum
/// and a corresponding [ThemeData] in the `themes` folder.
/// For each brand a light and a dark [ThemeData] should be defined.
///
/// [buildTheme] and [buildDarkTheme] default to the [catalyst] theme.
class ThemeBuilder {
  static final Map<BrandKey, ThemeData> lightThemes = {
    BrandKey.catalyst: catalyst,
    BrandKey.fallback: fallback,
  };

  static final Map<BrandKey, ThemeData> darkThemes = {
    BrandKey.catalyst: darkCatalyst,
    BrandKey.fallback: darkFallback,
  };

  static ThemeData buildTheme(BrandKey? brandKey) {
    return lightThemes[brandKey ?? BrandKey.catalyst]!;
  }

  static ThemeData buildDarkTheme(BrandKey? brandKey) {
    return darkThemes[brandKey ?? BrandKey.catalyst]!;
  }
}
