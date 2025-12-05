import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const _browserSkipReason =
    'Web drift requires sqlite3.wasm but flutter test does not allow '
    'to serve files while testing on browser.';

final driftOnPlatforms = <String, dynamic>{
  'browser': const Skip(_browserSkipReason),
};

String? get driftSkip => kIsWeb ? _browserSkipReason : null;
