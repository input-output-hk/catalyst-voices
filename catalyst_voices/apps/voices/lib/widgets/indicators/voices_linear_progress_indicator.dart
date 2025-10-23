import 'package:catalyst_voices/widgets/indicators/voices_progress_indicator_weight.dart';
import 'package:flutter/material.dart';

/// Animated version of [VoicesLinearProgressIndicator].
class AnimatedVoicesLinearProgressIndicator extends StatelessWidget {
  /// The current progress value, from 0.0 to 1.0.
  final double value;

  /// Whether to show the progress indicator's track.
  final bool showTrack;

  /// The weight of the progress indicator.
  final VoicesProgressIndicatorWeight weight;

  /// The duration of the animation when the progress value changes.
  final Duration animationDuration;

  /// The curve of the animation when the progress value changes.
  final Curve animationCurve;

  const AnimatedVoicesLinearProgressIndicator({
    super.key,
    required this.value,
    this.showTrack = true,
    this.weight = VoicesProgressIndicatorWeight.medium,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: animationDuration,
      curve: animationCurve,
      builder: (context, value, _) {
        return VoicesLinearProgressIndicator(
          value: value,
          showTrack: showTrack,
          weight: weight,
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

  /// The weight of the progress indicator.
  final VoicesProgressIndicatorWeight weight;

  /// Creates a [VoicesLinearProgressIndicator] widget.
  const VoicesLinearProgressIndicator({
    super.key,
    this.value,
    this.showTrack = true,
    this.weight = VoicesProgressIndicatorWeight.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: LinearProgressIndicator(
        value: value,
        borderRadius: BorderRadius.circular(5),
        minHeight: weight.minHeight,
        backgroundColor: showTrack ? null : Colors.transparent,
      ),
    );
  }
}
