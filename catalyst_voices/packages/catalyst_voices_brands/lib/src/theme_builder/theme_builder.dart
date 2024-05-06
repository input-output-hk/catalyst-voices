import 'package:catalyst_voices_brands/src/brands/brands.dart';
import 'package:catalyst_voices_brands/src/themes/catalyst.dart';
import 'package:catalyst_voices_brands/src/themes/fallback.dart';
import 'package:flutter/material.dart';

/// A utility class to build themes dynamically based on brand keys.
/// 
/// [buildTheme] can be used to obtain the corresponding theme data for the
/// [BrandKey] passed to the method.
/// 
/// For each brand there is a specific key defined in the [BrandKey] enum 
/// and a corresponding [ThemeData] in the `themes` folder.
///
/// [buildTheme] defaults to the [catalyst] theme. 
class ThemeBuilder {
  static ThemeData buildTheme(BrandKey? brandKey) {
    switch (brandKey) {
      case BrandKey.catalyst:
        return catalyst;
      case BrandKey.fallback:
        return fallback;
      case null:
        return catalyst;
    }
  }
}
