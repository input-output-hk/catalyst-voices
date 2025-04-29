import 'package:drift/drift.dart';

import '../executor/unsupported.dart'
    if (dart.library.js_interop) '../executor/web.dart'
    if (dart.library.ffi) '../executor/native.dart';

Future<DatabaseConnection> buildTestConnection() async {
  final executor = await buildExecutor();

  return DatabaseConnection(
    executor,
    closeStreamsSynchronously: true,
  );
}
