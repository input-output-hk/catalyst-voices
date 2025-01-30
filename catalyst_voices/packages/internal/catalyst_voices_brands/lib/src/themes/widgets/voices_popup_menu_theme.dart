import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesPopupMenuThemeData extends PopupMenuThemeData {
  VoicesPopupMenuThemeData({
    required VoicesColorScheme colors,
  }) : super(
          color: colors.elevationsOnSurfaceNeutralLv1White,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          menuPadding: EdgeInsets.zero,
          position: PopupMenuPosition.over,
        );
}
