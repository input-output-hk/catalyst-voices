import 'package:flutter_test/flutter_test.dart';

import '../../drift_test_platforms.dart';
import 'unsupported.dart'
    if (dart.library.io) 'native.dart'
    if (dart.library.js_interop) 'web.dart';

void main() {
  group(
    'migration',
    migrationBody,
    skip: driftSkip,
  );
}
