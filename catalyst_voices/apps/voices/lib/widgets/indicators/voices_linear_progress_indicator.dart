import 'package:catalyst_voices/widgets/indicators/voices_progress_indicator_type.dart';
import 'package:flutter/material.dart';

/// Animated version of [VoicesLinearProgressIndicator].
class AnimatedVoicesLinearProgressIndicator extends StatelessWidget {
  /// The current progress value, from 0.0 to 1.0.
  final double value;

  /// Whether to show the progress indicator's track.
  final bool showTrack;

  /// The type of the progress indicator.
  final VoicesProgressIndicatorType type;

  const AnimatedVoicesLinearProgressIndicator({
    super.key,
    required this.value,
    this.showTrack = true,
    this.type = VoicesProgressIndicatorType.medium,
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
          type: type,
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

  /// The type of the progress indicator.
  final VoicesProgressIndicatorType type;

  /// Creates a [VoicesLinearProgressIndicator] widget.
  const VoicesLinearProgressIndicator({
    super.key,
    this.value,
    this.showTrack = true,
    this.type = VoicesProgressIndicatorType.medium,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      borderRadius: BorderRadius.circular(5),
      minHeight: type.minHeight,
      backgroundColor: showTrack ? null : Colors.transparent,
    );
  }
}
