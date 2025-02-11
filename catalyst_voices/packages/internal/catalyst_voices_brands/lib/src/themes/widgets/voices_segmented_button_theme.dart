import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesSegmentedButtonTheme extends SegmentedButtonThemeData {
  VoicesSegmentedButtonTheme({
    required ColorScheme colors,
    required VoicesColorScheme voicesColors,
    required TextTheme textTheme,
  }) : super(
          selectedIcon: const Icon(Icons.check),
          style: SegmentedButton.styleFrom(
            foregroundColor: voicesColors.textOnPrimary,
            backgroundColor: Colors.transparent,
            selectedForegroundColor: colors.onPrimary,
            selectedBackgroundColor: colors.primary,
            disabledForegroundColor: voicesColors.iconsDisabled,
            disabledBackgroundColor: Colors.transparent,
            textStyle: textTheme.labelLarge,
          ).copyWith(
            side: _Side(colors: voicesColors),
            iconColor: _IconColor(colors: voicesColors),
          ),
        );
}

class _Side extends WidgetStateBorderSide {
  final VoicesColorScheme colors;

  const _Side({
    required this.colors,
  });

  @override
  BorderSide? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return BorderSide(color: colors.iconsDisabled);
    }

    return BorderSide(color: colors.outlineBorder);
  }
}

class _IconColor extends WidgetStateColor {
  final VoicesColorScheme colors;

  _IconColor({
    required this.colors,
  }) : super(
          colors.iconsForeground.toARGB32(),
        );

  @override
  Color resolve(Set<WidgetState> states) {
    if (!states.contains(WidgetState.selected)) {
      return colors.iconsForeground;
    }
    return colors.iconsBackground;
  }
}
