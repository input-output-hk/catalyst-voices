import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:flutter/material.dart';

class VoicesSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double>? onChanged;
  final SliderThemeData? sliderTheme;

  const VoicesSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 1,
    this.divisions = 25,
    this.onChanged,
    this.sliderTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: sliderTheme ??
          SliderThemeData(
            trackHeight: 6,
            activeTrackColor: Colors.white,
            secondaryActiveTrackColor: Colors.tealAccent,
            inactiveTrackColor: context.colors.onSurfaceNeutral016,
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 4,
              elevation: 0,
              pressedElevation: 0,
            ),
            overlayColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
      ),
    );
  }
}
