import 'dart:async';

import 'package:flutter/foundation.dart';

/// A utility to debounce (throttle) events.
final class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({
    this.delay = const Duration(milliseconds: 200),
  });

  void dispose() {
    _cancel();
  }

  void run(VoidCallback callback) {
    _cancel();

    if (delay == Duration.zero) {
      callback();
    } else {
      _timer = Timer(delay, callback);
    }
  }

  void _cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
