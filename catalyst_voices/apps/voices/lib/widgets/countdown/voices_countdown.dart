import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef CountdownBuilder = Widget Function(
  BuildContext context,
  int days,
  int hours,
  int minutes,
  int seconds,
);

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
      _timeLeft.inDays,
      _timeLeft.inHours % 24,
      _timeLeft.inMinutes % 60,
      _timeLeft.inSeconds % 60,
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
    super.dispose();
    _timer?.cancel();
    _timer = null;
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
    });
  }
}
