import 'package:flutter/material.dart';

class VoicesSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double>? onChanged;

  const VoicesSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 1,
    this.divisions = 25,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      divisions: divisions,
    );
  }
}
