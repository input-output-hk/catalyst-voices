import 'package:flutter/material.dart';

/// A custom linear progress indicator with optional track visibility and
/// rounded corners.
///
/// This widget provides a linear progress indicator with customization
/// options for the progress value, track visibility, and rounded corners.
class VoicesLinearProgressIndicator extends StatelessWidget {
  /// The current progress value, from 0.0 to 1.0. If null, the indicator will
  /// be indeterminate.
  final double? value;

  /// Whether to show the progress indicator's track.
  final bool showTrack;

  /// Creates a [VoicesLinearProgressIndicator] widget.
  const VoicesLinearProgressIndicator({
    super.key,
    this.value,
    this.showTrack = true,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      borderRadius: BorderRadius.circular(4),
      backgroundColor: showTrack ? null : Colors.transparent,
    );
  }
}
