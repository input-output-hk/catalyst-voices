import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesDialogTheme extends DialogTheme {
  VoicesDialogTheme({
    required VoicesColorScheme colors,
  }) : super(
          barrierColor: colors.overlay,
          shadowColor: colors.dropShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.hardEdge,
          backgroundColor: colors.elevationsOnSurfaceNeutralLv1White,
        );
}
