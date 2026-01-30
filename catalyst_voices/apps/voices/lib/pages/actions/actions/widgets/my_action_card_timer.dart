import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class MyActionCardTimer extends StatefulWidget {
  final Duration? duration;

  const MyActionCardTimer({super.key, this.duration});

  @override
  State<MyActionCardTimer> createState() => _MyActionCardTimerState();
}

class _MyActionCardTimerState extends State<MyActionCardTimer> {
  Duration _remainingDuration = Duration.zero;
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();
  Duration _initialDuration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    if (widget.duration == null) {
      return AffixDecorator(
        prefix: VoicesAssets.icons.clock.buildIcon(
          size: 18,
          color: context.colors.iconsBackground,
        ),
        child: Text(
          context.l10n.votingTimelineToBeAnnounced,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.textOnPrimaryWhite,
          ),
        ),
      );
    }

    if (_remainingDuration <= Duration.zero) {
      return const Offstage();
    }

    return AffixDecorator(
      prefix: VoicesAssets.icons.clock.buildIcon(
        size: 18,
        color: context.colors.iconsBackground,
      ),
      child: PlaceholderRichText(
        context.l10n.remaining('{duration}'),
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colors.textOnPrimaryWhite,
        ),
        placeholderSpanBuilder: (context, placeholder) {
          return switch (placeholder) {
            'duration' => TextSpan(
              text: DurationFormatter.formatDurationDaysOrHHmm(
                context.l10n,
                _remainingDuration,
              ),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textOnPrimaryWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
            _ => throw ArgumentError('Unknown placeholder', placeholder),
          };
        },
      ),
    );
  }

  @override
  void didUpdateWidget(MyActionCardTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _initialDuration = widget.duration ?? Duration.zero;
      _remainingDuration = widget.duration ?? Duration.zero;
      _timer?.cancel();
      _stopwatch.reset();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initialDuration = widget.duration ?? Duration.zero;
    _remainingDuration = widget.duration ?? Duration.zero;
    _startTimer();
  }

  void _startTimer() {
    if (widget.duration == null || _initialDuration == Duration.zero) {
      return;
    }

    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingDuration = _initialDuration - _stopwatch.elapsed;
        if (_remainingDuration.isNegative) {
          _stopwatch.stop();
          timer.cancel();
        }
      });
    });
  }
}
