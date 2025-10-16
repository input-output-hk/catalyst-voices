import 'dart:ffi' show Abi, DynamicLibrary;
import 'dart:io' show File, Platform;

import 'package:sqlite3/open.dart' as sqlite3 show open, OperatingSystem;

void setupSqlite3() {
  sqlite3.open
    ..overrideFor(sqlite3.OperatingSystem.linux, _openOnLinux)
    ..overrideFor(sqlite3.OperatingSystem.macOS, _openOnMacOS);
}

DynamicLibrary _openOnLinux() {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final path = switch (Abi.current()) {
    Abi.linuxArm64 => '${scriptDir.path}/test/sqlite/linux/libsqlite3.3.49.1-arm64.so',
    Abi.linuxX64 => '${scriptDir.path}/test/sqlite/linux/libsqlite3.3.49.1-amd64.so',
    _ => throw UnsupportedError('ABI ${Abi.current()} does not support libsqlite3.'),
  };
  return DynamicLibrary.open(path);
}

DynamicLibrary _openOnMacOS() {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final path = '${scriptDir.path}/test/sqlite/macOS/libsqlite3.3.49.1.dylib';
  return DynamicLibrary.open(path);
}
