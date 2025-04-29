import 'dart:async';

import 'database/open/unsupported.dart'
    if (dart.library.js_interop) 'database/open/web.dart'
    if (dart.library.ffi) 'database/open/native.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setupSqlite3();

  await testMain();
}
