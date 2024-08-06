import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

extension TogglesTheme on ThemeData {
  /// Applies Toggles themes configuration.
  ///
  /// Reasoning behind having it as extension is readability mostly and
  /// reusability if we're going to have more brands.
  ThemeData copyWithTogglesTheme() {
    return copyWith(
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return colors.iconsDisabled?.withOpacity(0.32);
            }

            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }

            const foregroundStates = [WidgetState.focused, WidgetState.hovered];
            if (states.any((state) => foregroundStates.contains(state))) {
              return colors.iconsForeground;
            }

            return colors.outlineBorder;
          },
        ),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }

            if (states.contains(WidgetState.pressed)) {
              return states.contains(WidgetState.selected)
                  ? colors.onSurfaceNeutral012
                  : colors.onSurfacePrimary08;
            }

            const hoveredFocusedStates = [
              WidgetState.hovered,
              WidgetState.focused,
            ];
            if (states.any((state) => hoveredFocusedStates.contains(state))) {
              return states.contains(WidgetState.selected)
                  ? colors.onSurfacePrimary08
                  : colors.onSurfaceNeutral012;
            }

            return null;
          },
        ),
      ),
    );
  }
}
