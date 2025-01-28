import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesSliderThemeData extends SliderThemeData {
  VoicesSliderThemeData({
    required VoicesColorScheme colors,
  }) : super(
          trackHeight: 6,
          activeTrackColor: Colors.white,
          inactiveTrackColor: colors.onSurfaceNeutral016,
          thumbColor: Colors.white,
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: 4,
            elevation: 0,
            pressedElevation: 0,
          ),
          overlayColor: Colors.transparent,
          inactiveTickMarkColor: Colors.transparent,
        );
}
