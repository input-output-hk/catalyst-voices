import 'dart:ffi' show DynamicLibrary;
import 'dart:io' show File, Platform;

import 'package:sqlite3/open.dart' as sqlite3 show open, OperatingSystem;

void setupSqlite3() {
  sqlite3.open
    ..overrideFor(sqlite3.OperatingSystem.linux, _openOnLinux)
    ..overrideFor(sqlite3.OperatingSystem.macOS, _openOnMacOS);
}

DynamicLibrary _openOnLinux() {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final path = '${scriptDir.path}/test/sqlite/linux/libsqlite3.so.3.49.1';
  final libraryNextToScript = File(path);
  return DynamicLibrary.open(libraryNextToScript.path);
}

DynamicLibrary _openOnMacOS() {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final path = '${scriptDir.path}/test/sqlite/macOS/libsqlite3.3.49.1.dylib';
  final libraryNextToScript = File(path);
  return DynamicLibrary.open(libraryNextToScript.path);
}
