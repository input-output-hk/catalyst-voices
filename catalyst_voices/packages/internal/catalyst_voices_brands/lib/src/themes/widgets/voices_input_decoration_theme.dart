import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesInputDecorationTheme extends InputDecorationTheme {
  VoicesInputDecorationTheme({
    required TextTheme textTheme,
    required ColorScheme colorsSchema,
    required VoicesColorScheme colors,
  }) : super(
          labelStyle: textTheme.titleSmall,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: colors.onSurfaceNeutralOpaqueLv1,
          border: _Border(colorsSchema, colors),
        );
}

class _Border extends MaterialStateOutlineInputBorder {
  final ColorScheme colorScheme;
  final VoicesColorScheme colors;

  const _Border(
    this.colorScheme,
    this.colors,
  );

  @override
  InputBorder resolve(Set<WidgetState> states) {
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
          color: colorScheme.primary,
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
