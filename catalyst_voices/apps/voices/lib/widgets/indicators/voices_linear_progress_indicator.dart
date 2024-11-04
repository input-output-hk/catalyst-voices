import 'package:flutter/material.dart';

/// Animated version of [VoicesLinearProgressIndicator].
class AnimatedVoicesLinearProgressIndicator extends StatelessWidget {
  /// The current progress value, from 0.0 to 1.0.
  final double value;

  /// Whether to show the progress indicator's track.
  final bool showTrack;

  const AnimatedVoicesLinearProgressIndicator({
    super.key,
    required this.value,
    this.showTrack = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return VoicesLinearProgressIndicator(
          value: value,
          showTrack: showTrack,
        );
      },
    );
  }
}

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
