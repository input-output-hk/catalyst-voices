import 'package:catalyst_voices_brands/src/brands/brand.dart';
import 'package:catalyst_voices_brands/src/themes/catalyst.dart';
import 'package:flutter/material.dart';

/// A utility class to build themes dynamically based on brand keys.
///
/// For each brand there is a specific key defined in the [Brand] enum
/// and a corresponding [ThemeData] in the `themes` folder.
/// For each brand a light and a dark [ThemeData] should be defined.
abstract final class ThemeBuilder {
  /// Can be used to obtain the corresponding theme data for the
  /// [Brand] passed to the method as well as [Brightness].
  ///
  /// [brand] defaults to [Brand.catalyst].
  /// [brightness] defaults to [Brightness.light].
  static ThemeData buildTheme({
    Brand brand = Brand.catalyst,
    Brightness brightness = Brightness.light,
  }) {
    return switch (brand) {
      Brand.catalyst when brightness == Brightness.dark => darkCatalyst,
      Brand.catalyst => catalyst,
    };
  }
}
