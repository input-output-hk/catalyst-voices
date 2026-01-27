import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef CountdownBuilder =
    Widget Function(
      BuildContext context, {
      required ValueListenable<int> days,
      required ValueListenable<int> hours,
      required ValueListenable<int> minutes,
      required ValueListenable<int> seconds,
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
  bool _hasStarted = false;

  final _days = ValueNotifier<int>(0);
  final _hours = ValueNotifier<int>(0);
  final _minutes = ValueNotifier<int>(0);
  final _seconds = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      days: _days,
      hours: _hours,
      minutes: _minutes,
      seconds: _seconds,
    );
  }

  @override
  void didUpdateWidget(covariant VoicesCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dateTime != oldWidget.dateTime) {
      _timer?.cancel();
      _timer = null;
      _hasStarted = false;
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _days.dispose();
    _hours.dispose();
    _minutes.dispose();
    _seconds.dispose();
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
      _updateValues(Duration.zero);
      widget.onCountdownEnd?.call(true);
    } else {
      _updateValues(diff);
    }
  }

  void _updateValues(Duration diff) {
    final newDays = diff.inDays;
    final newHours = diff.inHours % Duration.hoursPerDay;
    final newMinutes = diff.inMinutes % Duration.minutesPerHour;
    final newSeconds = diff.inSeconds % Duration.secondsPerMinute;

    // Only notify listeners if value actually changed
    if (_days.value != newDays) _days.value = newDays;
    if (_hours.value != newHours) _hours.value = newHours;
    if (_minutes.value != newMinutes) _minutes.value = newMinutes;
    if (_seconds.value != newSeconds) _seconds.value = newSeconds;
  }

  void _startCountdown() {
    final initialTimeLeft = widget.dateTime.difference(DateTimeExt.now());

    if (initialTimeLeft.isNegative || _hasStarted) {
      widget.onCountdownStart?.call(false);
      return;
    }
    _updateValues(initialTimeLeft);
    _hasStarted = true;
    widget.onCountdownStart?.call(true);

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }
}
