import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VoicesCountdown extends StatefulWidget {
  final DateTime dateTime;
  final ValueChanged<bool>? onCountdownEnd;
  final ValueChanged<bool>? onCountdownStart;

  const VoicesCountdown({
    super.key,
    required this.dateTime,
    this.onCountdownEnd,
    this.onCountdownStart,
  });

  @override
  State<VoicesCountdown> createState() => _VoicesCountdownState();
}

class _TimePartCard extends StatelessWidget {
  final int value;
  final String unit;

  const _TimePartCard({
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 167,
      width: 144,
      decoration: BoxDecoration(
        color: context.colors.onSurfaceSecondary08,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              height: 1,
              color: context.colorScheme.primary,
            ),
          ),
          Text(
            unit.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.24,
              height: 1,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VoicesCountdownState extends State<VoicesCountdown> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
  bool _hasStarted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TimePartCard(
          value: _timeLeft.inDays,
          unit: context.l10n.days,
        ),
        _TimePartCard(
          value: _timeLeft.inHours % 24,
          unit: context.l10n.hours,
        ),
        _TimePartCard(
          value: _timeLeft.inMinutes % 60,
          unit: context.l10n.minutes,
        ),
        _TimePartCard(
          value: _timeLeft.inSeconds % 60,
          unit: context.l10n.seconds,
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant VoicesCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dateTime != oldWidget.dateTime) {
      _timer.cancel();
      _startCountdown();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final initialTimeLeft = widget.dateTime.difference(DateTime.now());

    if (initialTimeLeft.isNegative || _hasStarted) {
      widget.onCountdownStart?.call(false);
      return;
    }
    setState(() {
      _timeLeft = initialTimeLeft;
    });
    _hasStarted = true;
    widget.onCountdownStart?.call(true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final diff = widget.dateTime.difference(now);

      if (diff.isNegative) {
        _timer.cancel();
        setState(() {
          _timeLeft = Duration.zero;
        });
        widget.onCountdownEnd?.call(true);
      } else {
        setState(() {
          _timeLeft = diff;
        });
      }
    });
  }
}
