import 'package:drift/drift.dart';

Future<QueryExecutor> buildExecutor() async {
  // TODO(damian-molinski): uncomment when we'll have a way to serve
  // files using flutter test
  /*final sqlite3Uri = Uri.parse(
    'https://github.com/simolus3/sqlite3.dart/releases#:~:text=Feb%2024-,sqlite3.wasm,-690%20KB',
  );
  final sqlite3 = await WasmSqlite3.loadFromUrl(sqlite3Uri);
  sqlite3.registerVirtualFileSystem(InMemoryFileSystem(), makeDefault: true);

  return WasmDatabase.inMemory(sqlite3);*/

  // For integration test reference
  // see https://github.com/simolus3/drift/issues/1592
  throw UnsupportedError(
    'Drift does is not testable in unit tests for web, because it requires '
    'sqlite3.v1.wasm to be served with specific headers and this is '
    'not possible in flutter test. '
    'Its possible to test drift on web but we would need to convert existing '
    'unit tests to integration tests with widgets',
  );
}
