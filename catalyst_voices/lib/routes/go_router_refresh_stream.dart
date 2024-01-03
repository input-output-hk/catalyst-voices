import 'dart:async';

import 'package:flutter/material.dart';

final class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<Object> _subscription;

  GoRouterRefreshStream(Stream<Object> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}
