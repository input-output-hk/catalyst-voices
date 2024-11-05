import 'dart:async';

import 'package:flutter/foundation.dart';

final class RouterRefreshStream extends ChangeNotifier {
  final Stream<dynamic> _stream;
  StreamSubscription<dynamic>? _streamSub;

  RouterRefreshStream(this._stream) {
    _streamSub = _stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    unawaited(_streamSub?.cancel());
    _streamSub = null;
    super.dispose();
  }
}
