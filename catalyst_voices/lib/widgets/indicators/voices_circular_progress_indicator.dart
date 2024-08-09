import 'package:flutter/material.dart';

/// A Voices circular progress indicator with optional track visibility.
///
/// This widget provides a circular progress indicator with customization
/// options for the progress value and track visibility.
class VoicesCircularProgressIndicator extends StatelessWidget {
  /// The current progress value, from 0.0 to 1.0. If null,
  /// the indicator will be indeterminate.
  final double? value;

  /// Whether to show the progress indicator's track.
  final bool showTrack;

  /// Creates a [VoicesCircularProgressIndicator] widget.
  const VoicesCircularProgressIndicator({
    super.key,
    this.value,
    this.showTrack = true,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      strokeCap: StrokeCap.round,
      backgroundColor: showTrack ? null : Colors.transparent,
    );
  }
}
