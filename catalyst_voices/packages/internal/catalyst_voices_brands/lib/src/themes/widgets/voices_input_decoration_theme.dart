import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesInputDecorationTheme extends InputDecorationTheme {
  VoicesInputDecorationTheme({
    required TextTheme textTheme,
    required ColorScheme colorsScheme,
    required VoicesColorScheme colors,
  }) : super(
          labelStyle: textTheme.titleSmall,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: colors.onSurfaceNeutralOpaqueLv1,
          border: WidgetStateInputBorder.resolveWith(
            (states) => _border(
              states: states,
              colorsScheme: colorsScheme,
              colors: colors,
            ),
          ),
        );

  static InputBorder _border({
    required Set<WidgetState> states,
    required ColorScheme colorsScheme,
    required VoicesColorScheme colors,
  }) {
    if (states.contains(WidgetState.disabled)) {
      return OutlineInputBorder(
        borderSide: BorderSide(
          color: colors.outlineBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      );
    }

    if (states.contains(WidgetState.error)) {
      return OutlineInputBorder(
        borderSide: BorderSide(
          color: colors.iconsError,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      );
    }

    if (states.contains(WidgetState.focused)) {
      return OutlineInputBorder(
        borderSide: BorderSide(
          color: colorsScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      );
    }

    return OutlineInputBorder(
      borderSide: BorderSide(
        color: colors.outlineBorderVariant,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }
}
