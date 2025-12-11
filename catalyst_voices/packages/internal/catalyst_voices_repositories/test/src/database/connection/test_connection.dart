import 'package:drift/drift.dart';

import '../executor/unsupported.dart'
    if (dart.library.js_interop) '../executor/web.dart'
    if (dart.library.ffi) '../executor/native.dart';
import '../logging_db_interceptor.dart';

Future<DatabaseConnection> buildTestConnection({
  bool logQueries = false,
}) async {
  final executor = await buildExecutor();

  var connection = DatabaseConnection(
    executor,
    closeStreamsSynchronously: true,
  );

  if (logQueries) {
    connection = connection.interceptWith(LoggingDbInterceptor());
  }

  return connection;
}
