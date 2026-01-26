import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef CountdownBuilder =
    Widget Function(
      BuildContext context, {
      required int days,
      required int hours,
      required int minutes,
      required int seconds,
    });

class VoicesCountdown extends StatefulWidget {
  final DateTime dateTime;
  final CountdownBuilder builder;
  final ValueChanged<bool>? onCountdownEnd;
  final ValueChanged<bool>? onCountdownStart;

  const VoicesCountdown({
    super.key,
    required this.dateTime,
    required this.builder,
    this.onCountdownEnd,
    this.onCountdownStart,
  });

  @override
  State<VoicesCountdown> createState() => _VoicesCountdownState();
}

class _VoicesCountdownState extends State<VoicesCountdown> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  bool _hasStarted = false;

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      days: _timeLeft.inDays,
      hours: _timeLeft.inHours % Duration.hoursPerDay,
      minutes: _timeLeft.inMinutes % Duration.minutesPerHour,
      seconds: _timeLeft.inSeconds % Duration.secondsPerMinute,
    );
  }

  @override
  void didUpdateWidget(covariant VoicesCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dateTime != oldWidget.dateTime) {
      _timer?.cancel();
      _timer = null;
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _onTick(Timer timer) {
    final now = DateTimeExt.now();
    final diff = widget.dateTime.difference(now);

    if (diff.isNegative) {
      _timer?.cancel();
      setState(() {
        _timeLeft = Duration.zero;
      });
      widget.onCountdownEnd?.call(true);
    } else {
      setState(() {
        _timeLeft = diff;
      });
    }
  }

  void _startCountdown() {
    final initialTimeLeft = widget.dateTime.difference(DateTimeExt.now());

    if (initialTimeLeft.isNegative || _hasStarted) {
      widget.onCountdownStart?.call(false);
      return;
    }
    setState(() {
      _timeLeft = initialTimeLeft;
    });
    _hasStarted = true;
    widget.onCountdownStart?.call(true);

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }
}
