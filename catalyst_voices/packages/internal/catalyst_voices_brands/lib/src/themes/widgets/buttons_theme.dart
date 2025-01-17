import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

extension ButtonsThemeExt on ThemeData {
  /// Applies Buttons themes configuration.
  ///
  /// Reasoning behind having it as extension is readability mostly and
  /// reusability if we're going to have more brands.
  ThemeData copyWithButtonsTheme() {
    return copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          disabledForegroundColor: colors.textDisabled,
          disabledBackgroundColor: colors.onSurfaceNeutral012,
        ).merge(_buildBaseButtonStyle(textTheme)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: colors.textDisabled,
          disabledBackgroundColor: Colors.transparent,
        ).copyWith(
          side: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: colors.onSurfaceNeutral012);
              }

              if (states.contains(WidgetState.focused)) {
                return BorderSide(color: colorScheme.primary);
              }

              return BorderSide(color: colors.outlineBorder);
            },
          ),
        ).merge(_buildBaseButtonStyle(textTheme)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: colors.textDisabled,
          disabledBackgroundColor: Colors.transparent,
          minimumSize: const Size(60, 40),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ).merge(_buildBaseButtonStyle(textTheme)),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colors.iconsForeground,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: colors.iconsDisabled,
          disabledBackgroundColor: Colors.transparent,
          minimumSize: const Size.square(40),
          iconSize: 24,
          shape: const CircleBorder(),
        ).merge(_buildBaseButtonStyle(textTheme)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          foregroundColor: colors.textOnPrimary,
          backgroundColor: Colors.transparent,
          selectedForegroundColor: colors.textOnPrimary,
          selectedBackgroundColor: colors.onSurfacePrimary012,
          disabledForegroundColor: colors.iconsDisabled,
          disabledBackgroundColor: Colors.transparent,
          textStyle: textTheme.labelLarge,
        ).copyWith(
          side: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: colors.iconsDisabled);
              }

              return BorderSide(color: colors.outlineBorder);
            },
          ),
          iconSize: const WidgetStatePropertyAll(18),
        ),
        selectedIcon: const Icon(Icons.check),
      ),
    );
  }
}

/// Most of buttons share same configuration and differ in just a
/// few properties that's why we're extracting what's shared.
///
/// ButtonStyle returned by this function is not final and is meant to
/// be served as further adjustment via .copyWith or `.merge`.
ButtonStyle _buildBaseButtonStyle(TextTheme textTheme) {
  return ButtonStyle(
    textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
    minimumSize: const WidgetStatePropertyAll(Size(85, 40)),
    iconSize: const WidgetStatePropertyAll(16),
    shape: const WidgetStatePropertyAll(StadiumBorder()),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  );
}
