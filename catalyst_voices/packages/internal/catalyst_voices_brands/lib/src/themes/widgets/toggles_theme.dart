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
              return colors.iconsDisabled.withOpacity(0.32);
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
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return colors.onSurfaceNeutral012;
            }

            if (states.contains(WidgetState.selected)) {
              return states.contains(WidgetState.error)
                  ? colorScheme.error
                  : colorScheme.primary;
            }

            return null;
          },
        ),
        checkColor: WidgetStateProperty.resolveWith(
          (states) {
            return colors.iconsBackground;
          },
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: colors.onSurfaceNeutral012,
                width: 2,
              );
            }

            if (states.contains(WidgetState.error)) {
              return BorderSide(
                color: colorScheme.error,
                width: 2,
              );
            }

            if (states.contains(WidgetState.selected)) {
              return BorderSide(
                color: colorScheme.primary,
                width: 2,
              );
            }

            return BorderSide(
              color: colors.outlineBorder,
              width: 2,
            );
          },
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected) &&
                !states.contains(WidgetState.disabled)) {
              return colorScheme.primary;
            }

            return colors.outlineBorderVariant.withOpacity(0.38);
          },
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected) &&
                !states.contains(WidgetState.disabled)) {
              return colorScheme.primary;
            }

            return colors.outlineBorder;
          },
        ),
        trackOutlineWidth: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return states.contains(WidgetState.disabled) ? 1.0 : null;
            }

            return 2.0;
          },
        ),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) {
            // Selected states
            if (states.contains(WidgetState.selected)) {
              if (states.contains(WidgetState.disabled)) {
                return colorScheme.surface;
              }
              if (states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.hovered)) {
                return colorScheme.primaryContainer;
              }

              return colorScheme.onPrimary;
            }

            // Not disabled and pressed or hovered
            if (!states.contains(WidgetState.disabled) &&
                (states.contains(WidgetState.pressed) ||
                    states.contains(WidgetState.hovered))) {
              return colors.iconsForeground;
            }

            return colors.outlineBorder;
          },
        ),
      ),
    );
  }
}
