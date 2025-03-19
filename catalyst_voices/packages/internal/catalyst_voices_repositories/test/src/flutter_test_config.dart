import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  open
    ..overrideFor(OperatingSystem.linux, _openOnLinux)
    ..overrideFor(OperatingSystem.macOS, _openOnMacOS);

  await testMain();
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
