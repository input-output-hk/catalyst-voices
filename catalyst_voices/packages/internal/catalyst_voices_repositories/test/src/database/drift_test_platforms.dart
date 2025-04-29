import 'package:flutter_test/flutter_test.dart';

final driftOnPlatforms = <String, dynamic>{
  'browser': const Skip(
    'Web drift requires sqlite3.wasm but flutter test does not allow '
    'to serve files while testing on browser.',
  ),
};
