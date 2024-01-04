import 'dart:async';

import 'package:flutter/material.dart';

final class AppRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<Object> _subscription;

  AppRouterRefreshStream(Stream<Object> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}
